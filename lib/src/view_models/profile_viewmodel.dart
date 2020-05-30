import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewModel{
  Firestore _fireStore = Firestore.instance;
  String _errorMessage, _name, _bloodGroup, _phone, _email, _address;
  String get errorMessage => this._errorMessage;
  String get name => this._name;
  String get bloodGroup => this._bloodGroup;
  String get phone => this._phone;
  String get email => this._email;
  String get address => this._address;


  Future<bool> getProfileDetails() async{
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final uid = user.uid;
      _fireStore.collection('users')
        ..where("uid",isEqualTo: uid)
            .getDocuments().then((value){
          var data = value.documents[0].data;
          _name = data['full_name'];
          _phone = data['phone'];
          _address = data['address'];
          _email = data['email'];
          _bloodGroup = data['blood_group'];
        }).whenComplete(() {
        });
      return true;
    } catch (e){
      _errorMessage = e.toString();
      return false;
    }
  }
}