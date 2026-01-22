import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/models/sohbet.dart';

import '../models/user_model.dart';

abstract class DBBase{
  Future<bool> saveUserDataToFirestore(UserModel user);
  Future<UserModel?> readUserFromFirestore(String userID);
  Future<bool?> updateUserName(String userID, String newUsername);
  Future<List<UserModel>> getAllUsers();
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<void> sendMessage(String text, UserModel suankiUser, UserModel sohbetEdilenUser);
  Future<List<Sohbet>> getMyConversations(String userId);
  Future<DateTime> saatiGoster(String userID);
  Future<List<UserModel>> getUsersWithPagination(int userSayisi, UserModel? sonGelenUser);
  Future<List<Mesaj>> getMoreMessagesWithPagination(int mesajSayisi, String currentUserId, String konusulanUserId, Mesaj? sonGelenMesaj);
  Stream<List<Mesaj>> getNewMessages(String currentId, String konusulanUserId);
}