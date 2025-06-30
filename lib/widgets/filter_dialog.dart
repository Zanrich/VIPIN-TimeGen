import 'dart:ui';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersChanged;

  const FilterDialog({
    super.key,
    required this.selectedFilters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> _tempSelectedFilters;

  final List<Map<String, String>> _filterOptions = [
    {'key': 'approved', 'label': 'Approved'},
    {'key': 'awaiting approval', 'label': 'Awaiting Approval'},
    {'key': 'declined', 'label': 'Declined'},
  ];

  @override
  void initState() {
    super.initState();
    _tempSelectedFilters = List.from(widget.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 14),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF00DAE7),
                            Color(0xFF0079A8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(19),
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 77,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF00DAE7),
                                        Color(0x020286B1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  margin: const EdgeInsets.only(
                                      left: 1, right: 1, top: 1, bottom: 1),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2B2B2B),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(19),
                                      topRight: Radius.circular(19),
                                      bottomLeft: Radius.circular(19),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 24),
                                      const Text(
                                        'Filter',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            color: Colors.transparent,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2B2B2B),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(19),
                                  bottomRight: Radius.circular(19),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ..._filterOptions.map(
                                      (option) => _buildFilterOption(option)),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    child: _buildApplyButton(),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _tempSelectedFilters.clear();
                                      });
                                    },
                                    child: const Text(
                                      'Clear Filter',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOption(Map<String, String> option) {
    final isSelected = _tempSelectedFilters.contains(option['key']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              if (isSelected) {
                _tempSelectedFilters.remove(option['key']);
              } else {
                _tempSelectedFilters.add(option['key']!);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Text(
                  option['label']!,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          isSelected ? const Color(0xFF00DAE7) : Colors.white70,
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFF00DAE7)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            widget.onFiltersChanged(_tempSelectedFilters);
            Navigator.pop(context);
          },
          child: const Center(
            child: Text(
              'Apply',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
