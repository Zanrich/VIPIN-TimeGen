import 'package:flutter/material.dart';
import '../models/time_off_models.dart'; // <-- Use your app's models

class ExpandableEmployeeCard extends StatefulWidget {
  final EmployeeTimeOffData employee; // <-- Use your model
  final TimeOffEntryData entry; // <-- Use your model

  const ExpandableEmployeeCard({
    super.key,
    required this.employee,
    required this.entry,
  });

  @override
  State<ExpandableEmployeeCard> createState() => _ExpandableEmployeeCardState();
}

class _ExpandableEmployeeCardState extends State<ExpandableEmployeeCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Status badge colors
    Color statusBorderColor;
    Color statusTextColor;
    Color statusBgColor;
    String statusText = widget.entry.status;
    switch (widget.entry.status.toLowerCase()) {
      case 'approved':
        statusBorderColor = const Color(0xFFB8FF99);
        statusTextColor = const Color(0xFFB8FF99);
        statusBgColor = Colors.transparent;
        statusText = 'APPROVED';
        break;
      case 'declined':
      case 'rejected':
        statusBorderColor = const Color(0xFFFF8A80);
        statusTextColor = const Color(0xFFFF8A80);
        statusBgColor = Colors.transparent;
        statusText = 'DECLINED';
        break;
      case 'pending':
        statusBorderColor = const Color(0xFFBDBDBD);
        statusTextColor = const Color(0xFFBDBDBD);
        statusBgColor = Colors.transparent;
        statusText = 'AWAITING APPROVAL';
        break;
      default:
        statusBorderColor = Colors.white38;
        statusTextColor = Colors.white38;
        statusBgColor = Colors.transparent;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: const Color(0xFFBDBDBD),
                      backgroundImage: widget.employee.avatar.isNotEmpty
                          ? AssetImage(widget.employee.avatar)
                          : null,
                      child: widget.employee.avatar.isEmpty
                          ? const Icon(Icons.person,
                              color: Colors.white, size: 32)
                          : null,
                    ),
                    const SizedBox(width: 18),
                    // Name, subtitle, and chip
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.employee.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.02,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '[${widget.employee.position}] | ${widget.entry.type}',
                            style: const TextStyle(
                              color: Color(0xFF00DAE7),
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.02,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3), // 3px gap to chip
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 21,
                                constraints: const BoxConstraints(minWidth: 64),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: statusBorderColor, width: 1),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  statusText.toUpperCase(),
                                  style: TextStyle(
                                    color: statusTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.02,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Expanded details (unchanged)
                if (_expanded) ...[
                  const SizedBox(height: 16),
                  Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 12),
                  _buildDetailRow('Submitted:', widget.entry.submittedDate),
                  _buildDetailRow(
                    'Date:',
                    '[${widget.entry.startDate} - ${widget.entry.endDate}] ([${widget.entry.daysCount}] ${widget.entry.daysCount == 1 ? 'Day' : 'Days'})',
                  ),
                  if (widget.entry.doctorsNote != null)
                    _buildDetailRow('Doctor\'s Note:',
                        widget.entry.doctorsNote ? 'Yes' : 'No'),
                  if (widget.entry.managerComment != null &&
                      widget.entry.managerComment!.isNotEmpty)
                    _buildDetailRow('Comment [Manager]:',
                        '[${widget.entry.managerComment!}]'),
                  if (widget.entry.comment != null &&
                      widget.entry.comment!.isNotEmpty)
                    _buildDetailRow('Comment:', '[${widget.entry.comment!}]'),
                  if (widget.entry.status.toLowerCase() == 'approved' &&
                      widget.entry.approvedDate != null)
                    _buildDetailRow(
                        'Approved:', '[${widget.entry.approvedDate!}]'),
                  if (widget.entry.status.toLowerCase() == 'declined' &&
                      widget.entry.declinedDate != null)
                    _buildDetailRow(
                        'Declined:', '[${widget.entry.declinedDate!}]'),
                  if (widget.entry.status.toLowerCase() == 'pending') ...[
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Approve logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00DAE7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                          ),
                          child: const Text('Approve',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {
                            // Decline logic here
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                          ),
                          child: const Text('Decline',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
