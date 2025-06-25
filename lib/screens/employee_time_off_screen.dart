import 'package:flutter/material.dart';
import '../widgets/status_bar.dart';
import '../widgets/time_off_card.dart';
import '../widgets/filter_dialog.dart';
import '../models/time_off_models.dart';
import '../services/time_off_service.dart';

class EmployeeTimeOffScreen extends StatefulWidget {
  const EmployeeTimeOffScreen({super.key});

  @override
  State<EmployeeTimeOffScreen> createState() => _EmployeeTimeOffScreenState();
}

class _EmployeeTimeOffScreenState extends State<EmployeeTimeOffScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EmployeeTimeOffData> _allEmployees = [];
  List<EmployeeTimeOffData> _filteredEmployees = [];
  List<String> _selectedFilters = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _applyFiltersAndSearch();
  }

  Future<void> _loadEmployees() async {
    try {
      final employees = await TimeOffService.getAllEmployees();
      setState(() {
        _allEmployees = employees;
        _filteredEmployees = employees;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load employees');
    }
  }

  Future<void> _applyFiltersAndSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<EmployeeTimeOffData> result = _allEmployees;

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        result = await TimeOffService.searchEmployees(_searchQuery);
      }

      // Apply status filters
      if (_selectedFilters.isNotEmpty) {
        result = await TimeOffService.filterEmployees(_selectedFilters);

        // If we also have a search query, filter the results further
        if (_searchQuery.isNotEmpty) {
          result = result
              .where((employee) =>
                  employee.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  employee.position
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
              .toList();
        }
      }

      setState(() {
        _filteredEmployees = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to apply filters');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        selectedFilters: _selectedFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _selectedFilters = filters;
          });
          _applyFiltersAndSearch();
        },
      ),
    );
  }

  Future<void> _approveTimeOff(String employeeId, String entryId) async {
    try {
      final success = await TimeOffService.approveTimeOff(employeeId, entryId);
      if (success) {
        _showSuccessSnackBar('Time off request approved successfully');
        _loadEmployees(); // Refresh data
      } else {
        _showErrorSnackBar('Failed to approve time off request');
      }
    } catch (e) {
      _showErrorSnackBar('Error approving time off request');
    }
  }

  Future<void> _declineTimeOff(String employeeId, String entryId) async {
    // Show decline reason dialog
    final reason = await _showDeclineReasonDialog();
    if (reason == null) return;

    try {
      final success =
          await TimeOffService.declineTimeOff(employeeId, entryId, reason);
      if (success) {
        _showSuccessSnackBar('Time off request declined');
        _loadEmployees(); // Refresh data
      } else {
        _showErrorSnackBar('Failed to decline time off request');
      }
    } catch (e) {
      _showErrorSnackBar('Error declining time off request');
    }
  }

  Future<String?> _showDeclineReasonDialog() async {
    final TextEditingController reasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          'Decline Reason',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter reason for declining...',
            hintStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00DAE7)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, reasonController.text),
            child: const Text(
              'Decline',
              style: TextStyle(color: Color(0xFFF44336)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Container(
          width: 423,
          height: 936,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Stack(
            children: [
              // Status Bar
              const Positioned(
                top: -5,
                left: 4,
                child: CustomStatusBar(),
              ),

              // Header
              Positioned(
                top: 56,
                left: 0,
                right: 0,
                child: _buildHeader(),
              ),

              // Main Content Area
              Positioned(
                top: 122,
                left: -2,
                child: SizedBox(
                  width: 428,
                  height: 814,
                  child: Container(
                    width: 428,
                    height: 779,
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
                    child: Column(
                      children: [
                        // Search and Filter Section
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),

                              // Search Bar and Filter Button
                              Row(
                                children: [
                                  // Search Bar
                                  Expanded(child: _buildSearchBar()),
                                  const SizedBox(width: 12),
                                  // Filter Button
                                  _buildFilterButton(),
                                ],
                              ),

                              // Active Filters Display
                              if (_selectedFilters.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _buildActiveFilters(),
                              ],
                            ],
                          ),
                        ),

                        // Content Area
                        Expanded(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00DAE7),
                                  ),
                                )
                              : _filteredEmployees.isEmpty
                                  ? _buildEmptyState()
                                  : _buildEmployeesList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Back Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const Spacer(),

          // Title
          const Text(
            'Employee Time Off',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Color(0xFFEDF2F4),
              fontSize: 28,
            ),
          ),

          const Spacer(),

          // Close Button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00DAE7), width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: const InputDecoration(
          hintText: 'Search Employee',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF00DAE7),
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF00DAE7),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: _showFilterDialog,
          child: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedFilters.map((filter) {
        String displayText;
        switch (filter) {
          case 'awaiting approval':
            displayText = 'Awaiting Approval';
            break;
          case 'approved':
            displayText = 'Approved';
            break;
          case 'declined':
            displayText = 'Declined';
            break;
          default:
            displayText = filter;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF00DAE7).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00DAE7), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayText,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xFF00DAE7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilters.remove(filter);
                  });
                  _applyFiltersAndSearch();
                },
                child: const Icon(
                  Icons.close,
                  color: Color(0xFF00DAE7),
                  size: 16,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            color: Colors.white70,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No employees found',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesList() {
    // Group entries by date for better organization
    final Map<String, List<Widget>> groupedEntries = {};

    for (final employee in _filteredEmployees) {
      for (final entry in employee.timeOffEntries) {
        final dateKey = entry.submittedDate;
        if (!groupedEntries.containsKey(dateKey)) {
          groupedEntries[dateKey] = [];
        }
        groupedEntries[dateKey]!.add(
          TimeOffCard(
            employee: employee,
            entry: entry,
            onApprove: _approveTimeOff,
            onDecline: _declineTimeOff,
          ),
        );
      }
    }

    // Sort dates in descending order (most recent first)
    final sortedDates = groupedEntries.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final entries = groupedEntries[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: EdgeInsets.only(bottom: 16, top: index == 0 ? 0 : 24),
              child: Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

            // Entries for this date
            ...entries,
          ],
        );
      },
    );
  }
}
