import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:flutter_chit_chat/sign_in_page.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  UserModel? _userModel;
  final AuthBase authBase = locator<FirebaseAuthService>();

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async{
    _userModel = await authBase.currentUser();
  }

  void updateUser(UserModel? user){
    setState(() {
      _userModel = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_userModel != null){
      return HomePage(
        userModel: _userModel!,
        onSignOut: (){
          updateUser(null);
        }
      );
    }else{
      return SignInPage(
        onSignIn: (user){
          updateUser(user);
        }
      );
    }
  }
}
