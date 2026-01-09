import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/sign_in/sign_in_page.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    if(userViewModel.viewState == ViewState.idle){
      if(userViewModel.userModel != null){
        return HomePage(
          userModel: userViewModel.userModel!,
        );
      }else{
        return SignInPage();
      }
    }else{
      return Scaffold(
          body: Center(child: CircularProgressIndicator(),)
      );
    }
  }
}