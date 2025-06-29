// lib/widgets/expandable_employee_card.dart
import 'package:flutter/material.dart';
import '../models/time_off_models.dart'; // Adjust import based on your project

class ExpandableEmployeeCard extends StatefulWidget {
  final EmployeeTimeOffData employee;
  final TimeOffEntryData entry;

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
  String? _localStatus;

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
    final String normalisedStatus =
        (_localStatus ?? widget.entry.status).trim().toLowerCase();
    final bool isPending = normalisedStatus == 'pending' ||
        normalisedStatus == 'awaiting approval';

    // Status badge colors and text
    Color statusBorderColor;
    Color statusTextColor;
    Color statusBgColor;
    String statusDisplayText; // Use a distinct variable for display text

    switch (normalisedStatus) {
      case 'approved':
        statusBorderColor = const Color(0xFFB8FF99);
        statusTextColor = const Color(0xFFB8FF99);
        statusBgColor = Colors.transparent;
        statusDisplayText = 'APPROVED';
        break;
      case 'declined':
      case 'rejected':
        statusBorderColor = const Color(0xFFFF8A80);
        statusTextColor = const Color(0xFFFF8A80);
        statusBgColor = Colors.transparent;
        statusDisplayText = 'DECLINED';
        break;
      default: // Awaiting Approval / Pending
        statusBorderColor = const Color(0xFFBDBDBD);
        statusTextColor = const Color(0xFFBDBDBD);
        statusBgColor = Colors.transparent;
        statusDisplayText = 'AWAITING APPROVAL';
    }

    // Function to create the status chip widget
    Widget _buildStatusChip() {
      return Container(
        height: 21,
        constraints: const BoxConstraints(minWidth: 64),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: statusBgColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: statusBorderColor, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          statusDisplayText,
          style: TextStyle(
            color: statusTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 8,
            fontFamily: 'Roboto',
            letterSpacing: 0.02,
          ),
        ),
      );
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
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
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
                    // Name, subtitle
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
                        ],
                      ),
                    ),
                    // Status chip in collapsed state (aligned to top-right of initial row)
                    if (!_expanded) _buildStatusChip(),
                  ],
                ),
                // Expanded content section
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1.0,
                  // Use a Column for flexible height within the expanded section
                  // Ensure it can grow as needed and properly place the spacer.
                  child: IntrinsicHeight(
                    // Helps the Column determine its height based on its children
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white12, height: 1),
                        const SizedBox(height: 12),
                        _buildDetailRow(
                            'Submitted:', widget.entry.submittedDate),
                        _buildDetailRow(
                          'Date:',
                          '[${widget.entry.startDate} - ${widget.entry.endDate}] ([${widget.entry.daysCount}] ${widget.entry.daysCount == 1 ? 'Day' : 'Days'})',
                        ),
                        if (widget.entry.doctorsNote != null)
                          _buildDetailRow('Doctor\'s Note:',
                              widget.entry.doctorsNote! ? 'Yes' : 'No'),
                        if (widget.entry.comment != null &&
                            widget.entry.comment!.isNotEmpty)
                          _buildDetailRow(
                              'Comment:', '[${widget.entry.comment!}]'),
                        if (widget.entry.managerComment != null &&
                            widget.entry.managerComment!.isNotEmpty)
                          _buildDetailRow('Comment [Manager]:',
                              '[${widget.entry.managerComment!}]'),
                        if ((_localStatus ?? widget.entry.status)
                                    .toLowerCase() ==
                                'approved' &&
                            widget.entry.approvedDate != null)
                          _buildDetailRow(
                              'Approved:', '[${widget.entry.approvedDate!}]'),
                        if ((_localStatus ?? widget.entry.status)
                                    .toLowerCase() ==
                                'declined' &&
                            widget.entry.declinedDate != null)
                          _buildDetailRow(
                              'Declined:', '[${widget.entry.declinedDate!}]'),

                        // This Spacer needs to be correctly constrained by its parent.
                        // By placing the content inside IntrinsicHeight, the Column tries to take
                        // minimum height, and then the Spacer tries to take remaining.
                        // For a dynamic height column inside a list, often Expanded is better
                        // but that requires the parent to be a Row/Column, which SizeTransition isn't directly.
                        // Let's try placing this in an Expanded in a Row to give it infinite height to fill.
                        // Removed direct Spacer, will handle spacing with bottom row.

                        const SizedBox(
                            height: 18), // Space before buttons/status chip

                        // Row for buttons and status chip at the bottom when expanded
                        // This row needs to push itself to the bottom of the expanded area.
                        // If the column has intrinsic height, its height will fit its children.
                        // To push this row to the bottom, the parent column must be given
                        // flexible space using an Expanded widget, or a fixed height.
                        // Let's reconsider the Spacer here. If this Column is inside SizeTransition,
                        // it needs to calculate its own height. A Spacer within it will try to
                        // expand vertically within that calculated height.

                        // Let's put a flexible space here if we want the buttons/chip
                        // to be at the "bottom" of a potentially larger card area.
                        // If the card's height is determined by its content, and we want
                        // the buttons at the very bottom, then the content above it
                        // needs to be flexible, or the entire column needs a min height.

                        // Re-introducing Spacer within an Expanded to allow it to push content up
                        // This Spacer must be within a Flexible or Expanded widget to work.
                        // Since the parent of this column is SizeTransition, its height is determined
                        // by its children. We need this column to take *all available vertical space*
                        // within the expanded area, then the Spacer works.
                        // This is tricky with SizeTransition which animates content height.

                        // Option 1: Just add vertical space instead of a Spacer.
                        // This makes the card just tall enough for its content + buttons.
                        // This looks like what the image is doing for most cases.
                        // No explicit Spacer, just `SizedBox` for spacing.

                        // If you *really* want the buttons/status to push to the *absolute* bottom
                        // of a *predefined* expanded height, it's more complex with SizeTransition.
                        // For now, matching the screenshot where content dictates height:
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // Align to the right
                          children: [
                            if (isPending) ...[
                              // Only show buttons if status is pending
                              // Approve button
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _localStatus = 'approved';
                                    _expanded = false; // Collapse after action
                                    _animationController.reverse();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00DAE7),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                ),
                                child: const Text('Approve',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(width: 12),
                              // Decline button
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _localStatus = 'declined';
                                    _expanded = false; // Collapse after action
                                    _animationController.reverse();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 8),
                                ),
                                child: const Text('Decline',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(
                                  width: 12), // Space between buttons and chip
                            ],
                            _buildStatusChip(), // Status chip always at the bottom right when expanded
                          ],
                        ),
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
