import 'dart:async';
import 'package:emo_tv/constants/string_constants.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


abstract class BaseUsers {
  Future<void> create(String uid);
  Future<void> update(String uid);
}

class Users implements BaseUsers {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> create(String uid) async {
    String _token = await _firebaseMessaging.getToken();
    var db = Firestore.instance;

    await db.collection(SC.FIRE_COLLECTION_USERS).document(uid).setData({
      SC.USER_TOKEN: _token,
      SC.USER_CREATED: DateFormat("yyyy/MM/dd HH:mm", "en_US").format(DateTime.now()),
      SC.USER_UPDATED: DateFormat("yyyy/MM/dd HH:mm", "en_US").format(DateTime.now()),
      SC.USER_DELETED: ''
    });
  }

  Future<void> update(String uid) async {
    String _token = await _firebaseMessaging.getToken();
    var db = Firestore.instance;

    await db.collection("users").document(uid).updateData({
      SC.USER_TOKEN: _token,
      SC.USER_UPDATED: DateFormat("yyyy/MM/dd HH:mm", "en_US").format(DateTime.now())
    });
  }

}
