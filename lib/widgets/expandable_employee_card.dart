import 'package:flutter/material.dart';
import '../models/time_off_models.dart';

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

    Color statusBorderColor;
    Color statusTextColor;
    Color statusBgColor;
    String statusDisplayText;

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
      default:
        statusBorderColor = const Color(0xFFBDBDBD);
        statusTextColor = const Color(0xFFBDBDBD);
        statusBgColor = Colors.transparent;
        statusDisplayText = 'AWAITING APPROVAL';
    }

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
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/user-10.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFBDBDBD),
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 32),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
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
                    if (!_expanded) _buildStatusChip(),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  axisAlignment: -1.0,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
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
                        if (isPending) const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (isPending) ...[
                              Container(
                                width: 97,
                                height: 30,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00DAE7),
                                      Color(0xFF007A81)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x59000000),
                                      offset: Offset(4, 4),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _localStatus = 'approved';
                                      _expanded = false;
                                      _animationController.reverse();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ).copyWith(
                                      elevation: MaterialStateProperty.all(0)),
                                  child: const Text(
                                    'Approve',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 97,
                                height: 30,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _localStatus = 'declined';
                                      _expanded = false;
                                      _animationController.reverse();
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ).copyWith(
                                    shadowColor: MaterialStateProperty.all(
                                        const Color(0x59000000)),
                                    elevation: MaterialStateProperty.all(4),
                                  ),
                                  child: const Text(
                                    'Decline',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            _buildStatusChip(),
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
