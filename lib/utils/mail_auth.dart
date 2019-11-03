import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/auth_users.dart';


abstract class MailAuth {

  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password, String displayName, String photoUrl);
  Future<String> currentUser();
  Future<String> currentUserEmail();
  Future<void> signOut();
}

class Auth implements MailAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BaseUsers _users = Users();

  Future<String> signIn(String email, String password) async {
    // Firebase Authentication サインイン↓ (02) サインインの処理
    final user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    // Usersテーブル更新
    await _users.update(user.user.uid);

    return user.user.uid;
  }

  Future<String> createUser(String email, String password, String displayName, String photoUrl) async {

    // Firebase Authentication 登録 & サインイン↓ (0３) 登録 & サインイン
    final user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // Firebase UserInfo 更新↓ (04) AuthenticationのuserInfo更新処理
    UserUpdateInfo info = UserUpdateInfo();
    info.displayName = displayName; // 表示名前
    info.photoUrl = photoUrl;       // 画像URL
    user.user.updateProfile(info);

    // Usersテーブル作成
    await _users.create(user.user.uid);

    return user.user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<String> currentUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.email : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}
