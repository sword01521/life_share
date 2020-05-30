import 'package:blooddonate/src/models/user.dart';
import 'package:blooddonate/src/services/authservice.dart';
import 'package:blooddonate/src/ui/change_password.dart';
import 'package:blooddonate/src/view_models/profile_viewmodel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool inProgress = false;
  Firestore _fireStore = Firestore.instance;
  String _name, _bloodGroup, _phone, _email, _address, uid;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<bool> getProfileDetails() async{
    try {
      setState(() {
        inProgress = true;
      });
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      uid = user.uid;
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
          setState(() {
            inProgress = false;
          });
        });
      return true;
    } catch (e){
      BotToast.showText(
        text: e.toString(),
        contentColor: Colors.red,
        textStyle: TextStyle(
          color: Colors.white
        )
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                            Icons.refresh
                        ),
                        onPressed: (){
                          getProfileDetails();
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      Hero(
                        tag: 'profile-img',
                        child: Container(
                          width: 100,
                          height: 100,
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
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${_name}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_bloodGroup}',
                            style: TextStyle(
                                color: Colors.black54
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_phone}',
                            style: TextStyle(
                                color: Colors.black54
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${_address}',
                            style: TextStyle(
                                color: Colors.black54
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlineButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) => EditProfile(user: User(
                                      address: _address,
                                      bloodGroup: _bloodGroup,
                                      uid: uid,
                                      phone: _phone,
                                      name: _name,
                                      email: _email
                                  ),)
                              ));
                            },
                            child: Text('Edit'),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 2,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.info_outline, color: Colors.red,),
                          title: Text('About us'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(Icons.security, color: Colors.red,),
                          title: Text('Privacy and Policy'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) => ChangePassword(user: User(
                                  address: _address,
                                  bloodGroup: _bloodGroup,
                                  uid: uid,
                                  phone: _phone,
                                  name: _name,
                                  email: _email
                              ),)
                            ));
                          },
                          leading: Icon(Icons.vpn_key, color: Colors.red,),
                          title: Text('Change Password'),
                        ),
                        Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(Icons.exit_to_app, color: Colors.red,),
                          title: Text('Logout'),
                          onTap: (){
                            AuthService().signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

