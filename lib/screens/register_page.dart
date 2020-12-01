import 'package:flutter/material.dart';
import 'package:comma/widgets/custom_button.dart';
import 'package:comma/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Build an alert dialog to display some errors
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: <Widget>[
              // ignore: missing_required_param
              FlatButton(
                child: Text('Close Dialog'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Create a new user account
  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        return 'Password porvided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    //start loading
    setState(() {
      _registerFormLoading = true;
    });
    //create account method
    String _createAccountFeedback = await _createAccount();
    //checks for error
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);
      //stop loading
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  // default form loading state
  bool _registerFormLoading = false;

  //form input field values
  String _registerEmail = "";
  String _registerPassword = "";

  //Focus node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 24.0,
              ),
              child: Text(
                'Create A New Account',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: <Widget>[
                Custominput(
                  hintText: 'Email...',
                  onChanged: (value) {
                    _registerEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                Custominput(
                  hintText: 'Password...',
                  onChanged: (value) {
                    _registerPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: 'Create New Account',
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _registerFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomBtn(
                text: 'Back to Login',
                onPressed: () {
                  Navigator.pop(context);
                },
                outlinedBtn: true,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
