import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/utils/primary_button.dart';
import 'package:emo_tv/utils/space_box.dart';
import 'package:flutter/material.dart';


class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key key, this.title, this.auth, this.onSignIn, this.onSignUp}) : super(key: key);
  final String title;
  final Auth auth;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  static final formKey = GlobalKey<FormState>();
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _authHint = '';
  bool _isSubmitted = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _isSubmitted = true;
    });

    if (validateAndSave()) {
      try {
        String userId = await widget.auth.signIn(_email, _password);
        setState(() {
          _authHint = 'Signed In\nUser id: $userId';
        });
        widget.onSignIn();
      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n${e.toString()}';
          _isSubmitted = false;
        });
      }
    } else {
      setState(() {
        _authHint = 'Sign In Error\nNeed to fill Input Form';
        _isSubmitted = false;
      });
    }

    final snackBar = SnackBar(
      content: Text(_authHint),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void signUpSubmit() async {
    setState(() {
      _authHint = '';
    });
    widget.onSignUp();
  }

  // 入力フォーム
  List<Widget> usernameAndPassword() {
    return [
      padded(child: TextFormField(
        decoration: InputDecoration(labelText: SC.TEXT_EMAIL),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),

      padded(child: TextFormField(
        decoration: InputDecoration(labelText: SC.TEXT_PASSWORD),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    return [
      SpaceBox(height: 12),
      PrimaryButton(
          text: SC.BAR_SIGN_IN,
          height: 44.0,
          onPressed: validateAndSubmit
      ),
      FlatButton(
          textColor: Colors.green,
          child: Text(SC.TEXT_FLAT_BTN_SIGN_IN),
          onPressed: signUpSubmit
      ),
    ];
  }


  Widget loadingView() {
    if (_isSubmitted) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromRGBO(200, 200, 200, 0.5),
        child: Center(
          child: Card(
            child: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: Stack(
            children: [
              SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: usernameAndPassword() + submitWidgets(),
                              )
                          )
                      ),
                    ),
                  )
              ),
              loadingView(),
            ]
        )
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
