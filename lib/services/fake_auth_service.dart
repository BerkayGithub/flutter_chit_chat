import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';

class FakeAuthService implements AuthBase{
  String userID = "123123123123123123123123";

  @override
  Future<UserModel> currentUser() async{
    return await Future.value(UserModel(userID: userID));
  }

  @override
  Future<UserModel> signInAnonymously() async{
    return await Future.delayed(Duration(seconds: 2), () => UserModel(userID: userID));
  }

  @override
  Future<bool> signOut() async{
    return Future.value(true);
  }

  @override
  Future<UserModel?> signInWithGoogle() async{
    return await Future.delayed(Duration(seconds: 2), () => UserModel(userID: userID));
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return null;
  }

}