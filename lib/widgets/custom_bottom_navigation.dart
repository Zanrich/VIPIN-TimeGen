import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': 'assets/icons/home.png', 'label': 'HOME'},
      {'icon': 'assets/icons/calendar_today.png', 'label': 'TIMESHEETS'},
      {'icon': 'assets/icons/people.png', 'label': 'EMPLOYEES'},
      {'icon': 'assets/icons/grid_view.png', 'label': 'MENU'},
    ];

    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00DAE7), Color(0xFF0079A8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(1), // Border thickness
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index) {
            final isActive = index == currentIndex;
            BorderRadius tabRadius = BorderRadius.circular(28);
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  height: double.infinity,
                  decoration: isActive
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00DAE7), Color(0xFF009FFD)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: tabRadius,
                        )
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        items[index]['icon'] as String,
                        color: isActive ? Colors.black : Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[index]['label'] as String,
                        style: TextStyle(
                          color: isActive ? Colors.black : Colors.white,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
