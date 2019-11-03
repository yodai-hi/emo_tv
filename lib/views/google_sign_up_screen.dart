import 'package:emo_tv/constants/string_constants.dart';
import 'package:emo_tv/utils/mail_auth.dart';
import 'package:emo_tv/utils/primary_button.dart';
import 'package:emo_tv/utils/space_box.dart';
import 'package:flutter/material.dart';

class GoogleSignUp extends StatefulWidget {
  GoogleSignUp({Key key, this.title, this.auth, this.onSignOut, this.onSignIn}) : super(key: key);
  final String title;
  final Auth auth;
  final VoidCallback onSignOut;
  final VoidCallback onSignIn;

  @override
  _GoogleSignUpState createState() => _GoogleSignUpState();
}

enum FormType {
  login,
  register
}

class _GoogleSignUpState extends State<GoogleSignUp> {
  static final _formKey = GlobalKey<FormState>();
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _displayName;
  String _photoUrl = '';
  String _authHint = '';

  bool isValidate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void onPressSignIn() async {
    setState(() {
      _authHint = '';
    });
    widget.onSignOut();
  }


  void onPressSignUp() async {
    setState(() {_authHint = '';});

    if (isValidate()) {
      // No Form Error
      try {
        // Firebase: User Create.
        String userId = await widget.auth.createUser(_email, _password, _displayName, _photoUrl);
        setState(() {_authHint = 'Signed Up\nUser id: $userId';});
        widget.onSignIn();
      }
      catch (e) {
        setState(() {_authHint = 'Sign Up Error\n${e.toString()}';});
      }
    } else {
      setState(() {_authHint = 'Sign Up Error\nNeed to fill Input Form';});
    }

    final snackBar = SnackBar(
      content: Text(_authHint),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  // Input Form
  List<Widget> usernameAndPassword() {
    return [
      padded(child: TextFormField(
        decoration: InputDecoration(labelText: SC.TEXT_NAME),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Name can\'t be empty.' : null,
        onSaved: (val) => _displayName = val,
      )),
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

  // ボタン
  List<Widget> submitWidgets() {
    return [
      SpaceBox(height: 12),
      PrimaryButton(
          text: SC.TEXT_BTN_SIGN_UP,
          height: 44.0,
          onPressed: onPressSignUp
      ),
      FlatButton(
          textColor: Colors.green,
          child: Text(SC.TEXT_FLAT_BTN_SIGN_UP),
          onPressed: onPressSignIn
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            child: Center(
              child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      children: [
                        Card(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: usernameAndPassword() + submitWidgets(),
                                          )
                                      )
                                  ),
                                ])
                        ),
                      ]
                  )
              ),
            ))
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
