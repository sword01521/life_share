import 'package:firebase_auth/firebase_auth.dart';

class SignInViewModel {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _errorMessage;

  String get errorMessage => this._errorMessage;

  Future<bool> signInUser(String email, String password) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch(e){
      _errorMessage = e.toString();
      return false;
    }
  }
}