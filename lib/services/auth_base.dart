import '../models/user_model.dart';

abstract class AuthBase{
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> currentUser();
  Future<UserModel?> signInWithGoogle();
}