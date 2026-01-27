import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/models/sohbet.dart';
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
      DocumentSnapshot okunanUser = await _firebaseFirestore
          .doc("users/${user.userID}")
          .get();
      Map<String, dynamic> okunanUserBilgileriMap =
          okunanUser.data() as Map<String, dynamic>;
      UserModel okunanUserBilgileriNesne = UserModel.fromMap(
        okunanUserBilgileriMap,
      );
      debugPrint("Kaydedilen user $okunanUserBilgileriNesne");
      return true;
    } catch (e) {
      debugPrint("HATA SAVE USER DATA TO FIRESTORE ${e.toString()}");
      return false;
    }
  }

  @override
  Future<UserModel?> readUserFromFirestore(String userID) async {
    try {
      DocumentSnapshot okunanUser = await _firebaseFirestore
          .doc("users/$userID")
          .get();
      Map<String, dynamic> okunanUserBilgileriMap =
          okunanUser.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromMap(okunanUserBilgileriMap);
      debugPrint("Okunan user nesnesi $user");
      return user;
    } on Exception catch (e) {
      debugPrint("READ USER FROM FIRESTORE HATA : $e");
      return null;
    }
  }

  @override
  Future<bool?> updateUserName(String userID, String newUsername) async {
    try {
      var users = await _firebaseFirestore
          .collection('users')
          .where('username', isEqualTo: newUsername)
          .get();
      if (users.size >= 1) {
        return false;
      }
      await _firebaseFirestore.collection('users').doc(userID).update({
        'username': newUsername,
      });
      return true;
    } on Exception catch (e) {
      debugPrint("UPDATE USER HATA : $e");
      return false;
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      List<UserModel> userList = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection('users').get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        UserModel userModel = UserModel.fromMap(documentSnapshot.data());
        userList.add(userModel);
      }
      return userList;
    } catch (e) {
      return List<UserModel>.empty();
    }
  }

  @override
  Stream<List<Mesaj>> getMessages(
    String currentUserID,
    String konusulanUserID,
  ) {
    var snapshot = _firebaseFirestore
        .collection('konusmalar')
        .doc('$currentUserID--$konusulanUserID')
        .collection('mesajlar')
        .orderBy('dateTime', descending: true)
        .snapshots();
    return snapshot.map(
      (mesajListesi) => mesajListesi.docs
          .map((mesaj) => Mesaj.fromMap(mesaj.data()))
          .toList(),
    );
  }

  @override
  Future<void> sendMessage(
    String text,
    UserModel suankiUser,
    UserModel sohbetEdilenUser,
  ) async {
    final messageId = _firebaseFirestore.collection('konusmalar').doc().id;

    Mesaj mesaj = Mesaj(
      messageId: messageId,
      gonderen: suankiUser.username,
      alan: sohbetEdilenUser.username,
      messageText: text,
      dateTime: DateTime.now(),
      bendenMi: true,
    );

    await _firebaseFirestore
        .collection('konusmalar')
        .doc('${suankiUser.userID}--${sohbetEdilenUser.userID}')
        .collection('mesajlar')
        .doc(messageId)
        .set(mesaj.toMap());

    await _firebaseFirestore
        .collection('konusmalar')
        .doc('${suankiUser.userID}--${sohbetEdilenUser.userID}')
        .set({
          "kimden": suankiUser.userID,
          "kiminle": sohbetEdilenUser.userID,
          "sonYollananMesaj": text,
          "goruldu": false,
          "olusturulmaTarihi": FieldValue.serverTimestamp(),
        });

    mesaj.bendenMi = false;

    await _firebaseFirestore
        .collection('konusmalar')
        .doc('${sohbetEdilenUser.userID}--${suankiUser.userID}')
        .collection('mesajlar')
        .doc(messageId)
        .set(mesaj.toMap());

    await _firebaseFirestore
        .collection('konusmalar')
        .doc('${sohbetEdilenUser.userID}--${suankiUser.userID}')
        .set({
          "kimden": sohbetEdilenUser.userID,
          "kiminle": suankiUser.userID,
          "sonYollananMesaj": text,
          "goruldu": false,
          "olusturulmaTarihi": FieldValue.serverTimestamp(),
        });
  }

  @override
  Future<List<Sohbet>> getMyConversations(String userId) async {
    List<Sohbet> konustugumKisiler = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('konusmalar')
              .where('kimden', isEqualTo: userId)
              .orderBy('olusturulmaTarihi', descending: true)
              .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot
          in querySnapshot.docs) {
        Sohbet sohbet = Sohbet.fromMap(queryDocumentSnapshot.data());
        konustugumKisiler.add(sohbet);
      }
    } on Exception catch (e) {
      debugPrint("ERROR KONUSTUKLARIMI GETIR $e");
    }
    return konustugumKisiler;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firebaseFirestore.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });

    var okunanMap = await _firebaseFirestore
        .collection("server")
        .doc(userID)
        .get();
    Timestamp okunanTarih = okunanMap.data()?["saat"];
    return okunanTarih.toDate();
  }

  @override
  Future<List<UserModel>> getUsersWithPagination(
    int userSayisi,
    UserModel? sonGelenUser,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      List<UserModel> userList = [];
      if (sonGelenUser == null) {
        querySnapshot = await _firebaseFirestore
            .collection('users')
            .orderBy('username')
            .limit(userSayisi)
            .get();
      } else {
        querySnapshot = await _firebaseFirestore
            .collection('users')
            .orderBy('username')
            .startAfter([sonGelenUser.username])
            .limit(userSayisi)
            .get();
      }
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        UserModel userModel = UserModel.fromMap(documentSnapshot.data());
        userList.add(userModel);
      }
      return userList;
    } catch (e) {
      return List<UserModel>.empty();
    }
  }

  @override
  Future<List<Mesaj>> getMoreMessagesWithPagination(
      int mesajSayisi,
      String currentUserId,
      String konusulanUserId,
      Mesaj? sonGelenMesaj
  ) async {
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot;
      List<Mesaj> mesajlar = [];
      if(sonGelenMesaj == null){
         querySnapshot = await _firebaseFirestore.collection('konusmalar')
            .doc('$currentUserId--$konusulanUserId')
            .collection('mesajlar')
            .orderBy('dateTime', descending: true)
            .limit(mesajSayisi)
            .get();
      }else{
        querySnapshot = await _firebaseFirestore.collection('konusmalar')
            .doc('$currentUserId--$konusulanUserId')
            .collection('mesajlar')
            .orderBy('dateTime', descending: true)
            .startAfter([sonGelenMesaj.dateTime])
            .limit(mesajSayisi)
            .get();

        await Future.delayed(Duration(seconds: 1));
      }
      for (QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot in querySnapshot.docs){
        Mesaj mesaj = Mesaj.fromMap(queryDocumentSnapshot.data());
        mesajlar.add(mesaj);
      }
      return mesajlar;
    } catch(e) {
      return List<Mesaj>.empty();
    }
  }

  @override
  Stream<List<Mesaj>> getNewMessages(String currentId, String konusulanUserId) {
    var snapshot = _firebaseFirestore
        .collection('konusmalar')
        .doc('$currentId--$konusulanUserId')
        .collection('mesajlar')
        .orderBy('dateTime', descending: true)
        .limit(1)
        .snapshots();
    return snapshot.map(
          (mesajListesi) => mesajListesi.docs
          .map((mesaj) => Mesaj.fromMap(mesaj.data()))
          .toList(),
    );
  }

  Future<String?> getToken(UserModel user) async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firebaseFirestore.doc('tokens/${user.userID}').get();
    return documentSnapshot.data() != null ?  documentSnapshot.data()!['token'] : null;
  }

  Future<void> saveToken(String userId, String token) async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _firebaseFirestore.doc('tokens/$userId').get();
    if(!documentSnapshot.exists){
      await _firebaseFirestore.doc('tokens/$userId').set({'token' : token});
    }
  }
}
