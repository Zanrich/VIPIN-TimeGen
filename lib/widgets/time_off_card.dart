class EmployeeTimeOffData {
  final String name;
  final String position;
  final String avatar;

  EmployeeTimeOffData({
    required this.name,
    required this.position,
    this.avatar = '',
  });
}

class TimeOffEntryData {
  final String type;
  final String status;
  final String submittedDate;
  final String startDate;
  final String endDate;
  final int daysCount;
  final bool? doctorsNote;
  final String? managerComment;
  final String? comment;
  final String? approvedDate;
  final String? declinedDate;

  TimeOffEntryData({
    required this.type,
    required this.status,
    required this.submittedDate,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    this.doctorsNote,
    this.managerComment,
    this.comment,
    this.approvedDate,
    this.declinedDate,
  });
}
