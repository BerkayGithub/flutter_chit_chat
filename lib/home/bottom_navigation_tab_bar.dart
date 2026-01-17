import 'package:flutter/cupertino.dart';
import 'package:flutter_chit_chat/home/tab_items.dart';

class BottomNavigationTabBar extends StatelessWidget {
  const BottomNavigationTabBar({
    super.key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.sayfaOlusturucu,
    required this.navigatorKeys,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem.kullanicilar),
          _navItemOlustur(TabItem.konusmalarim),
          _navItemOlustur(TabItem.profil),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        var gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[gosterilecekItem],
          builder: (context) {
            return sayfaOlusturucu[gosterilecekItem]!;
          },
        );
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: olusturulacakTab!.icon,
      label: olusturulacakTab.title,
    );
  }
}
