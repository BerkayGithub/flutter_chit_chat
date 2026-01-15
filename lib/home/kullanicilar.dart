import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/sohbet.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Kullanicilar extends StatelessWidget {
  const Kullanicilar({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewmodel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcılar")),
      body: FutureBuilder<List<UserModel>>(
        future: userViewmodel.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var tumKullanicilar = snapshot.data!;
            if (tumKullanicilar.length - 1 > 0) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final userItem = tumKullanicilar[index];
                  if (userItem.userID == userViewmodel.userModel!.userID) {
                    return Container();
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => Sohbet(
                              suankiUser: userViewmodel.userModel!,
                              sohbetEdilenUser: userItem,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(userItem.profilURL),
                        ),
                        title: Text(userItem.username),
                      ),
                    );
                  }
                },
                itemCount: tumKullanicilar.length,
              );
            } else {
              return Center(child: Text('Kayıtlı kullanıcı yok'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
