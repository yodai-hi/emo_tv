import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlkit/mlkit.dart';


class Box {
  final double top;
  final double left;
  final double bottom;
  final double right;

  Box(this.top, this.left, this.bottom, this.right);
}

class ObjectDetectionLabel {
  String label;
  double confidence;
  Box box;
  Color color;

  ObjectDetectionLabel([this.label, this.confidence, this.box]);
  ObjectDetectionLabel.box(this.box);
}

class EmotionDetectHelper{

  static Future<dynamic> detect({
    @required Uint8List imageByte,
  }) async {
    return getLabels(imageByte);
  }

  static Future<List<ObjectDetectionLabel>>getLabels(imageByte) async {
    List<String> _localModels = ["emotion_model"];

    int _currentModel = 0;
    Map<String, List<String>> labels = {
      "emotion_model": null,
    };

    Map<String, FirebaseModelInputOutputOptions> _ioOptions = {
      "emotion_model": FirebaseModelInputOutputOptions([
        FirebaseModelIOOption(FirebaseModelDataType.FLOAT32, [1, 48, 48, 1])
      ], [
        FirebaseModelIOOption(FirebaseModelDataType.FLOAT32, [1, 7])
      ]),
    };


    FirebaseModelInterpreter interpreter = FirebaseModelInterpreter.instance;
    FirebaseModelManager manager = FirebaseModelManager.instance;

    _localModels.forEach((model) {
      manager.registerLocalModelSource(FirebaseLocalModelSource(
          modelName: model, assetFilePath: "assets/model/" + model + ".tflite"));
    });

    rootBundle.loadString('assets/model/labels_emotion.txt').then((string) {
      var _l = string.split('\n');
      _l.removeLast();
      labels["emotion_model"] = _l;
    });

    try {
      var options = _ioOptions[_localModels[_currentModel]];
      try {
        List<dynamic> results;
        var factor = 0.01;

        if (options.inputOptions[0].dataType == FirebaseModelDataType.FLOAT32) {
          var bytes = imageByte;
          results = await interpreter.run(
              localModelName: _localModels[_currentModel],
              inputOutputOptions: options,
              inputBytes: bytes);
        }

        List<ObjectDetectionLabel> currentLabels = [];

        for (var i = 0; i < results[0][0].length; i++) {
          if (results[0][0][i] > 0) {
            currentLabels.add(new ObjectDetectionLabel(
                labels[_localModels[_currentModel]][i],
                results[0][0][i] / factor)
            );
          }
        }

        currentLabels.sort((l1, l2) {
          return (l2.confidence - l1.confidence).floor();
        });

        return currentLabels;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
