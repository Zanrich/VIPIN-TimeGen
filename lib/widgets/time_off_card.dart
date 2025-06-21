import 'package:flutter/material.dart';
import '../models/time_off_models.dart';

class TimeOffCard extends StatelessWidget {
  final EmployeeTimeOffData employee;
  final TimeOffEntryData entry;
  final Function(String employeeId, String entryId)? onApprove;
  final Function(String employeeId, String entryId)? onDecline;

  const TimeOffCard({
    super.key,
    required this.employee,
    required this.entry,
    this.onApprove,
    this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Header
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(employee.avatar),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '[${employee.position}] | ',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xFF00DAE7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          entry.type,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xFF00DAE7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Entry Details
          _buildDetailRow('Submitted:', '[${entry.submittedDate}]'),
          const SizedBox(height: 8),
          _buildDetailRow('Date:', '[${entry.startDate} - ${entry.endDate}] (${entry.daysCount} ${entry.daysCount == 1 ? 'Day' : 'Days'})'),
          const SizedBox(height: 8),
          _buildDetailRow('Doctor\'s Note:', entry.doctorsNote ? 'Yes' : 'No'),
          const SizedBox(height: 8),
          _buildDetailRow('Comment:', entry.reason.isEmpty ? 'None' : '[${entry.reason}]'),
          
          // Status-specific content
          if (entry.status == 'approved' && entry.approvedDate != null) ...[
            const SizedBox(height: 8),
            _buildDetailRow('Approved:', '[${entry.approvedDate}]'),
          ],
          
          if (entry.status == 'declined') ...[
            if (entry.declinedDate != null) ...[
              const SizedBox(height: 8),
              _buildDetailRow('Declined:', '[${entry.declinedDate}]'),
            ],
            if (entry.managerComment != null && entry.managerComment!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildManagerComment(),
            ],
          ],
          
          // Action Buttons (only for awaiting approval)
          if (entry.status == 'awaiting approval') ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildApproveButton()),
                const SizedBox(width: 12),
                Expanded(child: _buildDeclineButton()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;
    
    switch (entry.status.toLowerCase()) {
      case 'approved':
        badgeColor = const Color(0xFF4CAF50);
        badgeText = 'APPROVED';
        break;
      case 'declined':
        badgeColor = const Color(0xFFF44336);
        badgeText = 'DECLINED';
        break;
      case 'awaiting approval':
      default:
        badgeColor = const Color(0xFF666666);
        badgeText = 'AWAITING APPROVAL';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagerComment() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF404040), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comment [Manager]:',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '[${entry.managerComment}]',
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproveButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF00DAE7),
            Color(0xFF0079A8),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onApprove?.call(employee.id, entry.id),
          child: const Center(
            child: Text(
              'Approve',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeclineButton() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onDecline?.call(employee.id, entry.id),
          child: const Center(
            child: Text(
              'Decline',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}