import 'package:blooddonate/src/ui/home.dart';
import 'package:blooddonate/src/ui/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Home();
          } else {
            return SignIn();
          }
        });
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }
}