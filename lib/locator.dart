import 'package:flutter_chit_chat/repository/user_repository.dart';
import 'package:flutter_chit_chat/services/fake_auth_service.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
}