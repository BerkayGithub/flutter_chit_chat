import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String? email;
  String username = '';
  String profilURL = 'https://i.scdn.co/image/ab67656300005f1fdad4c3d1172547ae54ea9178';
  DateTime? createdAt;
  DateTime? updatedAt;
  int seviye = 1;

  UserModel({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userID': userID,
      'email': email,
      'username': username == '' ? '${email?.substring(0, email?.indexOf('@'))}${Random().nextInt(100)}' : username,
      'profilURL': profilURL == '' ? 'https://i.scdn.co/image/ab67656300005f1fdad4c3d1172547ae54ea9178' : profilURL,
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
      'seviye': seviye
    };
  }

  UserModel.fromMap(Map<String, dynamic> userMap)
      :
        userID = userMap['userID'],
        email = userMap['email'],
        username = userMap['username'],
        profilURL = userMap['profilURL'] == '' ? 'https://i.scdn.co/image/ab67656300005f1fdad4c3d1172547ae54ea9178' : userMap['profilURL'],
        createdAt = (userMap['createdAt'] as Timestamp).toDate(),
        updatedAt = (userMap['updatedAt'] as Timestamp).toDate(),
        seviye = userMap['seviye'];

  UserModel.fromIdAndPicture({required this.userID, required this.profilURL});

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, username: $username, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }


}