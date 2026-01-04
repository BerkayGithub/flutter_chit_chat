import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/repository/user_repository.dart';

enum ViewState { idle, busy }

class UserViewModel with ChangeNotifier{

  ViewState _viewState = ViewState.idle;
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;

  UserViewModel(){
    currentUser();
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState state){
    _viewState = state;
    notifyListeners();
  }

  UserModel? get userModel => _userModel;

  set userModel(UserModel? newUserModel){
    _userModel = newUserModel;
    notifyListeners();
  }

  Future<UserModel?> currentUser() async {
    try {
      viewState = ViewState.busy;
      _userModel = await _userRepository.currentUser();
      return _userModel;
    } on Exception catch (e) {
      debugPrint("HATA CURRENT USER ${e.toString()}");
      rethrow;
    }finally{
      viewState = ViewState.idle;
    }
  }

  Future<UserModel?> signInAnonymously() async{
    try{
      viewState = ViewState.busy;
      _userModel = await _userRepository.signInAnonymously();
      return _userModel;
    }catch(e){
      debugPrint("HATA SIGN IN ${e.toString()}");
      return null;
    }finally {
      viewState = ViewState.idle;
    }
  }

  Future<bool?> signOut() async{
    try{
      viewState = ViewState.busy;
      bool sonuc = await _userRepository.signOut();
      userModel = null;
      return sonuc;
    }catch(e){
      debugPrint("HATA SIGN OUT ${e.toString()}");
      return null;
    }finally{
      viewState = ViewState.idle;
    }
  }

  Future<UserModel?> signInWithGoogle() async{
    viewState = ViewState.busy;
    final sonuc = await _userRepository.signInWithGoogle();
    userModel = sonuc;
    viewState = ViewState.idle;
    return sonuc;
}

}