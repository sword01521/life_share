import 'package:blooddonate/src/models/user.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicator_button/progress_button.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({this.user});
  final User user;
  @override
  _ChangePasswordState createState() => _ChangePasswordState(user: user);
}

class _ChangePasswordState extends State<ChangePassword> {
  _ChangePasswordState({this.user});
  final User user;

  TextEditingController _currentPasswordController, _newPasswordController;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
                      'Change Password',
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
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)
                            ),
                            hintText: 'New Password',
                            labelText: 'New Password',
                            prefixIcon: Icon(
                                Icons.vpn_key
                            ),
                          ),
                          style: TextStyle(
                            letterSpacing: .8,
                          ),
                        )
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
                      if (_newPasswordController.text.length >= 6){
                        _controller.forward();
                        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
                        user.updatePassword(_newPasswordController.text).whenComplete(() {
                          _controller.reverse();
                          BotToast.showText(
                              text: 'Password update successful!',
                              contentColor: Colors.green,
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          );
                        }).catchError((onError){
                          _controller.reverse();
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
                      } else {
                        BotToast.showText(
                            text: 'Enter password more than 6 letters.',
                            contentColor: Colors.red,
                            textStyle: TextStyle(
                                color: Colors.white
                            )
                        );
                      }

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
