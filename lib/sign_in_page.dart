import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:flutter_chit_chat/widgets/social_login_button.dart';

import 'models/user_model.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key, required this.onSignIn});

  final Function(UserModel user) onSignIn;
  final AuthBase authBase = locator<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Oturum Açın", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          SizedBox(height: 16),
          SocialLoginButton(title: "Google ile giriş yap", textColor: Colors.black, bgColor: Colors.white, image: Image.asset("assets/images/google_logo.png"), onPressed: _googleIleGirisYap,),
          SocialLoginButton(title: "Facebook ile giriş yap", textColor: Colors.white, bgColor: Colors.blue, image: Image.asset("assets/images/facebook_logo.png"), onPressed: (){}),
          SocialLoginButton(title: "Email ile giriş yap", textColor: Colors.white, bgColor: Colors.purple, image: Icon(Icons.email, color: Colors.white), onPressed: _emailIleGirisYap,),
          SocialLoginButton(title: "Misafir olarak giriş yap", textColor: Colors.white, bgColor: Colors.teal, image: Icon(Icons.supervised_user_circle, color: Colors.white,), onPressed: _misafirGirisiYap,),
        ],
      ),
    );
  }

  void _googleIleGirisYap() {

  }

  void _emailIleGirisYap() {

  }

  void _misafirGirisiYap() async {
    try {
      onSignIn(await authBase.signInAnonymously());
    } on FirebaseAuthException catch (e) {
      if (e.code == "operation-not-allowed") {
        debugPrint("Anonymous auth hasn't been enabled for this project.");
      } else {
        debugPrint("Unknown error: ${e.message}");
      }
    }
  }
}
