class TimeOffEntryData {
  final String id;
  final String type;
  final String submittedDate;
  final String startDate;
  final String endDate;
  final String status; // 'awaiting approval', 'approved', 'declined'
  final String reason;
  final int daysCount;
  final bool doctorsNote;
  final String? approvedDate;
  final String? declinedDate;
  final String? managerComment;

  const TimeOffEntryData({
    required this.id,
    required this.type,
    required this.submittedDate,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
    required this.daysCount,
    required this.doctorsNote,
    this.approvedDate,
    this.declinedDate,
    this.managerComment,
  });

  TimeOffEntryData copyWith({
    String? id,
    String? type,
    String? submittedDate,
    String? startDate,
    String? endDate,
    String? status,
    String? reason,
    int? daysCount,
    bool? doctorsNote,
    String? approvedDate,
    String? declinedDate,
    String? managerComment,
  }) {
    return TimeOffEntryData(
      id: id ?? this.id,
      type: type ?? this.type,
      submittedDate: submittedDate ?? this.submittedDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      daysCount: daysCount ?? this.daysCount,
      doctorsNote: doctorsNote ?? this.doctorsNote,
      approvedDate: approvedDate ?? this.approvedDate,
      declinedDate: declinedDate ?? this.declinedDate,
      managerComment: managerComment ?? this.managerComment,
    );
  }
}

class EmployeeTimeOffData {
  final String id;
  final String name;
  final String avatar;
  final String position;
  final List<TimeOffEntryData> timeOffEntries;

  const EmployeeTimeOffData({
    required this.id,
    required this.name,
    required this.avatar,
    required this.position,
    required this.timeOffEntries,
  });

  EmployeeTimeOffData copyWith({
    String? id,
    String? name,
    String? avatar,
    String? position,
    List<TimeOffEntryData>? timeOffEntries,
  }) {
    return EmployeeTimeOffData(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      position: position ?? this.position,
      timeOffEntries: timeOffEntries ?? this.timeOffEntries,
    );
  }
}

enum TimeOffStatus {
  awaitingApproval('awaiting approval'),
  approved('approved'),
  declined('declined');

  const TimeOffStatus(this.value);
  final String value;

  static TimeOffStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'awaiting approval':
        return TimeOffStatus.awaitingApproval;
      case 'approved':
        return TimeOffStatus.approved;
      case 'declined':
        return TimeOffStatus.declined;
      default:
        return TimeOffStatus.awaitingApproval;
    }
  }
}