import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/sohbet_page.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Konusmalarim extends StatefulWidget {
  const Konusmalarim({super.key});

  @override
  State<Konusmalarim> createState() => _KonusmalarimState();
}

class _KonusmalarimState extends State<Konusmalarim> {
  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Konuşmalarım")),
      body: Center(
        child: FutureBuilder(
          future: userViewModel.getMyConversations(
            userViewModel.userModel!.userID,
          ),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              if (asyncSnapshot.data!.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(Duration(seconds: 1));
                    setState(() {});
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var sohbetItem = asyncSnapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => SohbetPage(
                                suankiUser: userViewModel.userModel!,
                                sohbetEdilenUser: UserModel.fromIdAndPicture(
                                  userID: sohbetItem.kiminle,
                                  profilURL: sohbetItem.konusulanKisiResmi,
                                ),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              sohbetItem.konusulanKisiResmi,
                            ),
                          ),
                          title: Text(sohbetItem.konusulanKisiIsmi),
                          subtitle: Text(sohbetItem.sonYollananMesaj),
                          trailing: Text(sohbetItem.aradakiFark!),
                        ),
                      );
                    },
                    itemCount: asyncSnapshot.data!.length,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(Duration(seconds: 1));
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Text(
                        "Henüz konuşma yok",
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
