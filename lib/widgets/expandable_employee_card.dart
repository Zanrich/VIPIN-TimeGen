import 'package:flutter/material.dart';

class TimeOffEntry {
  final String type;
  final String startDate;
  final String endDate;
  final String status;
  final String reason;
  final int daysCount;

  const TimeOffEntry({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.daysCount,
  });
}

class EmployeeData {
  final String name;
  final String avatar;
  final String position;
  final List<TimeOffEntry> timeOffEntries;

  const EmployeeData({
    required this.name,
    required this.avatar,
    required this.position,
    required this.timeOffEntries,
  });
}

class ExpandableEmployeeCard extends StatefulWidget {
  final EmployeeData employee;
  final bool isExpanded;
  final VoidCallback onTap;

  const ExpandableEmployeeCard({
    super.key,
    required this.employee,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<ExpandableEmployeeCard> createState() => _ExpandableEmployeeCardState();
}

class _ExpandableEmployeeCardState extends State<ExpandableEmployeeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(ExpandableEmployeeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Employee Header Card
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Employee Avatar
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(widget.employee.avatar),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Employee Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.employee.name,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.employee.position,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Time Off Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00DAE7).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00DAE7),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${widget.employee.timeOffEntries.length} Requests',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00DAE7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Expand/Collapse Icon
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expandable Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFF404040),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  
                  // Time Off Entries Header
                  const Text(
                    'Time Off History',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Time Off Entries List
                  ...widget.employee.timeOffEntries.map((entry) => _buildTimeOffEntry(entry)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOffEntry(TimeOffEntry entry) {
    Color statusColor;
    Color statusBgColor;
    
    switch (entry.status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF4CAF50);
        statusBgColor = const Color(0xFF4CAF50).withOpacity(0.2);
        break;
      case 'pending':
        statusColor = const Color(0xFFFFA726);
        statusBgColor = const Color(0xFFFFA726).withOpacity(0.2);
        break;
      case 'rejected':
        statusColor = const Color(0xFFF44336);
        statusBgColor = const Color(0xFFF44336).withOpacity(0.2);
        break;
      default:
        statusColor = Colors.white70;
        statusBgColor = Colors.white.withOpacity(0.1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF404040),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry Header
          Row(
            children: [
              // Time Off Type
              Expanded(
                child: Text(
                  entry.type,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  entry.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Date Range and Duration
          Row(
            children: [
              // Calendar Icon
              const Icon(
                Icons.calendar_today,
                color: Colors.white70,
                size: 16,
              ),
              
              const SizedBox(width: 8),
              
              // Date Range
              Expanded(
                child: Text(
                  '${entry.startDate} - ${entry.endDate}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              
              // Duration Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00DAE7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${entry.daysCount} ${entry.daysCount == 1 ? 'day' : 'days'}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00DAE7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          
          // Reason (if provided)
          if (entry.reason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason:',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.reason,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}