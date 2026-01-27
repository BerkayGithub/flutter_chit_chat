import 'dart:convert';

import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:http/http.dart' as http;

class BildirimGonderme{

  Future<bool> bildirimGonder(String gonderilecekBildirim, UserModel gonderenUser, String token) async{
    String endURL = "https://fcm.googleapis.com/v1/projects/flutter-chitchat-fa16a/messages:send";
    String bearerTokenWillBeExpired = "----------------------------------------------------------------";
    final response = await http.post(
      Uri.parse(endURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerTokenWillBeExpired',
      },
      body: jsonEncode({
        'message' : {
          'token': token,
          'notification': {
            'title': gonderenUser.username,
            'body': gonderilecekBildirim,
          },
          'data':{
            'title': gonderenUser.username,
            'body': gonderilecekBildirim,
            'gonderen_id' : gonderenUser.userID,
            'profile_url': gonderenUser.profilURL
          }
        },
      }),
    );

    print(response.body);
    if(response.statusCode == 200){
      return true;
    }else{
      print("Bildirim Gönderilemedi : ${response.body}");
      return false;
    }
  }
}