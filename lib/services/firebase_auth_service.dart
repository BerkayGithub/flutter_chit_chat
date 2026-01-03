import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  UserModel userFormFirebaseUser(User? firebaseUser){
    if(firebaseUser != null){
      return UserModel(userID: firebaseUser.uid);
    }else{
      throw Exception("You are not logged in");
    }
  }

  @override
  Future<UserModel> currentUser() async {
    try{
      User? firebaseUser = _firebaseAuth.currentUser;
      return userFormFirebaseUser(firebaseUser);
    }catch(e){
      debugPrint("HATA CURRENT USER ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      User? firebaseUser = userCredential.user;
      return userFormFirebaseUser(firebaseUser);
    } on Exception catch (e) {
      debugPrint("HATA SIGN IN ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async{
    try {
      await _firebaseAuth.signOut();
      return true;
    } on Exception catch (e) {
      debugPrint("HATA SIGN OUT ${e.toString()}");
      return false;
    }
  }
}