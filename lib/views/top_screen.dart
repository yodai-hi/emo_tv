import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emo_tv/constants/color_constants.dart';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/views/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'main_screen.dart';

class TopScreen extends StatefulWidget {
  TopScreen({Key key, this.auth}) : super(key: key);

  final Auth auth;

  @override
  _TopScreenState createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  String _email;
  Auth _auth;
  var _uid = '';


  @override
  void initState() {
    super.initState();
    widget.auth.currentUserEmail().then((email) {
      setState(() {
        authStatus =
        email != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        _email = email;
      });
    });

    _auth = widget.auth;
    getUse();
  }

  Future getUse() async {
    _uid = await widget.auth.currentUser();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SC.TEXT_APPLICATION_NAME,
          style: TextStyle(
            color: CC.TITLE_TEXT,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: CC.TITLE_TEXT,
            ),
            onPressed: () {
              showLogOutDialog(context);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: channels(),
    );
  }


  Widget channels(){
    if(_uid=='') return Container();
    else return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(SC.FIRE_COLLECTION_CHANNELS).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              var joinData = [];
              snapshot.data.documents.forEach((item) {
                joinData.add(item['join']);
              });
              return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  children: List.generate(snapshot.data.documents.length, (index) {
                    return InkWell(
                      onTap: () async {
                        DocumentSnapshot numbers =
                        await Firestore
                            .instance
                            .collection(SC.FIRE_COLLECTION_CHANNELS)
                            .document(snapshot.data.documents[index].documentID)
                            .get();

                        Firestore
                            .instance
                            .collection(SC.FIRE_COLLECTION_CHANNELS)
                            .document(snapshot.data.documents[index].documentID)
                            .updateData({'join': numbers.data['join']+1});

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              MainScreen(auth: _auth, channelName: snapshot.data.documents[index].documentID,)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Container(
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                color: CC.MAIN,
                              ),
                              child: GridTile(
                                  header: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
                                    child: Center(
                                      child: Text(
                                        snapshot.data.documents[index].documentID,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: CC.TITLE_TEXT,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Image.asset(
                                    SC.ASSET_IMAGE+'$index.png',
                                    fit:BoxFit.fitWidth,
                                  ),
                                  footer: Container(
                                    height: 44.0,
                                    color: CC.BASE,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 12.0),
                                        child: Text(
                                          '現在の人数：${joinData[index]} 人',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: CC.MAIN_TEXT
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              )
                          ),
                        ),
                      ),
                    );
                  }
                  ));
          }
        }
    );
  }


  void showLogOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text(SC.TEXT_STATE_CHECK),
            content: logOutText(),
            actions: <Widget>[
              FlatButton(
                  child: const Text(SC.TEXT_BTN_CANCEL),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
              FlatButton(
                  child: const Text(SC.TEXT_BTN_SIGN_OUT),
                  onPressed: () async {
                    _auth.signOut();
                    Navigator.pushReplacement (
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  }
              ),
            ],
          ),
    );
  }

  Widget logOutText(){
    Widget text;
    if(_email!=null) text = Text(SC.TEXT_CURRENT_LOG_IN +_email);
    else text = Text(SC.TEXT_SIGN_ERROR);
    return text;
  }
}
