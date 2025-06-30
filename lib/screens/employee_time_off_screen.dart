import 'package:flutter/material.dart';
import '../models/time_off_models.dart';
import '../widgets/expandable_employee_card.dart';
import '../widgets/app_header.dart';
import '../widgets/filter_dialog.dart';
import 'package:intl/intl.dart';

class EmployeeTimeOffScreen extends StatefulWidget {
  const EmployeeTimeOffScreen({super.key});

  @override
  State<EmployeeTimeOffScreen> createState() => _EmployeeTimeOffScreenState();
}

class _EmployeeTimeOffScreenState extends State<EmployeeTimeOffScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TimeOffEntryData> _allTimeOffEntries = [];
  List<TimeOffEntryData> _filteredTimeOffEntries = [];
  List<String> _selectedFilters = [];

  @override
  void initState() {
    super.initState();
    _allTimeOffEntries = _generateDummyData();
    _filteredTimeOffEntries = _allTimeOffEntries;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTimeOffEntries = _allTimeOffEntries;
      } else {
        _filteredTimeOffEntries = _allTimeOffEntries.where((entry) {
          final employee = _getEmployeeForEntry(entry);
          return employee.name.toLowerCase().contains(query) ||
              employee.position.toLowerCase().contains(query) ||
              entry.type.toLowerCase().contains(query) ||
              entry.status.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Dummy data generation function
  List<TimeOffEntryData> _generateDummyData() {
    return [
      TimeOffEntryData(
        id: '1',
        type: 'Sick Leave',
        status: 'Awaiting Approval',
        submittedDate: '11 March 2025',
        startDate: '11 March 2025',
        endDate: '11 March 2025',
        daysCount: 1,
        reason: 'Feeling unwell',
        doctorsNote: false,
        comment: 'Tummy Bug',
      ),
      TimeOffEntryData(
        id: '2',
        type: 'Sick Leave',
        status: 'Approved',
        submittedDate: '26 February 2025',
        startDate: '3 March 2025',
        endDate: '7 March 2025',
        daysCount: 5,
        reason: 'Medical leave',
        doctorsNote: true,
        approvedDate: '28 February 2025',
      ),
      TimeOffEntryData(
        id: '3',
        type: 'Annual Leave',
        status: 'Declined',
        submittedDate: '26 February 2025',
        startDate: '10 March 2025',
        endDate: '17 March 2025',
        daysCount: 6,
        reason: 'Vacation',
        doctorsNote: false,
        managerComment:
            'Another employee in the department is already on leave in the requested time. Submit leave for 24 March - 31 March',
        declinedDate: '28 February 2025',
      ),
      TimeOffEntryData(
        id: '4',
        type: 'Annual Leave',
        status: 'Approved',
        submittedDate: '10 January 2025',
        startDate: '1 April 2025',
        endDate: '10 April 2025',
        daysCount: 10,
        reason: 'Family trip',
        doctorsNote: false,
      ),
      TimeOffEntryData(
        id: '5',
        type: 'Family Responsibility',
        status: 'Awaiting Approval',
        submittedDate: '23 February 2025',
        startDate: '1 March 2025',
        endDate: '1 March 2025',
        daysCount: 1,
        reason: 'Family emergency',
        doctorsNote: false,
      ),
      TimeOffEntryData(
        // New entry to match screenshot for approved
        id: '6',
        type: 'Annual Leave',
        status: 'Approved',
        submittedDate: '25 February 2025',
        startDate: '15 March 2025',
        endDate: '20 March 2025',
        daysCount: 5,
        reason: 'Holiday',
        doctorsNote: false,
      ),
    ];
  }

  EmployeeTimeOffData _getEmployeeForEntry(TimeOffEntryData entry) {
    switch (entry.id) {
      case '1':
        return EmployeeTimeOffData(
          id: '101',
          name: 'Employee name', // Matches "Driver" for 'Tummy Bug'
          position: 'Driver',
          avatar: '',
          timeOffEntries: [],
        );
      case '2':
        return EmployeeTimeOffData(
          id: '102',
          name:
              'Sarah Johnson', // Matches "Project Manager" for approved sick leave
          position: 'Project Manager',
          avatar: '',
          timeOffEntries: [],
        );
      case '3':
        return EmployeeTimeOffData(
          id: '103',
          name:
              'Mike Wilson', // Matches "General Worker" for declined annual leave
          position: 'General Worker',
          avatar: '',
          timeOffEntries: [],
        );
      case '4':
        return EmployeeTimeOffData(
          id: '104',
          name: 'Jane Doe', // Example for approved annual leave (10 days)
          position: 'Software Engineer',
          avatar: '',
          timeOffEntries: [],
        );
      case '5':
        return EmployeeTimeOffData(
          id: '105',
          name: 'Emma Davis', // Matches "Designer" for family responsibility
          position: 'Designer',
          avatar: '',
          timeOffEntries: [],
        );
      case '6':
        return EmployeeTimeOffData(
          id: '106',
          name: 'John Smith', // New dummy employee for the extra approved entry
          position: 'Supervisor',
          avatar: '',
          timeOffEntries: [],
        );
      default:
        return EmployeeTimeOffData(
          id: 'unknown',
          name: 'Unknown Employee',
          position: 'N/A',
          avatar: '',
          timeOffEntries: [],
        );
    }
  }

  Map<String, List<TimeOffEntryData>> _groupEntriesByDate(
      List<TimeOffEntryData> entries) {
    Map<String, List<TimeOffEntryData>> grouped = {};
    for (var entry in entries) {
      if (!grouped.containsKey(entry.submittedDate)) {
        grouped[entry.submittedDate] = [];
      }
      grouped[entry.submittedDate]!.add(entry);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        try {
          final dateFormat = DateFormat('dd MMMM yyyy');
          final dateA = dateFormat.parse(a);
          final dateB = dateFormat.parse(b);
          return dateB.compareTo(dateA);
        } catch (e) {
          return b.compareTo(a);
        }
      });

    final sortedGrouped = <String, List<TimeOffEntryData>>{};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedEntries = _groupEntriesByDate(_filteredTimeOffEntries);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Center(
                child: Container(
                  width: 423,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x26000000),
                        offset: Offset(0, -4),
                        blurRadius: 6,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: -3,
                        right: -3,
                        child: CustomPaint(
                          size: const Size(double.infinity, 8),
                          painter: CurvedTopBorderPainter(
                            strokeWidth: 1,
                            radius: 30,
                            horizontalInset: 12,
                            color: const Color(0xFF00DAE7),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 0, right: 0, bottom: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 4),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.white,
                                        size: 24),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    splashRadius: 24,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Employee Time Off',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Remove the filter button here!
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 22, bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  FilterDialog(
                                                selectedFilters:
                                                    _selectedFilters,
                                                onFiltersChanged: (filters) {
                                                  setState(() {
                                                    _selectedFilters = filters;
                                                    if (_selectedFilters
                                                        .isEmpty) {
                                                      _filteredTimeOffEntries =
                                                          _allTimeOffEntries;
                                                    } else {
                                                      _filteredTimeOffEntries =
                                                          _allTimeOffEntries
                                                              .where((entry) =>
                                                                  _selectedFilters.any((f) =>
                                                                      entry
                                                                          .status
                                                                          .toLowerCase() ==
                                                                      f.toLowerCase()))
                                                              .toList();
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/images/filterGroup.png',
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF00DAE7)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00DAE7),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ),
                                      ),
                                      width: 48,
                                      height: 48,
                                      child: const Icon(Icons.search,
                                          color: Colors.black, size: 28),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Search Employee',
                                          hintStyle:
                                              TextStyle(color: Colors.white54),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                        ),
                                        onChanged: (query) =>
                                            _onSearchChanged(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // List of cards
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                itemCount: groupedEntries.length,
                                itemBuilder: (context, index) {
                                  final date =
                                      groupedEntries.keys.elementAt(index);
                                  final entriesForDate = groupedEntries[date]!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text(
                                          date,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      ...entriesForDate.map((entry) {
                                        final employee =
                                            _getEmployeeForEntry(entry);
                                        return ExpandableEmployeeCard(
                                            employee: employee, entry: entry);
                                      }).toList(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedTopBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double radius;
  final double horizontalInset;
  final Color color;

  CurvedTopBorderPainter({
    this.strokeWidth = 1,
    this.radius = 60,
    this.horizontalInset = 0,
    this.color = const Color(0xFF00DAE7),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double r = radius;
    final double w = size.width;
    final double h = strokeWidth / 2;

    final path = Path();

    path.moveTo(0, r + h);
    path.arcToPoint(
      Offset(r, h),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(w - r, h);
    path.arcToPoint(
      Offset(w, r + h),
      radius: Radius.circular(r),
      clockwise: true,
    );

    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF00DAE7),
        Color(0xFF0079A8),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = gradient
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
