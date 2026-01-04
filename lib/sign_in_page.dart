import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:flutter_chit_chat/widgets/social_login_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Oturum Açın", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          SizedBox(height: 16),
          SocialLoginButton(title: "Google ile giriş yap", textColor: Colors.black, bgColor: Colors.white, image: Image.asset("assets/images/google_logo.png"), onPressed: () => _googleIleGirisYap(context),),
          SocialLoginButton(title: "Facebook ile giriş yap", textColor: Colors.white, bgColor: Colors.blue, image: Image.asset("assets/images/facebook_logo.png"), onPressed: (){}),
          SocialLoginButton(title: "Email ile giriş yap", textColor: Colors.white, bgColor: Colors.purple, image: Icon(Icons.email, color: Colors.white), onPressed: _emailIleGirisYap,),
          SocialLoginButton(title: "Misafir olarak giriş yap", textColor: Colors.white, bgColor: Colors.teal, image: Icon(Icons.supervised_user_circle, color: Colors.white,), onPressed: () => _misafirGirisiYap(context),),
        ],
      ),
    );
  }

  void _googleIleGirisYap(BuildContext context) async{
    await Provider.of<UserViewModel>(context,listen: false).signInWithGoogle();
  }

  void _emailIleGirisYap() {

  }

  void _misafirGirisiYap(BuildContext context) async {
    try {
      await Provider.of<UserViewModel>(context, listen: false).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      if (e.code == "operation-not-allowed") {
        debugPrint("Anonymous auth hasn't been enabled for this project.");
      } else {
        debugPrint("Unknown error: ${e.message}");
      }
    }
  }
}
