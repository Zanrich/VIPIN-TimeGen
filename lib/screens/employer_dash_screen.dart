import 'package:flutter/material.dart';
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
            const AppHeader(),
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
                            ...menuItems.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: MenuItemCard(item: item),
                                )),
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          // Calculate bottom padding based on the safe area inset
          // and add a small buffer if desired.
          bottom: MediaQuery.of(context).padding.bottom +
              10.0, // This is the crucial line
        ),
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
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final r = radius;
    final h = strokeWidth / 2;

    final path = Path();

    path.moveTo(r, h);

    path.arcToPoint(
      Offset(0, r + h),
      radius: Radius.circular(r),
      clockwise: false,
    );

    path.lineTo(0, h + h);

    path.moveTo(width, r + h);
    path.arcToPoint(
      Offset(width - r, h),
      radius: Radius.circular(r),
      clockwise: false,
    );

    path.moveTo(r, h);
    path.lineTo(width - r, h);

    final gradient = const LinearGradient(
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
