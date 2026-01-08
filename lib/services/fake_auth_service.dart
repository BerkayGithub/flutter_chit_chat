import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';

class FakeAuthService implements AuthBase{
  String userID = "123123123123123123123123";
  String fakeUserEmail = "fakeUser@fake.com";

  @override
  Future<UserModel> currentUser() async{
    return await Future.value(UserModel(userID: userID, email: fakeUserEmail));
  }

  @override
  Future<UserModel> signInAnonymously() async{
    return await Future.delayed(Duration(seconds: 2), () => UserModel(userID: userID, email: fakeUserEmail));
  }

  @override
  Future<bool> signOut() async{
    return Future.value(true);
  }

  @override
  Future<UserModel?> signInWithGoogle() async{
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userID: "google_user_id_123456", email: fakeUserEmail));
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userID: "facebook_user_id_123456", email: fakeUserEmail));
  }

  @override
  Future<UserModel?> signInWithEmail(email, password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userID: "signed_in_user_id_123456", email: fakeUserEmail));
  }

  @override
  Future<UserModel?> signUpWithEmail(email, password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => UserModel(userID: "signed_up_user_id_123456", email: fakeUserEmail));
  }

}