import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/status_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/bottom_navigation.dart';
import '../models/menu_item.dart';
import '../models/nav_item.dart';

class EmployerDashScreen extends StatelessWidget {
  const EmployerDashScreen({super.key});

  static const List<MenuItem> menuItems = [
    MenuItem(
      icon: 'assets/images/identity-1.png',
      title: 'Scan Employee',
      alt: 'Identity',
    ),
    MenuItem(
      icon: 'assets/images/report--1--2.png',
      title: 'Flagged Events',
      alt: 'Report',
    ),
    MenuItem(
      icon: 'assets/images/airplane-1.png',
      title: 'Employee Time Off',
      alt: 'Airplane',
    ),
    MenuItem(
      icon: 'assets/images/gps--2--1.png',
      title: 'Add Employees for Manual Clocking',
      alt: 'Gps',
    ),
  ];

  static const List<NavItem> navItems = [
    NavItem(
      icon: 'assets/icons/vector.svg',
      title: 'HOME',
      isActive: true,
    ),
    NavItem(
      icon: 'assets/images/event-3.png',
      title: 'TIMESHEETS',
      isActive: false,
    ),
    NavItem(
      icon: 'assets/images/employee--1--2.png',
      title: 'EMPLOYEES',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Container(
          width: 423,
          height: 936,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Stack(
            children: [
              // Status Bar
              const Positioned(
                top: -5,
                left: 4,
                child: CustomStatusBar(),
              ),
              
              // Header
              const Positioned(
                top: 56,
                left: 0,
                right: 0,
                child: AppHeader(),
              ),
              
              // Main Content Area
              Positioned(
                top: 122,
                left: -2,
                child: Container(
                  width: 428,
                  height: 814,
                  child: Container(
                    width: 428,
                    height: 779,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F1F1F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26000000),
                          offset: Offset(0, -4),
                          blurRadius: 6,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Welcome Back Text
                        const Positioned(
                          top: 36,
                          left: 0,
                          right: 0,
                          child: Text(
                            'Welcome Back',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        
                        // Menu Items
                        Positioned(
                          top: 98,
                          left: 20,
                          right: 20,
                          child: Column(
                            children: menuItems.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: MenuItemCard(item: item),
                            )).toList(),
                          ),
                        ),
                        
                        // Bottom Navigation
                        const Positioned(
                          bottom: 23,
                          left: 11,
                          child: CustomBottomNavigation(navItems: navItems),
                        ),
                        
                        // Bottom Image
                        Positioned(
                          bottom: 0,
                          left: 2,
                          child: Container(
                            width: 423,
                            height: 58,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/image-72.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}