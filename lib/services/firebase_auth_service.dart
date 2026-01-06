import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel userFormFirebaseUser(User? firebaseUser) {
    if (firebaseUser != null) {
      return UserModel(userID: firebaseUser.uid);
    } else {
      throw Exception("You are not logged in");
    }
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      User? firebaseUser = _firebaseAuth.currentUser;
      return userFormFirebaseUser(firebaseUser);
    } catch (e) {
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
  Future<bool> signOut() async {
    try {
      var googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await _firebaseAuth.signOut();
      return true;
    } on Exception catch (e) {
      debugPrint("HATA SIGN OUT ${e.toString()}");
      return false;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuth.idToken,
        accessToken: googleSignInAuth.accessToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = _firebaseAuth.currentUser;
      return userFormFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.message}');
      // Handle Firebase specific errors (e.g., account-exists-with-different-credential)
      return null;
    } catch (e) {
      debugPrint("HATA SIGN IN WITH GOOGLE ${e.toString()}");
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile']
      );

      if (result.status != LoginStatus.success) {
        return null;
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      await _firebaseAuth.signInWithCredential(credential);
      User? firebaseUser = _firebaseAuth.currentUser;
      return userFormFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint("HATA SIGN IN WITH FACEBOOK ${e.toString()}");
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmail(email, password) async{
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user;
      if(firebaseUser == null) {
        return null;
      } else {
        return userFormFirebaseUser(firebaseUser);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint("HATA SIGN IN WITH EMAIL ${e.toString()}");
      return null;
    }
  }

  @override
  Future<UserModel?> signUpWithEmail(email, password) async{
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser = userCredential.user;
      if(firebaseUser == null) {
        return null;
      } else {
        return userFormFirebaseUser(firebaseUser);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint("HATA SIGN IN WITH EMAIL ${e.toString()}");
      return null;
    }
  }
}
