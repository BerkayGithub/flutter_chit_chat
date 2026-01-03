import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.title,
    required this.textColor,
    required this.bgColor,
    required this.image,
    required this.onPressed
  });

  final String title;
  final Color textColor;
  final Color bgColor;

  final Widget image;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: bgColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            image,
            Text(title, style: TextStyle(color: textColor),),
            Opacity(opacity: 0.0,child: image)
          ],
        ),
      ),
    );
  }
}
