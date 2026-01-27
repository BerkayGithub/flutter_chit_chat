import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/home/konusmalarim.dart';
import 'package:flutter_chit_chat/home/kullanicilar.dart';
import 'package:flutter_chit_chat/home/profil.dart';
import 'package:flutter_chit_chat/home/tab_items.dart';
import 'package:flutter_chit_chat/locator.dart';
import 'package:flutter_chit_chat/models/user_model.dart';
import 'package:flutter_chit_chat/services/auth_base.dart';
import 'package:flutter_chit_chat/services/firebase_auth_service.dart';
import 'package:flutter_chit_chat/viewmodels/all_user_viewmodel.dart';
import 'package:provider/provider.dart';
import '../pending_navigation.dart';
import 'bottom_navigation_tab_bar.dart';
import 'navigation_service.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;

  const HomePage({super.key, required this.userModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthBase authBase = locator<FirebaseAuthService>();
  TabItem _currentTab = TabItem.kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.profil: GlobalKey<NavigatorState>(),
    TabItem.konusmalarim: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar = {
    TabItem.kullanicilar: ChangeNotifierProvider<AllUsersViewmodel>(
      create: (_) => AllUsersViewmodel(),
      builder: (context, child) => Kullanicilar(),
    ),
    TabItem.profil: Profil(),
    TabItem.konusmalarim: Konusmalarim(),
  };

  @override
  void initState(){
    super.initState();
    final pending = PendingNavigation.instance.consume();
    if (pending != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.instance.push('/chat', args: pending);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, _) async{
        await navigatorKeys[_currentTab]!.currentState!.maybePop();
      },
      child: BottomNavigationTabBar(
          currentTab: _currentTab,
          onSelectedTab: (TabItem value) {
            if (value == _currentTab) {
              navigatorKeys[value]?.currentState?.popUntil(
                (route) => route.isFirst,
              );
            }else{
              setState(() {
                _currentTab = value;
              });
            }
          },
          sayfaOlusturucu: tumSayfalar,
          navigatorKeys: navigatorKeys,
        ),
    );
  }
}
