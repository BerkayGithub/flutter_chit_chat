import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/sohbet_page.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Kullanicilar extends StatefulWidget {
  const Kullanicilar({super.key});

  @override
  State<Kullanicilar> createState() => _KullanicilarState();
}

class _KullanicilarState extends State<Kullanicilar> {
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
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  setState(() {});
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final userItem = tumKullanicilar[index];
                    if (userItem.userID == userViewmodel.userModel!.userID) {
                      return Container();
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => SohbetPage(
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
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 2));
                  setState(() {});
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Text(
                      'Kayıtlı kullanıcı yok',
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
