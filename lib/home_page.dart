import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;
  final AuthBase authBase = locator<FirebaseAuthService>();
  HomePage({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(onPressed: () => _cikisYap(context), child: Text("Çıkış yap"))
        ],
      ),
      body: Center(child: Text("Hoş geldiniz ${userModel.userID}")),
    );
  }

  void _cikisYap(BuildContext context) async{
    await Provider.of<UserViewModel>(context, listen: false).signOut();
  }
}
