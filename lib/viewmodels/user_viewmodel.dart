import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/repository/user_repository.dart';

enum ViewState { idle, busy }

class UserViewModel with ChangeNotifier {
  ViewState _viewState = ViewState.idle;
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _userModel;
  String? emailHataMesaji;
  String? sifreHataMesaji;

  UserViewModel() {
    currentUser();
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState state) {
    _viewState = state;
    notifyListeners();
  }

  UserModel? get userModel => _userModel;

  set userModel(UserModel? newUserModel) {
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
    } finally {
      viewState = ViewState.idle;
    }
  }

  Future<UserModel?> signInAnonymously() async {
    try {
      viewState = ViewState.busy;
      _userModel = await _userRepository.signInAnonymously();
      return _userModel;
    } catch (e) {
      debugPrint("HATA SIGN IN ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.idle;
    }
  }

  Future<bool?> signOut() async {
    try {
      viewState = ViewState.busy;
      bool sonuc = await _userRepository.signOut();
      userModel = null;
      return sonuc;
    } catch (e) {
      debugPrint("HATA SIGN OUT ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.idle;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    viewState = ViewState.busy;
    final sonuc = await _userRepository.signInWithGoogle().onError((Exception e, _){
      viewState = ViewState.idle;
      throw e;
    });
    userModel = sonuc;
    viewState = ViewState.idle;
    return sonuc;
  }

  Future<UserModel?> signInWithFacebook() async {
    viewState = ViewState.busy;
    final result = await _userRepository.signInWithFacebook();
    userModel = result;
    viewState = ViewState.idle;
    return result;
  }

  Future<UserModel?> signInWithEmail(email, password) async {
    if (_emailVeSifreKontrol(email, password)) {
      viewState = ViewState.busy;
      final result = await _userRepository.signInWithEmail(email, password).onError((Exception e, _){
        viewState = ViewState.idle;
        throw e;
      });
      userModel = result;
      viewState = ViewState.idle;
      return result;
    } else {
      return null;
    }
  }

  Future<UserModel?> signUpWithEmail(email, password) async {
    if (_emailVeSifreKontrol(email, password)) {
      viewState = ViewState.busy;
      final result = await _userRepository.signUpWithEmail(email, password).onError((Exception e, _){
        viewState = ViewState.idle;
        throw e;
      });
      userModel = result;
      viewState = ViewState.idle;
      return result;
    } else {
      return null;
    }
  }

  bool _emailVeSifreKontrol(String email, String password) {
    bool result = true;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      result = false;
    } else {
      emailHataMesaji = null;
    }
    if (password.length < 6) {
      sifreHataMesaji = "Şifre en az 6 karakter uzunluğunda olmalı";
      result = false;
    } else {
      sifreHataMesaji = null;
    }
    notifyListeners();
    return result;
  }
}
