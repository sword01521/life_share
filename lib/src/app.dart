import 'package:blooddonate/src/services/authservice.dart';
import 'package:blooddonate/src/ui/profile.dart';
import 'package:blooddonate/src/view_models/profile_viewmodel.dart';
import 'package:blooddonate/src/view_models/signup_viewmodel.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}
