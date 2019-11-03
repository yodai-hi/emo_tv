import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/entities/emotion_entity.dart';
import 'package:emo_tv/utils/camera_image_converter.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/utils/space_box.dart';
import 'package:emo_tv/utils/yuv_converter.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'face_detector_painters.dart';
import '../bloc/emotion_detect_helper.dart';


typedef Result2VoidFunc = void Function(DetectResult);


class EmotionDetector extends StatefulWidget {
  EmotionDetector({
    Key key,
    this.auth,
    this.channelName,
  }) : super(key: key);

  final Auth auth;
  final String channelName;

  @override
  State<StatefulWidget> createState() => _EmotionDetectorState();
}

class _EmotionDetectorState extends State<EmotionDetector> {
  int _detectedTime;

  dynamic _scanResults;
  Timer _timer;
  Size _imageSize;
  Rect _faceRects;

  CameraController _camera;
  bool _isDetecting = false;
  CameraImage _detectImage;
  CameraLensDirection _direction = CameraLensDirection.front;

  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector();
  final _db = Firestore.instance.collection(SC.FIRE_COLLECTION_USERS);

  var _uid = '';
  String _channelName = '';
  var _emotionResult = 'calm';
  var _emotionPossibility = 0.0;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _timer = new Timer.periodic(const Duration(seconds: 2), setTime);
    _channelName = widget.channelName;
    getUse();
  }

  Future getUse() async {
    _uid = await widget.auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: 100,
            ),
            ClipOval(
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 9/16,
                  widthFactor: 1.0,
                  child: SizedBox(
                      height: 480.0,
                      width: 270,
                      child: _buildImage()
                  ),
                ),
              ),
            ),
          ],
        ),
        emotionState(),
      ],
    );
  }

  @override
  void dispose() {
    _camera.dispose().then((_) {
      _faceDetector.close();
    });
    _timer.cancel();
    super.dispose();
  }

  void setTime(Timer timer) {
    _detectedTime = DateTime.now().toUtc().millisecondsSinceEpoch~/1000;
    if(_faceRects!=null && _imageSize!=null) _getEmotion(_imageSize, _faceRects);
    setState(() {
      _faceRects = null;
      _imageSize = null;
    });
  }

  void _initializeCamera() async {
    final CameraDescription description =
    await CameraImageConverter.getCamera(_direction);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.high
          : ResolutionPreset.high,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      CameraImageConverter.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          setState(() {
            _scanResults = results;
            _detectImage = image;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildImage() {
    return Container(
      child: _camera == null
          ? Container()
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_camera),
          _buildResults(),
        ],
      ),
    );
  }

  _getEmotion(Size imageSize, Rect rect) {
    Map<String, double> data = {};
    if(_scanResults.length!=0){
      Uint8List image = YuvConverter.yuv420ToGrayBinary(imageSize, _detectImage.planes, rect);
      EmotionDetectHelper.detect(imageByte: image)
          .then(
              (dynamic results) {
            if(results.length!=0) {
              results.forEach((result) {
                data[result.label] = result.confidence;
              });
              DetectResult result = DetectResult(data, _detectedTime);
              String id = result.timestamp.toString();
              _db.document(_uid)
                  .collection(SC.FIRE_COLLECTION_CHANNELS)
                  .document(_channelName)
                  .collection(SC.FIRE_DOCUMENT_CHANNELS)
                  .document(id)
                  .setData(EmotionData.toSnapShot(result));

              getResult(result);
            }
          });
    }
  }

  Future<dynamic> Function(FirebaseVisionImage image) _getDetectionMethod() {
    return _faceDetector.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = Text(SC.NO_RESULT);

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    //Front camera reverse left and right of image
    List<Rect> faceRects = [];
    _scanResults.forEach((face){
      if (_direction == CameraLensDirection.front) {
        faceRects.add(
            Rect.fromLTRB(
              imageSize.width-face.boundingBox.right,
              face.boundingBox.top,
              imageSize.width-face.boundingBox.left,
              face.boundingBox.bottom,
            )
        );
      }else{
        faceRects.add(face.boundingBox);
      }
    });
    if(faceRects.length!=0){
      setState(() {
        _faceRects = faceRects[0];
        _imageSize = imageSize;
      });
    }
    painter = FaceDetectorPainter(imageSize, faceRects);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget emotionState(){
    if(_emotionPossibility > 50){
      return Row(
        children: <Widget>[
          SpaceBox(width: 300,),
          Column(
            children: <Widget>[
              SpaceBox(height: 350,),
              Container(
                  child: SizedBox(
                      height: 75,
                      width: 100,
                      child: Image.asset(SC.ASSET_FACE+_emotionResult+'.png')
                  )
              ),
            ],
          ),
        ],
      );
    }else{
      return Row(
          children: <Widget>[
            SpaceBox(width: 300,),
            Column(
                children: <Widget>[
                  SpaceBox(height: 350,),
                  Container(
                      child: SizedBox(
                          height: 75,
                          width: 100,
                          child: Image.asset(SC.ASSET_FACE+'calm.png')
                      )
                  ),
                ])
          ]
      );
    }
  }

  void getResult(DetectResult result){
    setState(() {
      _emotionResult = result.emotion.keys.toList()[0];
      _emotionPossibility = result.emotion.values.toList()[0];
    });
  }
}
