import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/mesaj.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/repository/user_repository.dart';

enum ChatViewState{ idle, loaded, busy}

class ChatViewmodel with ChangeNotifier{
  UserModel suankiUser;
  UserModel sohbetEdilenUser;
  List<Mesaj> _tumMesajlar = [];
  bool? _hasMore;
  bool? _isLoading;
  ChatViewState _viewState = ChatViewState.idle;
  static final int sayfaBasinaMesajSayisi = 30;
  final UserRepository _userRepository = locator<UserRepository>();
  Mesaj? sonGelenMesaj;
  StreamSubscription<List<Mesaj>>? yeniMesajlar;
  Mesaj? _listeyeEklenenIlkMesaj;

  List<Mesaj> get tumMesajlar => _tumMesajlar;
  bool? get hasMore => _hasMore;
  bool? get isLoading => _isLoading;
  ChatViewState get viewState => _viewState;

  set tumMesajlar(List<Mesaj> newValue){
    _tumMesajlar = newValue;
    notifyListeners();
  }

  set hasMore(bool newValue){
    _hasMore = newValue;
    notifyListeners();
  }

  set isLoading(bool newValue){
    _isLoading = newValue;
    notifyListeners();
  }

  set viewState(ChatViewState newValue){
    _viewState = newValue;
    notifyListeners();
  }

  ChatViewmodel(this.suankiUser, this.sohbetEdilenUser){
    hasMore = true;
    eskiMesajlariYukle();
  }

  Future<void> eskiMesajlariYukle() async{
    if(isLoading == true || !hasMore! ){
      return;
    }
    isLoading = true;
    List<Mesaj> mesajlar = await _userRepository.eskiMesajlariYukle(sayfaBasinaMesajSayisi, suankiUser.userID, sohbetEdilenUser.userID, sonGelenMesaj);
    _tumMesajlar.addAll(mesajlar);
    if(_tumMesajlar.isNotEmpty){
      _listeyeEklenenIlkMesaj = _tumMesajlar.first;
    }
    if(mesajlar.length < sayfaBasinaMesajSayisi){
      hasMore = false;
    }
    if(mesajlar.isNotEmpty) {
      sonGelenMesaj = mesajlar.last;
    }
    if(yeniMesajlar == null){
      mesajListenerAta();
    }
    isLoading = false;
  }

   Future<void> mesajGonder(String text) async{
    await _userRepository.mesajGonder(text, suankiUser, sohbetEdilenUser);
  }

  void mesajListenerAta(){
    yeniMesajlar ??= _userRepository.yeniMesajlariCek(suankiUser.userID, sohbetEdilenUser.userID).listen((yeniMesajlar){
      if(yeniMesajlar.isEmpty) return;
      if(_listeyeEklenenIlkMesaj == null){
        tumMesajlar.insert(0, yeniMesajlar.first);
      }else if(yeniMesajlar.first.messageId != _listeyeEklenenIlkMesaj!.messageId) {
        tumMesajlar.insert(0, yeniMesajlar.first);
      };
      notifyListeners();
    });
  }

  @override
  void dispose() {
    yeniMesajlar?.cancel();
    super.dispose();
  }
}