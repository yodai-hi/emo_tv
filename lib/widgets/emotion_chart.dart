import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_tv/bloc/comment_bloc.dart';
import 'package:emo_tv/constants/color_constants.dart';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/entities/comment_entity.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/utils/space_box.dart';
import 'package:emo_tv/views/login_screen.dart';
import 'package:emo_tv/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'comment_card.dart';

class EmotionChart extends StatefulWidget {
  EmotionChart({Key key, this.auth, this.channelName}) : super(key: key);

  final Auth auth;
  final String channelName;

  @override
  _EmotionChartState createState() => _EmotionChartState();
}

class _EmotionChartState extends State<EmotionChart> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  final _db = Firestore.instance.collection(SC.FIRE_COLLECTION_CHANNELS);
  String _channelName;



  @override
  void initState() {
    super.initState();
    _channelName = widget.channelName;
  }


  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40,
        ),
        StreamBuilder<DocumentSnapshot>(
            stream: _db.document(_channelName).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text('Loading...'),
                      ],
                    ),
                  );
                default:
                  var last = snapshot.data['emotions'].keys.toList().last;
                  var results = Map<String, double>.from(snapshot.data['emotions'][last]);

                  var sortedKeys = results.keys.toList(growable:false)
                    ..sort((k1, k2) => results[k1].compareTo(results[k2]));
                  LinkedHashMap sortedMap = new LinkedHashMap
                      .fromIterable(sortedKeys, key: (k) => k, value: (k) => results[k]);

                  var index = 0;
                  List<LinearSales> result = [];
                  sortedMap.forEach((k, v){
                    if(index > 2) result.add(LinearSales(index, v.toInt(), k));
                    index++;
                  });

                  List<charts.Series<LinearSales, int>> chartData = [];
                  if (result.length!=0){
                    chartData = [
                      charts.Series<LinearSales, int>(
                        id: 'Sales',
                        domainFn: (LinearSales sales, _) => sales.year,
                        measureFn: (LinearSales sales, _) => sales.sales,
                        data: result.reversed.toList(),
                        labelAccessorFn: (LinearSales row, _) => row.label,
                      )
                    ];
                  }else{
                    chartData = [
                      new charts.Series<LinearSales, int>(
                        id: 'Sales',
                        domainFn: (LinearSales sales, _) => sales.year,
                        measureFn: (LinearSales sales, _) => sales.sales,
                        data: [LinearSales(0, 100, '')],
                      )
                    ];
                  }

                  var chats = Map<String, dynamic>.from(snapshot.data[SC.FIRE_DOCUMENT_THREAD]);

                  List items = [];
                  var keys = chats.keys.toList(growable:false)..sort((k1, k2) => k1.compareTo(k2));
                  LinkedHashMap sorted = new LinkedHashMap
                      .fromIterable(keys, key: (k) => k, value: (k) => chats[k]);
                  sorted.forEach((k, v){
                    items.add(v);
                  });

                  return Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 390,
                            child: charts.PieChart(
                              chartData,
                              animate: false,
                              defaultRenderer: charts.ArcRendererConfig(arcWidth: 35),
//
                            ),
                          ),
                          Positioned(
                            left:12,
                            top:4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: textArray(result),
                            ),
                          ),
                        ],
                      ),
                      SpaceBox(height: 10.0),
                      Stack(
                        children: <Widget>[
                          SizedBox(
                            height: 350,
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Padding(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 35,
                                          height: 35,
                                          child: Image.asset(
                                              SC.ASSET_FACE+items.reversed.toList()[index]['emotion']+'.png'
                                          ),
                                        ),
                                        SpaceBox(width: 15),
                                        Text(
                                          items.reversed.toList()[index]['text'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: CC.MAIN_TEXT
                                          ),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10.0),),
                                );},
                              itemCount: items.reversed.toList().length,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
              }
            }
        )
      ],
    );
  }

  List<Widget> textArray(List<LinearSales> result){
    List<Widget> texts = [];
    int index = 1;
    result.reversed.toList().forEach((item){
      texts.add(
          Text(
            index.toString() + ':' + item.label,
            style: TextStyle(
              color: CC.TITLE_TEXT,
              fontSize: 18,
            ),
          )
      );
      index++;
    });

    return texts;
  }


}
