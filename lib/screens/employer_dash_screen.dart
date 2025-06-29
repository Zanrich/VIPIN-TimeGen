import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../models/menu_item.dart';
import '../models/nav_item.dart';
import '../widgets/app_header.dart';

class EmployerDashScreen extends StatefulWidget {
  const EmployerDashScreen({super.key});

  @override
  State<EmployerDashScreen> createState() => _EmployerDashScreenState();
}

class _EmployerDashScreenState extends State<EmployerDashScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
        child: Column(
          children: [
            // Header Section
            const AppHeader(),
            // Main Card Section fills the rest of the screen
            Expanded(
              child: Center(
                child: Container(
                  width: 423,
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
                      // Blue Top Border (rounded, clipped to match card)
                      Positioned(
                        top: 0,
                        left: -3,
                        right: -3,
                        child: CustomPaint(
                          size: const Size(double.infinity, 8),
                          painter: CurvedTopBorderPainter(
                            strokeWidth: 1,
                            radius: 30,
                            horizontalInset: 12,
                            color: const Color(0xFF00DAE7),
                          ),
                        ),
                      ),
                      // Main Content
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 14, right: 14, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            const Text(
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
                            const SizedBox(height: 24),
                            // Menu Items
                            ...menuItems.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: MenuItemCard(item: item),
                                )),
                            // Spacer to push content to the top if needed
                            const Spacer(),
                          ],
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
      // Navigation bar pinned to the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        child: CustomBottomNavigation(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}

class CurvedTopBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double radius;
  final double horizontalInset;

  CurvedTopBorderPainter({
    required this.strokeWidth,
    required this.radius,
    required this.horizontalInset,
    required this.color, // keep for compatibility, but not used
  });

  final Color color; // not used, but kept for constructor compatibility

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final r = radius;
    final h = strokeWidth / 2;

    final path = Path();

    // Start at the left, just after the curve
    path.moveTo(r, h);

    // Draw left arc (top left corner)
    path.arcToPoint(
      Offset(0, r + h),
      radius: Radius.circular(r),
      clockwise: false,
    );

    // Draw straight line
    path.lineTo(0, h + h);

    // Move to right side, draw straight line
    path.moveTo(width, r + h);
    path.arcToPoint(
      Offset(width - r, h),
      radius: Radius.circular(r),
      clockwise: false,
    );

    // Draw straight line between the two arcs
    path.moveTo(r, h);
    path.lineTo(width - r, h);

    // Create gradient shader
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF00DAE7),
        Color(0xFF0079A8),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = gradient
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
