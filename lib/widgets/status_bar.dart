import 'package:flutter/material.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 402,
      height: 50,
      child: Stack(
        children: [
          // Battery, WiFi, Signal icons
          Positioned(
            top: 20,
            right: 16,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/mobile-signal.svg',
                  width: 19,
                  height: 12,
                ),
                const SizedBox(width: 6),
                Image.asset(
                  'assets/images/wifi.svg',
                  width: 17,
                  height: 12,
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/battery.png',
                  width: 28,
                  height: 13,
                ),
              ],
            ),
          ),
          
          // Time
          Positioned(
            top: 14,
            left: 24,
            child: Container(
              width: 61,
              height: 24,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/time.svg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}