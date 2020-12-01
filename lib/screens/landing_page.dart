import 'package:comma/screens/home_page.dart';
import 'package:comma/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          //conection to firebase
          if (snapshot.connectionState == ConnectionState.done) {
            //it checks the login status live
            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, streamsnapshot) {
                //streamsnapshot has error
                if (streamsnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${streamsnapshot.error}"),
                    ),
                  );
                }
                //Connection state active
                if (streamsnapshot.connectionState == ConnectionState.active) {
                  User _user = streamsnapshot.data;
                  //if the user is null, we will not be logged in
                  if (_user == null) {
                    //user is not logged in
                    return Loginpage();
                  } else {
                    //user is logged in
                    return Homepage();
                  }
                }
                //checking the auth state
                return Scaffold(
                  body: Container(
                    child: Center(
                      child: Text('Checking authentication',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                    ),
                  ),
                );
              },
            );
          }
          //Connecting to firebase - loading..
          return Scaffold(
            body: Container(
              child: Center(child: Text('Initialization App...')),
            ),
          );
        });
  }
}
