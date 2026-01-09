import 'package:flutter/material.dart';


enum TabItem { kullanicilar, profil }

class TabItemData{
  String title;
  Icon icon;

  TabItemData({required this.title, required this.icon});

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.kullanicilar: TabItemData(title: "Kullanıcılar", icon: Icon(Icons.people)),
    TabItem.profil: TabItemData(title: "Profil", icon: Icon(Icons.person))
  };
}