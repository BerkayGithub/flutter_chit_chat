import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/navigation_service.dart';
import 'package:flutter_chit_chat/home/notification_chat_opener.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/notification_handler.dart';
import 'package:flutter_chit_chat/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'landing_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  setupLocator();
  await NotificationHandler.instance.init();
  runApp(const MyApp());
}

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserViewModel>(
      create: (_) => UserViewModel(),
      builder: (context, child){
        return MaterialApp(
            title: 'Flutter ChitChat',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.instance.navigatorKey,
            initialRoute: '/',
            routes: {
              '/': (_) => const LandingPage(),
              '/chat': (_) => const NotificationChatOpener(),
            }
        );
      },
    );
  }
}
