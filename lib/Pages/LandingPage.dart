import 'package:agrozon/Pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'SignInPage.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Widget body() {
    //TODO optimize
    User currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      return HomePage();
    } else {
      return SignInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}
