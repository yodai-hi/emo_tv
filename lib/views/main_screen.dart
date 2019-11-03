import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_tv/bloc/comment_bloc.dart';
import 'package:emo_tv/constants/color_constants.dart';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/entities/comment_entity.dart';
import 'package:emo_tv/utils/custom_painter.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/views/top_screen.dart';
import 'package:emo_tv/widgets/emotion_chart.dart';
import 'package:emo_tv/widgets/emotion_detector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.auth, this.channelName}) : super(key: key);

  final Auth auth;
  final String channelName;

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Auth _auth;
  String _channelName = '';
  String _comment = '';
  CommentBloc _bloc;


  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
    _channelName = widget.channelName;
    _bloc = CommentBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CC.TITLE_TEXT,
          ),
          onPressed: () {
            backScreen();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.chat,
              color: CC.TITLE_TEXT,
            ),
            onPressed: () {
//TODO Chat option
            },
          )
        ],
        title: Text(
          _channelName,
          style: TextStyle(
            color: CC.TITLE_TEXT,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: CC.MAIN,
                    ),

                    Container(
                      color: Colors.white,
                      child: CustomPaint(
                        painter: OvalPainter(),
                        child: Container(
                          width: double.infinity,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                    children: <Widget>[
                      Container(
                        height: 235,
                      ),
                      Container(
                        color: Colors.white,
                        child: CustomPaint(
                          painter: CirclePainter(),
                          child: Container(
                            width: double.infinity,
                            height: 0,
                          ),
                        ),
                      ),
                    ]
                ),

                EmotionChart(
                    auth: _auth,
                  channelName: _channelName,
                ),

                EmotionDetector(
                  auth: _auth,
                  channelName: _channelName,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message,
          size: 40,
        ),
        onPressed: () {
          showTextFieldDialog(context);
        },
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
  }

  void showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text(SC.TEXT_STATE_CHECK),
            content: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              maxLength: 20,
              onChanged: (text){
                setState(() {
                  _comment = text;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                  child: const Text(SC.TEXT_BTN_CANCEL),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              FlatButton(
                  child: const Text(SC.TEXT_BTN_SEND),
                  onPressed: () async {
                    _bloc.fetch.add(CommentEntity(_comment));
                    Navigator.pop(context);
                  }
              ),
            ],
          ),
    );
  }


  Future backScreen() async {
    DocumentSnapshot numbers = await Firestore.instance.collection(SC.FIRE_COLLECTION_CHANNELS).document(_channelName).get();
    Firestore
        .instance
        .collection(SC.FIRE_COLLECTION_CHANNELS)
        .document(_channelName)
        .updateData({'join': numbers.data['join']-1});

    Navigator.pop(
      context,
      MaterialPageRoute<Null>(
        builder: (BuildContext context) => TopScreen(auth: _auth),
      ),
    );
  }
}


class LinearSales {
  final int year;
  final int sales;
  final String label;

  LinearSales(this.year, this.sales, this.label);
}
