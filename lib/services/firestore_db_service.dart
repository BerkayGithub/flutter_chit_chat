import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUserDataToFirestore(UserModel user) async {
    try {
      final eklenecekUser = user.toMap();
      eklenecekUser['createdAt'] = FieldValue.serverTimestamp();
      eklenecekUser['updatedAt'] = FieldValue.serverTimestamp();
      await _firebaseFirestore
          .collection('users')
          .doc(user.userID)
          .set(eklenecekUser);
      DocumentSnapshot okunanUser = await _firebaseFirestore.doc("users/${user.userID}").get();
      Map<String,dynamic> okunanUserBilgileriMap = okunanUser.data() as Map<String, dynamic>;
      UserModel _okunanUserBilgileriNesne = UserModel.fromMap(okunanUserBilgileriMap);
      debugPrint("Kaydedilen user $_okunanUserBilgileriNesne");
      return true;
    } catch (e) {
      debugPrint("HATA SAVE USER DATA TO FIRESTORE ${e.toString()}");
      return false;
    }
  }
}
