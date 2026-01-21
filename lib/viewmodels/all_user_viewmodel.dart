import 'package:flutter/cupertino.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/repository/user_repository.dart';

import '../models/user_model.dart';

class AllUsersViewmodel with ChangeNotifier{
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _sonGelenUser;
  List<UserModel>? _tumUserlar;
  bool _hasMore = true;
  bool _isLoading = false;
  static final int usersToGetCount = 15;

  set sonGelenUser(UserModel? newSonGelenUser){
    _sonGelenUser = newSonGelenUser;
    notifyListeners();
  }

  UserModel? get sonGelenUser => _sonGelenUser;

  set tumUserlar(List<UserModel>? newList){
    _tumUserlar = newList;
    notifyListeners();
  }

  List<UserModel>? get tumUserlar => _tumUserlar;

  set hasMore(bool newHasMore){
    _hasMore = newHasMore;
    notifyListeners();
  }

  bool get hasMore => _hasMore;

  set isLoading(bool newIsLoading){
    _isLoading = newIsLoading;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  Future<void> kullaniciEkle() async{
    if(isLoading || !hasMore){
      return;
    }
    isLoading = true;
    var users = await _userRepository.getAllUsersWithPagination(usersToGetCount, _sonGelenUser);
    if (sonGelenUser == null) tumUserlar = [];
    tumUserlar!.addAll(users);
    isLoading = false;
    if(users.length < 10){
      hasMore = false;
    }
    sonGelenUser = tumUserlar!.last;
  }

  Future<Null> refresh() async {
    hasMore = true;
    sonGelenUser = null;
    tumUserlar = null;
    kullaniciEkle();
  }

}