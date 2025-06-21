import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../screens/employee_time_off_screen.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 388,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 0),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            _handleMenuItemTap(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Menu Icon
                Image.asset(
                  item.icon,
                  width: 42,
                  height: 42,
                ),
                
                const SizedBox(width: 20),
                
                // Menu Title
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                
                // Chevron Right
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuItemTap(BuildContext context) {
    switch (item.title) {
      case 'Employee Time Off':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EmployeeTimeOffScreen(),
          ),
        );
        break;
      case 'Scan Employee':
        // TODO: Navigate to scan employee screen
        _showComingSoon(context, 'Scan Employee');
        break;
      case 'Flagged Events':
        // TODO: Navigate to flagged events screen
        _showComingSoon(context, 'Flagged Events');
        break;
      case 'Add Employees for Manual Clocking':
        // TODO: Navigate to manual clocking screen
        _showComingSoon(context, 'Manual Clocking');
        break;
      default:
        _showComingSoon(context, item.title);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: const Color(0xFF00DAE7),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}