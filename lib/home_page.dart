import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function onSignOut;
  final User firebaseUser;
  const HomePage({super.key, required this.firebaseUser, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(onPressed: _cikisYap, child: Text("Çıkış yap"))
        ],
      ),
      body: Center(child: Text("Hoş geldiniz ${firebaseUser.uid}")),
    );
  }

  void _cikisYap() async{
    await FirebaseAuth.instance.signOut();
    onSignOut();
  }
}
