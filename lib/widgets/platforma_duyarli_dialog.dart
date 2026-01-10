import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chit_chat/widgets/platforma_duyarli_widget.dart';

class PlatformaDuyarliDialog extends PlatformaDuyarliWidget {
  const PlatformaDuyarliDialog({super.key, required this.title,required this.content,required this.firstButtonText,this.secondButtonText});
  final String title;
  final String content;
  final String firstButtonText;
  final String? secondButtonText;

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonlariniAyarla(context),
    );
  }

  @override
  Widget buildiOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButtonlariniAyarla(context),
    );
  }

  Future<bool?> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context, builder: (context) => this)
        : await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false);
  }

  List<Widget> _dialogButtonlariniAyarla(BuildContext context) {
    final tumButtonlar = <Widget>[];
    if(Platform.isIOS){
      final firstButton = CupertinoDialogAction(onPressed: (){
        Navigator.pop(context, true);
      }, child: Text(firstButtonText));
      tumButtonlar.add(firstButton);

      if(secondButtonText != null){
        final secondButton = CupertinoDialogAction(onPressed: (){
          Navigator.pop(context, false);
        }, child: Text(secondButtonText!));
        tumButtonlar.add(secondButton);
      }
    }else {
      final firstButton = TextButton(onPressed: (){
        Navigator.pop(context, true);
      }, child: Text(firstButtonText));
      tumButtonlar.add(firstButton);

      if(secondButtonText != null){
        final secondButton = TextButton(onPressed: (){
          Navigator.pop(context, false);
        }, child: Text(secondButtonText!));
        tumButtonlar.add(secondButton);
      }
    }
    return tumButtonlar;
  }
}
