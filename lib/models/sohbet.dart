import 'package:cloud_firestore/cloud_firestore.dart';

class Sohbet {
  String kimden;
  String kiminle;
  String sonYollananMesaj;
  bool goruldu;
  Timestamp? olusturulmaTarihi;
  Timestamp? gorulmeTarihi;
  String konusulanKisiIsmi = '';
  String konusulanKisiResmi = '';
  DateTime? sonOkunmaZamani;
  String? aradakiFark;

  Sohbet(
    this.kimden,
    this.kiminle,
    this.sonYollananMesaj,
    this.goruldu,
    this.olusturulmaTarihi,
    this.gorulmeTarihi,
  );

  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kiminle': kiminle,
      'sonYollananMesaj': sonYollananMesaj,
      'goruldu': goruldu,
      'olusturulmaTarihi': olusturulmaTarihi ?? FieldValue.serverTimestamp(),
      'gorulmeTarihi': gorulmeTarihi ?? FieldValue.serverTimestamp(),
    };
  }

  Sohbet.fromMap(Map<String, dynamic> messageMap)
    : kimden = messageMap['kimden'],
      kiminle = messageMap['kiminle'],
      sonYollananMesaj = messageMap['sonYollananMesaj'],
      goruldu = messageMap['goruldu'],
      olusturulmaTarihi = messageMap['olusturulmaTarihi'],
      gorulmeTarihi = messageMap['gorulmeTarihi'];

  @override
  String toString() {
    return 'Sohbet{kimden: $kimden, kiminle: $kiminle, sonYollananMesaj: $sonYollananMesaj, goruldu: $goruldu, olusturulmaTarihi: $olusturulmaTarihi, gorulmeTarihi: $gorulmeTarihi}';
  }
}
