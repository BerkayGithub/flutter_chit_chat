import '../models/user_model.dart';

abstract class DBBase{
  Future<bool> saveUserDataToFirestore(UserModel user);
  Future<UserModel?> readUserFromFirestore(String userID);
  Future<bool?> updateUserName(String userID, String newUsername);
}