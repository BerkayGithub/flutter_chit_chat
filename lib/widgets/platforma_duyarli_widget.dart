import 'dart:io';

import 'package:flutter/cupertino.dart';

abstract class PlatformaDuyarliWidget extends StatelessWidget{
  const PlatformaDuyarliWidget({super.key});
  Widget buildAndroidWidget(BuildContext context);
  Widget buildiOSWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      return buildiOSWidget(context);
    }else {
      return buildAndroidWidget(context);
    }
  }
}