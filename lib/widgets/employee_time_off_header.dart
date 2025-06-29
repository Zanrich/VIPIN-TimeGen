// lib/widgets/employee_time_off_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Make sure to add flutter_svg to your pubspec.yaml

class EmployeeTimeOffHeader extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBackButtonPressed;
  final VoidCallback? onFilterButtonPressed;
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;

  const EmployeeTimeOffHeader({
    super.key,
    this.onBackButtonPressed,
    this.onFilterButtonPressed,
    required this.searchController,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E1E1E), // Darker top
            Color(0xFF2B2B2B), // Slightly lighter bottom, matching card
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/nextsvg.svg', // Adjust path if needed
                      colorFilter: const ColorFilter.mode(
                          Color(0xFF00DAE7), BlendMode.srcIn),
                      width: 24, // Adjust size as needed
                      height: 24, // Adjust size as needed
                    ),
                    onPressed: onBackButtonPressed,
                  ),
                  const Text(
                    'Employee Time Off',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/filterGroup.png', // Adjust path if needed
                      width: 28, // Adjust size as needed
                      height: 28, // Adjust size as needed
                    ),
                    onPressed: onFilterButtonPressed,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B), // Search bar background
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF00DAE7), // Border color
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search Employee',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(Icons.search,
                          color: Color(0xFF00DAE7), size: 28),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 40),
                    border: InputBorder.none, // Remove default TextField border
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 110); // Adjust height as needed
}
