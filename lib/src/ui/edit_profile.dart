import 'package:blooddonate/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicator_button/progress_button.dart';

class EditProfile extends StatefulWidget {
  EditProfile({this.user});
  final User user;
  @override
  _EditProfileState createState() => _EditProfileState(user: user);
}

class _EditProfileState extends State<EditProfile> {
  _EditProfileState({this.user});
  final User user;
  var dropDownSelected;
  TextEditingController _fullNameController, _addressController, _phoneController;

  @override
  void initState() {
    super.initState();
    dropDownSelected = user.bloodGroup;
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _fullNameController.text = user.name;
    _addressController.text = user.address;
    _phoneController.text = user.phone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: <Widget>[
                    Hero(
                      tag: 'profile-img',
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                                image: AssetImage('assets/images/user.png'),
                                fit: BoxFit.cover
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 3
                              )
                            ]
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '${user.email}',
                            enabled: false,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: _phoneController,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                            ),
                            hintText: 'XXXXXXXXXX',
                            labelText: 'Phone',
                            prefixIcon: Icon(
                                Icons.phone
                            ),
                            prefixText: '+880',
                          ),
                          maxLength: 10,
                          style: TextStyle(
                            letterSpacing: .8,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _fullNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                            ),
                            hintText: 'Enter your name',
                            labelText: 'Full name',
                            prefixIcon: Icon(
                                Icons.person
                            ),
                          ),
                          style: TextStyle(
                            letterSpacing: .8,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder()
                          ),
                          value: '${user.bloodGroup}',
                          items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              dropDownSelected = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                            ),
                            hintText: 'Area of donate/request',
                            labelText: 'Full Address',
                            prefixIcon: Icon(
                                Icons.location_on
                            ),
                          ),
                          style: TextStyle(
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width-16,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 8),
                  child: ProgressButton(
                    onPressed: (AnimationController _controller) async{
                      _controller.forward();
                      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                      String uid = user.uid;
                      Firestore.instance.collection('users')
                        ..where("uid",isEqualTo: uid)
                            .getDocuments().then((value) {
                          Firestore.instance.collection('users').document(value.documents[0].documentID).updateData(
                              {
                                'full_name': _fullNameController.text.trim(),
                                'blood_group': dropDownSelected,
                                'address': _addressController.text.trim(),
                                'phone': _phoneController.text.trim()
                              }).whenComplete(() {
                                _controller.reverse();
                                Navigator.pop(context);
                          }).catchError((onError){
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(
                                  'Profile edit failed!',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ), backgroundColor: Colors.red,
                                )
                            );
                          });
                        } );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
