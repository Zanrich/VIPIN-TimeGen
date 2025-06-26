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
    Color statusColor;
    Color statusBorderColor;
    String statusText = widget.entry.status;
    switch (widget.entry.status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF4CAF50).withOpacity(0.15);
        statusBorderColor = const Color(0xFF4CAF50);
 statusText = 'Approved';
        break;
      case 'declined':
      case 'rejected':
        statusColor = const Color(0xFFF44336).withOpacity(0.15);
        statusBorderColor = const Color(0xFFF44336);
 statusText = 'Declined';
        break;
      case 'pending':
 statusColor = Colors.white12; // Gray for 'Awaiting Approval'
 statusBorderColor = Colors.white38; // Gray for 'Awaiting Approval'
        break;
      default:
        statusColor = Colors.white12;
        statusBorderColor = Colors.white38;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: _toggleExpand,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with avatar, name, leave type, status
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFBDBDBD),
                      backgroundImage: widget.employee.avatar.isNotEmpty
                          ? AssetImage(widget.employee.avatar)
                          : null,
                      child: widget.employee.avatar.isEmpty
                          ? const Icon(Icons.person,
                              color: Colors.white, size: 28)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.employee.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            '[${widget.employee.position}] | ${widget.entry.type}',
                            style: const TextStyle(
                              color: Color(0xFF00DAE7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor,
 borderRadius: BorderRadius.circular(20), // More rounded
                        border: Border.all(color: statusBorderColor, width: 1),
                      ),
                      child: Text(
                        widget.entry.status.toUpperCase(),
                        style: TextStyle(
                          color: statusBorderColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white54,
                        size: 26,
                      ),
                    ),
                  ],
                ),
                // Expandable details
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 12),
 if (widget.entry.status.toLowerCase() == 'pending') ...[
 _buildDetailRow('Submitted:', widget.entry.submissionDate), // Assuming you have a submissionDate
 _buildDetailRow('Date:', '${widget.entry.startDate} - ${widget.entry.endDate}'),
 _buildDetailRow('Duration:', '${widget.entry.daysCount} ${widget.entry.daysCount == 1 ? 'day' : 'days'}'),
 if (widget.entry.doctorNoteUrl != null && widget.entry.doctorNoteUrl!.isNotEmpty)
 _buildDetailRow('Doctor\'s Note:', 'View Attachment'), // Or a button to view
 if (widget.entry.reason.isNotEmpty)
 _buildDetailRow('Comment:', widget.entry.reason),
 const SizedBox(height: 16),
 Row(
 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
 Expanded(
                              child: ElevatedButton(
 onPressed: () {
 // Handle Approve action
 },
                                child: const Text('Approve'),
 ),
 ),
 const SizedBox(width: 12),
 Expanded(
                              child: ElevatedButton(
 onPressed: () {
 // Handle Decline action
 },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: const Text('Decline'),
 ),
 ),
 ],
 ),
                        ],
 else if (widget.entry.status.toLowerCase() == 'approved') ...[
 _buildDetailRow('Submitted:', widget.entry.submissionDate),
 _buildDetailRow('Date:', '${widget.entry.startDate} - ${widget.entry.endDate}'),
 _buildDetailRow('Duration:', '${widget.entry.daysCount} ${widget.entry.daysCount == 1 ? 'day' : 'days'}'),
 if (widget.entry.doctorNoteUrl != null && widget.entry.doctorNoteUrl!.isNotEmpty)
 _buildDetailRow('Doctor\'s Note:', 'View Attachment'),
 if (widget.entry.reason.isNotEmpty)
 _buildDetailRow('Comment:', widget.entry.reason),
 _buildDetailRow('Approved:', widget.entry.approvalDate ?? 'N/A'), // Assuming an approvalDate
                        ],
 else if (widget.entry.status.toLowerCase() == 'declined' || widget.entry.status.toLowerCase() == 'rejected') ...[
 _buildDetailRow('Submitted:', widget.entry.submissionDate),
                          _buildDetailRow('Reason:', widget.entry.reason),
                      ],
                    ),
                  ),
                ),
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
