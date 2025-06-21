import '../models/time_off_models.dart';

class TimeOffService {
  // This is where you'll replace dummy data with actual API calls
  
  static Future<List<EmployeeTimeOffData>> getAllEmployees() async {
    // TODO: Replace with actual API call
    // Example: final response = await http.get(Uri.parse('$baseUrl/employees'));
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _dummyEmployeeData;
  }
  
  static Future<List<EmployeeTimeOffData>> searchEmployees(String query) async {
    // TODO: Replace with actual API call
    // Example: final response = await http.get(Uri.parse('$baseUrl/employees/search?q=$query'));
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _dummyEmployeeData
        .where((employee) => 
            employee.name.toLowerCase().contains(query.toLowerCase()) ||
            employee.position.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  
  static Future<List<EmployeeTimeOffData>> filterEmployees(List<String> statusFilters) async {
    // TODO: Replace with actual API call
    // Example: final response = await http.post(Uri.parse('$baseUrl/employees/filter'), body: {'statuses': statusFilters});
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (statusFilters.isEmpty) return _dummyEmployeeData;
    
    return _dummyEmployeeData.map((employee) {
      final filteredEntries = employee.timeOffEntries
          .where((entry) => statusFilters.contains(entry.status.toLowerCase()))
          .toList();
      
      return EmployeeTimeOffData(
        id: employee.id,
        name: employee.name,
        avatar: employee.avatar,
        position: employee.position,
        timeOffEntries: filteredEntries,
      );
    }).where((employee) => employee.timeOffEntries.isNotEmpty).toList();
  }
  
  static Future<bool> approveTimeOff(String employeeId, String entryId) async {
    // TODO: Replace with actual API call
    // Example: final response = await http.put(Uri.parse('$baseUrl/time-off/$entryId/approve'));
    
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Return success status
  }
  
  static Future<bool> declineTimeOff(String employeeId, String entryId, String reason) async {
    // TODO: Replace with actual API call
    // Example: final response = await http.put(Uri.parse('$baseUrl/time-off/$entryId/decline'), body: {'reason': reason});
    
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Return success status
  }

  // DUMMY DATA - Replace this entire section with your API integration
  static final List<EmployeeTimeOffData> _dummyEmployeeData = [
    const EmployeeTimeOffData(
      id: '1',
      name: 'John Smith',
      avatar: 'assets/images/user-10.png',
      position: 'Driver',
      timeOffEntries: [
        TimeOffEntryData(
          id: '1',
          type: 'Sick Leave',
          submittedDate: '11 March 2025',
          startDate: '11 March 2025',
          endDate: '11 March 2025',
          status: 'awaiting approval',
          reason: 'Tummy Bug',
          daysCount: 1,
          doctorsNote: false,
          approvedDate: null,
          declinedDate: null,
          managerComment: null,
        ),
      ],
    ),
    const EmployeeTimeOffData(
      id: '2',
      name: 'Sarah Johnson',
      avatar: 'assets/images/user-10.png',
      position: 'Project Manager',
      timeOffEntries: [
        TimeOffEntryData(
          id: '2',
          type: 'Sick Leave',
          submittedDate: '26 February 2025',
          startDate: '3 March 2025',
          endDate: '7 March 2025',
          status: 'approved',
          reason: '',
          daysCount: 5,
          doctorsNote: true,
          approvedDate: '28 February 2025',
          declinedDate: null,
          managerComment: null,
        ),
      ],
    ),
    const EmployeeTimeOffData(
      id: '3',
      name: 'Mike Wilson',
      avatar: 'assets/images/user-10.png',
      position: 'General Worker',
      timeOffEntries: [
        TimeOffEntryData(
          id: '3',
          type: 'Annual Leave',
          submittedDate: '26 February 2025',
          startDate: '10 March 2025',
          endDate: '17 March 2025',
          status: 'declined',
          reason: '',
          daysCount: 6,
          doctorsNote: false,
          approvedDate: null,
          declinedDate: '28 February 2025',
          managerComment: 'Another employee in the department is already on leave in the requested time. Submit leave for 24 March - 31 March',
        ),
      ],
    ),
    const EmployeeTimeOffData(
      id: '4',
      name: 'Emma Davis',
      avatar: 'assets/images/user-10.png',
      position: 'Designer',
      timeOffEntries: [
        TimeOffEntryData(
          id: '4',
          type: 'Family Responsibility',
          submittedDate: '23 February 2025',
          startDate: '25 February 2025',
          endDate: '26 February 2025',
          status: 'awaiting approval',
          reason: 'Family emergency',
          daysCount: 2,
          doctorsNote: false,
          approvedDate: null,
          declinedDate: null,
          managerComment: null,
        ),
      ],
    ),
  ];
}