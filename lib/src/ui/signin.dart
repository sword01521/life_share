import 'package:blooddonate/src/ui/forgot_password.dart';
import 'package:blooddonate/src/ui/signup.dart';
import 'package:blooddonate/src/view_models/signin_viewmodel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:progress_indicator_button/progress_button.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController, _passwordController;
  bool inProgress = false;
  SignInViewModel _signInViewModel = SignInViewModel();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inProgress,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/hand.png', height: 150, width: 150,),
            SizedBox(
              width: 20,
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
                onChanged: (value){

                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16,),
              child: TextField(
                controller: _passwordController,
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
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
              width: MediaQuery.of(context).size.width-32,
              child: ProgressButton(
                color: Colors.red,
                onPressed: (AnimationController _controller) async{
                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text.trim());
                  if (emailValid){
                    if (_passwordController.text.length >= 6){
                      _controller.forward();
                      var result = await _signInViewModel.signInUser(_emailController.text.trim(), _passwordController.text);
                      if (result){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Home()));
                      } else {
                        _controller.reverse();
                        BotToast.showText(
                            text: _signInViewModel.errorMessage,
                            contentColor: Colors.red,
                            textStyle: TextStyle(
                                color: Colors.white
                            )
                        );
                      }
                    } else {
                      BotToast.showText(
                          text: 'Enter a password more than 6 letters',
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ForgotPassword()));
              },
              child: Text(
                'Forgot your password? Click here',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => SignUp()
                ));
              },
              child: Text(
                'New user? Create an account now!',
                style: TextStyle(
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
