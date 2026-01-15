import 'package:flutter_chit_chat/models/mesaj.dart';

import '../models/user_model.dart';

abstract class DBBase{
  Future<bool> saveUserDataToFirestore(UserModel user);
  Future<UserModel?> readUserFromFirestore(String userID);
  Future<bool?> updateUserName(String userID, String newUsername);
  Future<List<UserModel>> getAllUsers();
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<void> sendMessage(String text, UserModel suankiUser, UserModel sohbetEdilenUser);
}