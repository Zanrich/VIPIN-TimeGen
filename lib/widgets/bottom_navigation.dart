import 'package:flutter/material.dart';
import '../models/nav_item.dart';

class CustomBottomNavigation extends StatelessWidget {
  final List<NavItem> navItems;

  const CustomBottomNavigation({
    super.key,
    required this.navItems,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 409,
      height: 73,
      child: Stack(
        children: [
          // Background
          Positioned(
            top: 4,
            left: 3,
            child: Container(
              width: 412,
              height: 64,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/rectangle-5578.svg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Active Navigation Item (HOME)
          Positioned(
            top: 8,
            left: 6,
            child: Container(
              width: 98,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF00DAE7),
                    Color(0xFF0079A8),
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x59000000),
                    offset: Offset(4, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home,
                    color: Color(0xFF111111),
                    size: 29,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'HOME',
                    style: TextStyle(
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Timesheets Navigation Item
          Positioned(
            top: 12,
            left: 154,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/event-3.png',
                  width: 31,
                  height: 31,
                ),
                const SizedBox(height: 4),
                const Text(
                  'TIMESHEETS',
                  style: TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          
          // Employees Navigation Item
          Positioned(
            top: 12,
            left: 240,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/employee--1--2.png',
                  width: 31,
                  height: 31,
                ),
                const SizedBox(height: 4),
                const Text(
                  'EMPLOYEES',
                  style: TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Navigation Item
          Positioned(
            top: 15,
            right: 38,
            child: Column(
              children: [
                SizedBox(
                  width: 27,
                  height: 27,
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: List.generate(4, (index) => Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'MENU',
                  style: TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}