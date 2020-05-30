import 'package:blooddonate/src/models/blood_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchBloodViewModel {
  Firestore _fireStore = Firestore.instance;
  String _errorMessage;
  String get errorMessage => this._errorMessage;


  Future<bool> postSearchBlood(BloodRequest bloodRequest) async{
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final uid = user.uid;
      var results = await _fireStore.collection('users')
        ..where("uid",isEqualTo: uid)
            .getDocuments().then((value){
              var data = value.documents[0].data;
            bloodRequest.userName = data['full_name'];
            bloodRequest.phoneNumber = data['phone'];
        }).then((value) async{
          await _fireStore.collection('blood_req').add({
          'name': bloodRequest.userName,
          'blood_group': bloodRequest.bloodGroup,
          'phone': bloodRequest.phoneNumber,
          'address': bloodRequest.address,
          'units': bloodRequest.units,
          'request_message': bloodRequest.requestMessage,
          'uid': uid,
          });
        });

      return true;
    } catch (e){
      _errorMessage = e.toString();
      return false;
    }
  }
}