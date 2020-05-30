import 'dart:io';

import 'package:blooddonate/src/models/user.dart';
import 'package:blooddonate/src/view_models/signup_viewmodel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController, _passwordController, _phoneController, _fullNameController, _addressController;
  var dropDownSelected = 'A+';
  SignUpViewModel _signUpViewModel = SignUpViewModel();
  bool inProgress = false;
  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) async{
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                        image: FileImage(snapshot.data),
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
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: InkWell(
                  onTap: (){
                    pickImageFromGallery(ImageSource.gallery);
                  },
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
                ),
              )
            ],
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Stack(
            children: <Widget>[
              Container(
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
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: InkWell(
                  onTap: (){
                    pickImageFromGallery(ImageSource.gallery);
                  },
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
                ),
              )
            ],
          );
        }
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                showImage(),
                Container(
                  margin: EdgeInsets.only(left: 16,right: 16,top: 20,),
                  child: TextField(
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
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,),
                  child: TextField(
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                      prefixIcon: Icon(
                          Icons.email
                      ),
                    ),
                    style: TextStyle(
                      letterSpacing: .8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      hintText: 'Password',
                      labelText: 'Password',
                      prefixIcon: Icon(
                          Icons.vpn_key
                      ),
                    ),
                    style: TextStyle(
                      letterSpacing: .8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,),
                  child: TextField(
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    value: 'A+',
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width-32,
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: ()async{
                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text.trim());
                      if (_phoneController.text.trim().length >=10){
                        if (_fullNameController.text.trim().isNotEmpty){
                          if (emailValid){
                            if (_passwordController.text.length >=6){
                              if (_addressController.text.trim().isNotEmpty){
                                setState(() {
                                  inProgress = true;
                                });
                                var result = await _signUpViewModel.createNewUser(_emailController.text.trim(), _passwordController.text);
                                User user = User(
                                    email: _emailController.text.trim(),
                                    name: _fullNameController.text.trim(),
                                    address: _addressController.text.trim(),
                                    bloodGroup: dropDownSelected,
                                    phone: _phoneController.text.trim(),
                                    uid: _signUpViewModel.firebaseUser.uid
                                );
                                if (result){
                                  String imageUrl;
                                  if (imageFile!= null){
                                    //imageUrl = await _signUpViewModel.uploadImage(imageFile);
                                  }
                                  var uploadData = await _signUpViewModel.uploadUserData(user, image: imageUrl);
                                  if (uploadData){
                                    setState(() {
                                      inProgress = false;
                                    });
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Home()));
                                  } else {
                                    setState(() {
                                      inProgress = false;
                                    });
                                    BotToast.showText(
                                        text: _signUpViewModel.errorMessage,
                                        contentColor: Colors.red,
                                        textStyle: TextStyle(
                                            color: Colors.white
                                        )
                                    );
                                  }
                                }  else {
                                  setState(() {
                                    inProgress = false;
                                  });
                                  BotToast.showText(
                                      text: _signUpViewModel.errorMessage,
                                      contentColor: Colors.red,
                                      textStyle: TextStyle(
                                          color: Colors.white
                                      )
                                  );
                                }
                              } else {
                                BotToast.showText(
                                    text: 'Enter your current address!',
                                    contentColor: Colors.red,
                                    textStyle: TextStyle(
                                        color: Colors.white
                                    )
                                );
                              }
                            } else {
                              BotToast.showText(
                                  text: 'Enter password more than 6 letters',
                                contentColor: Colors.red,
                                textStyle: TextStyle(
                                  color: Colors.white
                                )
                              );
                            }
                          } else {
                            BotToast.showText(
                                text: 'Enter a valid email!',
                                contentColor: Colors.red,
                                textStyle: TextStyle(
                                    color: Colors.white
                                )
                            );
                          }
                        } else {
                          BotToast.showText(
                              text: 'Enter your full name',
                              contentColor: Colors.red,
                              textStyle: TextStyle(
                                  color: Colors.white
                              )
                          );
                        }
                      } else {
                        BotToast.showText(
                            text: 'Enter a valid phone number!',
                            contentColor: Colors.red,
                            textStyle: TextStyle(
                                color: Colors.white
                            )
                        );
                      }
                    },
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                          'SIGN UP',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Already member? Sign in!',
                    style: TextStyle(
                        fontSize: 16
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
