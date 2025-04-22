import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CalendarBody extends StatefulWidget {
  final bool isNepali;
  final Color primaryColor;
  final Color textColor;
  final NepaliDateTime selectedNepaliDate;
  final DateTime selectedEnglishDate;
  final Function(NepaliDateTime) onNepaliDateSelected;
  final Function(DateTime) onEnglishDateSelected;

  const CalendarBody({
    Key? key,
    required this.isNepali,
    required this.primaryColor,
    required this.textColor,
    required this.selectedNepaliDate,
    required this.selectedEnglishDate,
    required this.onNepaliDateSelected,
    required this.onEnglishDateSelected,
  }) : super(key: key);

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  late NepaliDateTime _displayedNepaliMonth;
  late DateTime _displayedEnglishMonth;

  @override
  void initState() {
    super.initState();
    _displayedNepaliMonth = NepaliDateTime(
      widget.selectedNepaliDate.year,
      widget.selectedNepaliDate.month,
      1,
    );
    _displayedEnglishMonth = DateTime(
      widget.selectedEnglishDate.year,
      widget.selectedEnglishDate.month,
      1,
    );
  }

  @override
  void didUpdateWidget(CalendarBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedNepaliDate != widget.selectedNepaliDate) {
      _displayedNepaliMonth = NepaliDateTime(
        widget.selectedNepaliDate.year,
        widget.selectedNepaliDate.month,
        1,
      );
    }
    if (oldWidget.selectedEnglishDate != widget.selectedEnglishDate) {
      _displayedEnglishMonth = DateTime(
        widget.selectedEnglishDate.year,
        widget.selectedEnglishDate.month,
        1,
      );
    }
  }

  void _previousMonth() {
    setState(() {
      if (widget.isNepali) {
        if (_displayedNepaliMonth.month == 1) {
          _displayedNepaliMonth = NepaliDateTime(
            _displayedNepaliMonth.year - 1,
            12,
            1,
          );
        } else {
          _displayedNepaliMonth = NepaliDateTime(
            _displayedNepaliMonth.year,
            _displayedNepaliMonth.month - 1,
            1,
          );
        }
      } else {
        _displayedEnglishMonth = DateTime(
          _displayedEnglishMonth.year,
          _displayedEnglishMonth.month - 1,
          1,
        );
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (widget.isNepali) {
        if (_displayedNepaliMonth.month == 12) {
          _displayedNepaliMonth = NepaliDateTime(
            _displayedNepaliMonth.year + 1,
            1,
            1,
          );
        } else {
          _displayedNepaliMonth = NepaliDateTime(
            _displayedNepaliMonth.year,
            _displayedNepaliMonth.month + 1,
            1,
          );
        }
      } else {
        _displayedEnglishMonth = DateTime(
          _displayedEnglishMonth.year,
          _displayedEnglishMonth.month + 1,
          1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMonthNavigator(),
        _buildWeekdayHeader(),
        widget.isNepali
            ? _buildNepaliCalendarGrid()
            : _buildEnglishCalendarGrid(),
      ],
    );
  }

  Widget _buildMonthNavigator() {
    final monthName = widget.isNepali
        ? NepaliDateFormat.MMMM().format(_displayedNepaliMonth)
        : _getEnglishMonth(_displayedEnglishMonth.month);
    
    final year = widget.isNepali
        ? _displayedNepaliMonth.year.toString()
        : _displayedEnglishMonth.year.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
            color: widget.primaryColor,
          ),
          Text(
            '$monthName $year',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
            color: widget.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    final weekdays = widget.isNepali
        ? ['आइत', 'सोम', 'मंगल', 'बुध', 'बिहि', 'शुक्र', 'शनि']
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays
            .map((day) => SizedBox(
                  width: 40,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNepaliCalendarGrid() {
final nepaliDate = _displayedNepaliMonth;
    final lastDayOfMonth = nepaliDate.month == 12 
        ? NepaliDateTime(nepaliDate.year + 1, 1, 1).subtract(const Duration(days: 1))
        : NepaliDateTime(nepaliDate.year, nepaliDate.month + 1, 1).subtract(const Duration(days: 1));
    final daysInMonth = lastDayOfMonth.day;

    // Get the weekday of the first day (0 = Sunday, 1 = Monday, etc.)
    final firstDay = NepaliDateTime(_displayedNepaliMonth.year, _displayedNepaliMonth.month, 1);
    final firstDayWeekday = firstDay.weekday % 7;

    // Calculate the number of rows needed
    final rowCount = ((daysInMonth + firstDayWeekday) / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(rowCount, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final dayIndex = rowIndex * 7 + colIndex - firstDayWeekday;
              if (dayIndex < 0 || dayIndex >= daysInMonth) {
                return const SizedBox(width: 40, height: 40);
              }

              final day = dayIndex + 1;
              final date = NepaliDateTime(
                _displayedNepaliMonth.year,
                _displayedNepaliMonth.month,
                day,
              );

              final isSelected = date.year == widget.selectedNepaliDate.year &&
                  date.month == widget.selectedNepaliDate.month &&
                  date.day == widget.selectedNepaliDate.day;

              return GestureDetector(
                onTap: () => widget.onNepaliDateSelected(date),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? widget.primaryColor : Colors.transparent,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : widget.textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildEnglishCalendarGrid() {
    // Get the total days in the current English month
    final daysInMonth = DateTime(
      _displayedEnglishMonth.year,
      _displayedEnglishMonth.month + 1,
      0,
    ).day;

    // Get the weekday of the first day (0 = Sunday, 1 = Monday, etc.)
    final firstDayWeekday = _displayedEnglishMonth.weekday % 7;

    // Calculate the number of rows needed
    final rowCount = ((daysInMonth + firstDayWeekday) / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(rowCount, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (colIndex) {
              final dayIndex = rowIndex * 7 + colIndex - firstDayWeekday;
              if (dayIndex < 0 || dayIndex >= daysInMonth) {
                return const SizedBox(width: 40, height: 40);
              }

              final day = dayIndex + 1;
              final date = DateTime(
                _displayedEnglishMonth.year,
                _displayedEnglishMonth.month,
                day,
              );

              final isSelected = date.year == widget.selectedEnglishDate.year &&
                  date.month == widget.selectedEnglishDate.month &&
                  date.day == widget.selectedEnglishDate.day;

              return GestureDetector(
                onTap: () => widget.onEnglishDateSelected(date),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? widget.primaryColor : Colors.transparent,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : widget.textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  String _getEnglishMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
