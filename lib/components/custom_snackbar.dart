import 'package:flutter/material.dart';

SnackBar customSnackBar(String header, String messageBody, Color desiredColor) {
  return SnackBar(
    content: Container(
        height: 80,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
            color: desiredColor,
            borderRadius: const BorderRadius.all(Radius.circular(23))),
        child: Column(
          children: [
            Text(header,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.5,
                    letterSpacing: 1.3,
                    fontFamily: 'Titi')),
            const SizedBox(height: 8),
            Text(messageBody,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.4,
                    overflow: TextOverflow.ellipsis,
                    letterSpacing: 1,
                    fontFamily: 'Titi')),
          ],
        )),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    backgroundColor: Colors.transparent,
  );
}
