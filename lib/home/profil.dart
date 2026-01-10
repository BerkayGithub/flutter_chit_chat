import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/widgets/platforma_duyarli_dialog.dart';
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
            onPressed: () => _cikisYapmakIcinSor(context),
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

  void _cikisYapmakIcinSor(BuildContext context) async{
    final sonuc = await PlatformaDuyarliDialog(title: "Emin misiniz?",content: "Çıkış yapmak istediğinize emin misiniz ?", firstButtonText: "Evet", secondButtonText: "Hayır").goster(context);
    if(sonuc!){
      _cikisYap(context);
    }
  }

  void _cikisYap(BuildContext context) async {
    try {
      await Provider.of<UserViewModel>(context, listen: false).signOut();
    } on Exception catch (e) {
      debugPrint("HATA çıkışYap ${e.toString()}");
    }
  }
}