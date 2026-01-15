import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  String messageId;
  String gonderen;
  String alan;
  String messageText;
  DateTime? dateTime;
  bool bendenMi;

  Mesaj({
    required this.messageId,
    required this.gonderen,
    required this.alan,
    required this.messageText,
    this.dateTime,
    required this.bendenMi,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'gonderen': gonderen,
      'alan': alan,
      'messageText': messageText,
      'dateTime': dateTime ?? FieldValue.serverTimestamp(),
      'bendenMi': bendenMi,
    };
  }

  Mesaj.fromMap(Map<String, dynamic> messageMap)
    : messageId = messageMap['messageId'],
      gonderen = messageMap['gonderen'],
      alan = messageMap['alan'],
      messageText = messageMap['messageText'],
      dateTime = (messageMap['dateTime'] as Timestamp).toDate() ,
      bendenMi = messageMap['bendenMi'];

  @override
  String toString() {
    return 'Mesaj{messageId: $messageId, gonderen: $gonderen, alan: $alan, messageText: $messageText, dateTime: $dateTime, bendenMi: $bendenMi}';
  }
}