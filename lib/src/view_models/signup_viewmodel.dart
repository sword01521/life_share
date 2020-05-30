import 'dart:io';

import 'package:blooddonate/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpViewModel{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  FirebaseUser _user;
  String _errorMessage;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  FirebaseUser get firebaseUser => this._user;
  String get errorMessage => this._errorMessage;

  Future<bool> createNewUser(String email, password)async{
    try {
      var _authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_authResult != null){
        _user =  _authResult.user;
        return true;
      }
    } catch (e){
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> uploadUserData(User user, {String image})async{
    try {
      await _firestore.collection('users').add({
        'uid': user.uid,
        'full_name': user.name,
        'email': user.email,
        'phone': user.phone,
        'blood_group': user.bloodGroup,
        'address': user.address,
        'profile-img' : image!=null ? image : 'default'
      });
      return true;
    } catch (e){
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<String> uploadImage(File imageFile)async{
    try {
      StorageReference ref =
      _firebaseStorage.ref().child('users-profile-img');
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      return await (await uploadTask.onComplete).ref.getDownloadURL();
    } catch (e){
      _errorMessage = e.toString();
      return null;
    }
  }

}