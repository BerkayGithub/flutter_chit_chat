import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/fake_auth_service.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:flutter_chit_chat/services/firestore_db_service.dart';

import '../locator.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase{
  final FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDBService _firestoreService = locator<FirestoreDBService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel> currentUser() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.currentUser();
    }else {
      UserModel firebaseUser = await _firebaseAuthService.currentUser().onError((Exception e, _){
        throw e;
      });
      UserModel? currentUser = await _firestoreService.readUserFromFirestore(firebaseUser.userID);
      return currentUser!;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInAnonymously();
    }else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signOut();
    }else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithGoogle();
    }else {
      final googleUser = await _firebaseAuthService.signInWithGoogle();
      if(googleUser != null){
        var sonuc = await _firestoreService.saveUserDataToFirestore(googleUser);
        if(sonuc){
          return await _firestoreService.readUserFromFirestore(googleUser.userID);
        }else{
          return null;
        }
      }else{
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithFacebook();
    }else {
      return await _firebaseAuthService.signInWithFacebook();
    }
  }

  @override
  Future<UserModel?> signInWithEmail(email, password) async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signInWithEmail(email, password);
    }else {
      UserModel? user = await _firebaseAuthService.signInWithEmail(email, password);
      if(user != null){
        user = await _firestoreService.readUserFromFirestore(user.userID);
      }
      return user;
    }
  }

  @override
  Future<UserModel?> signUpWithEmail(email, password) async{
    if(appMode == AppMode.DEBUG){
      return await _fakeAuthService.signUpWithEmail(email, password);
    }else {
      UserModel? registeredUser = await _firebaseAuthService.signUpWithEmail(email, password);
      if(registeredUser != null){
        var sonuc = await _firestoreService.saveUserDataToFirestore(registeredUser);
        if(sonuc){
          return await _firestoreService.readUserFromFirestore(registeredUser.userID);
        }else{
          return null;
        }
      }
      return null;
    }
  }

  Future<bool?> updateUserProfile(String userID, String newUsername) async{
    if(appMode == AppMode.DEBUG){
      return false;
    }else{
      return await _firestoreService.updateUserName(userID, newUsername);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if(appMode == AppMode.DEBUG){
      return [];
    }else{
      return await _firestoreService.getAllUsers();
    }
  }

  Stream<List<Mesaj>> mesajlariCek(String currentUserID, String konusulanUserID){
    if(appMode == AppMode.DEBUG){
      return Stream.empty();
    }else{
      return _firestoreService.getMessages(currentUserID, konusulanUserID);
    }
  }

  Future<void> mesajGonder(String text, UserModel suankiUser, UserModel sohbetEdilenUser) async{
    if(appMode == AppMode.RELEASE){
      return await _firestoreService.sendMessage(text, suankiUser, sohbetEdilenUser);
    }
  }
}