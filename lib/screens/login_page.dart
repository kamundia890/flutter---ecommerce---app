import 'package:comma/widgets/custom_button.dart';
import 'package:comma/widgets/custom_input.dart';
import 'package:comma/screens/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

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

Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
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
      _loginFormLoading = true;
    });
    //create account method
    String _loginFeedback = await _loginAccount();
    //checks for error
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);
      //stop loading
      setState(() {
        _loginFormLoading = false;
      });
    } 
  }

  // default form loading state
  bool _loginFormLoading = false;

  //form input field values
  String _loginEmail = "";
  String _loginPassword = "";

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
                'Welcome user,\n Login to your account',
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
                    _loginEmail = value;
                  },
                  onSubmitted: (value) {
                    _passwordFocusNode.requestFocus();
                  },
                  textInputAction: TextInputAction.next,
                ),
                Custominput(
                  hintText: 'Password...',
                  onChanged: (value) {
                    _loginPassword = value;
                  },
                  focusNode: _passwordFocusNode,
                  isPasswordField: true,
                  onSubmitted: (value) {
                    _submitForm();
                  },
                ),
                CustomBtn(
                  text: 'Login',
                  onPressed: () {
                    _submitForm();
                  },
                  isLoading: _loginFormLoading,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CustomBtn(
                text: 'Create New Account',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ));
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
