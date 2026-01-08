import '../models/user_model.dart';

abstract class DBBase{
  Future<bool> saveUserDataToFirestore(UserModel user);
}