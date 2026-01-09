import 'package:flutter/material.dart';

class Kullanicilar extends StatelessWidget{
  const Kullanicilar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kullanıcılar"),),
      body: Center(child: Text("Kullanıcılar"),),
    );
  }
}