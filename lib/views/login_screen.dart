import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/views/top_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'google_sign_in_screen.dart';
import 'google_sign_up_screen.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.auth}) : super(key: key);
  final Auth auth;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

// 状態定義
enum AuthStatus {
  notSignedIn,
  signedIn,
  signedUp
}

class _LoginScreenState extends State<LoginScreen> {
  AuthStatus authStatus = AuthStatus.notSignedIn;


  initState() {
    super.initState();
  }


  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 認証状態に応じて表示する画面を分ける
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        // サインインページ
        return GoogleSignIn(
          title: SC.BAR_SIGN_IN,
          auth: widget.auth,
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
          onSignUp: () => _updateAuthStatus(AuthStatus.signedUp),
        );

      case AuthStatus.signedIn:
        // メインページ
        return TopScreen(auth: widget.auth,);

      case AuthStatus.signedUp:
        // 新規登録ページ
        return GoogleSignUp(
            title: SC.BAR_SIGN_UP,
            auth: widget.auth,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn),
            onSignIn: () => _updateAuthStatus(AuthStatus.signedIn)
        );
    }

    return Container();
  }
}
