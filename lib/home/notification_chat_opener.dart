import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/sohbet_page.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';

class NotificationChatOpener extends StatelessWidget {
  const NotificationChatOpener({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String gonderenId = args['gonderen_id'];
    final String profilURL = args['profile_url'];

    final _userModel = Provider.of<UserViewModel>(context);
    if(_userModel.userModel != null){
      return ChangeNotifierProvider(
        create: (_) => ChatViewmodel(_userModel.userModel!, UserModel.fromIdAndPicture(
          userID: gonderenId,
          profilURL: profilURL,
        )),
        child: SohbetPage(),
      );
    }else{
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

  }
}
