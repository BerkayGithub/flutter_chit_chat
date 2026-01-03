import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/sign_in_page.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _firebaseUser;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async{
    _firebaseUser = FirebaseAuth.instance.currentUser;
  }

  void updateUser(User? firebaseUser){
    setState(() {
      _firebaseUser = firebaseUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_firebaseUser != null){
      return HomePage(
        firebaseUser: _firebaseUser!,
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
