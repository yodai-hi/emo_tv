import 'package:emo_tv/constants/color_constants.dart';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/utils/space_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class CommentCard extends StatefulWidget {
  CommentCard({Key key, this.result}) : super(key: key);

  List<dynamic> result;

  @override
  State<StatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  List<dynamic> _result = [];

  @override
  void initState() {
    super.initState();
    _result = widget.result;
  }


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
                        SC.ASSET_FACE+_result[index]['emotion']+'.png'
                    ),
                  ),
                  SpaceBox(width: 15),
                  Text(
                      _result[index]['text'],
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
        itemCount: _result.length,
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }
}
