import '../models/user_model.dart';

abstract class AuthBase{
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> currentUser();
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithFacebook();
  Future<UserModel?> signInWithEmail(email, password);
  Future<UserModel?> signUpWithEmail(email, password);
}