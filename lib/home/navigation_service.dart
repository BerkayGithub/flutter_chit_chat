import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService instance = NavigationService._();

  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  Future<void> push(String route, {Object? args}) async {
    navigatorKey.currentState?.pushNamed(route, arguments: args);
  }

  Future<void> pushReplacement(String route, {Object? args}) async {
    navigatorKey.currentState
        ?.pushReplacementNamed(route, arguments: args);
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}
