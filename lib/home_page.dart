import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {
  final Function onSignOut;
  final UserModel userModel;
  final AuthBase authBase = locator<FirebaseAuthService>();
  HomePage({super.key, required this.userModel, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(onPressed: _cikisYap, child: Text("Çıkış yap"))
        ],
      ),
      body: Center(child: Text("Hoş geldiniz ${userModel.userID}")),
    );
  }

  void _cikisYap() async{
    await authBase.signOut();
    onSignOut();
  }
}
