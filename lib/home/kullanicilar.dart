import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chit_chat/home/sohbet_page.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/viewmodels/all_user_viewmodel.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class Kullanicilar extends StatefulWidget {
  const Kullanicilar({super.key});

  @override
  State<Kullanicilar> createState() => _KullanicilarState();
}

class _KullanicilarState extends State<Kullanicilar> {
  late final ScrollController scrollController = ScrollController();

  @override
  void initState(){
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_){
      Provider.of<AllUsersViewmodel>(context, listen: false).kullaniciEkle();
    });
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 25) {
        await Provider.of<AllUsersViewmodel>(context, listen: false).kullaniciEkle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcılar")),
      body: Consumer<AllUsersViewmodel>(builder: (context, model, child){
        if(model.tumUserlar == null){
          return Center(child: CircularProgressIndicator());
        }else if(model.tumUserlar!.length > 1){
          return RefreshIndicator(
            onRefresh: () => model.refresh(),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                if(index == model.tumUserlar!.length){
                  return model.isLoading ? buildYeniUserlarYukleniyor() : Container();
                }else{
                  final userItem = model.tumUserlar![index];
                  if (userItem.userID == userViewModel.userModel!.userID) {
                    return Container();
                  } else {
                    return buildUserListItem(context, userViewModel, userItem);
                  }
                }
              },
              itemCount: model.hasMore ? model.tumUserlar!.length + 1 : model.tumUserlar!.length,
            ),
          );
        }else{
          return buildNoUserScreen();
        }
      })
    );
  }

  RefreshIndicator buildNoUserScreen() {
    final kullanicilarModel = Provider.of<AllUsersViewmodel>(context);
    return RefreshIndicator(
      onRefresh: () => kullanicilarModel.refresh(),
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

  GestureDetector buildUserListItem(BuildContext context, UserViewModel userViewModel, UserModel userItem) {
    return GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SohbetPage(
                          suankiUser: userViewModel.userModel!,
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

  Padding buildYeniUserlarYukleniyor() {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
