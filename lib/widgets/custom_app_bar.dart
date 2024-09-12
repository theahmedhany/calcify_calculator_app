import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          Image.asset(
            'assets/logo.png',
            height: 30,
          ),
          const SizedBox(width: 10),
          const Text(
            'Calcify',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Color(0xff192032),
            ),
          ),
        ],
      ),
    );
  }
}
