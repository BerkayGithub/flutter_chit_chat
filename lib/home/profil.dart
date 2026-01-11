import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/widgets/platforma_duyarli_dialog.dart';
import 'package:provider/provider.dart';

import '../viewmodels/user_viewmodel.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  late TextEditingController emailTextEditingController;

  late TextEditingController usernameTextEditingController;

  @override
  void initState() {
    super.initState();
    emailTextEditingController =
        TextEditingController();
    usernameTextEditingController =
        TextEditingController();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    usernameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userViewmodel = Provider.of<UserViewModel>(context);
    emailTextEditingController.text = userViewmodel.userModel!.email!;
    usernameTextEditingController.text = userViewmodel.userModel!.username;
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  userViewmodel.userModel!.profilURL,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailTextEditingController,
                readOnly: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: usernameTextEditingController,
                readOnly: false,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _profiliGuncelle(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: Text("Değişiklikleri Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cikisYapmakIcinSor(BuildContext context) async {
    final sonuc = await PlatformaDuyarliDialog(
      title: "Emin misiniz?",
      content: "Çıkış yapmak istediğinize emin misiniz ?",
      firstButtonText: "Evet",
      secondButtonText: "Hayır",
    ).goster(context);
    if (sonuc!) {
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

  void _profiliGuncelle(BuildContext context) async{
    var userViewmodel = Provider.of<UserViewModel>(context, listen: false);
    if(usernameTextEditingController.text != userViewmodel.userModel!.username){
      final updateSonuc = await userViewmodel.profiliGuncelle(userViewmodel.userModel!.userID, usernameTextEditingController.text);
      if(updateSonuc!){
        const snackBar = SnackBar(content: Text('Kullanıcı adı değiştirildi', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        const snackBar = SnackBar(content: Text('Bu kullanıcı adı başka bir kullanıcı tarafından alınmış. Lütfen başka bir isim seçiniz!', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }else{
      const snackBar = SnackBar(content: Text('Kullanıcı adınızı değiştirmediniz!', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
