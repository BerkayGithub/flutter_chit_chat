import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user_viewmodel.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          TextButton(
            onPressed: () => _cikisYap(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          )
        ],
      ),
      body: Center(child: Text("Profil"),),
    );
  }

  void _cikisYap(BuildContext context) async {
    await Provider.of<UserViewModel>(context, listen: false).signOut();
  }
}