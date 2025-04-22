import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

import '../providers/calendar_provider.dart';

class CalendarBody extends StatelessWidget {
  final Color primaryColor;
  final Color textColor;

  const CalendarBody({
    Key? key,
    required this.primaryColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    return Column(
      children: [
        _buildMonthNavigator(context),
        _buildWeekdayHeader(context),
        provider.isNepali
            ? _buildNepaliCalendarGrid(context)
            : _buildEnglishCalendarGrid(context),
      ],
    );
  }

  Widget _buildMonthNavigator(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    final monthName = provider.isNepali
        ? NepaliDateFormat.MMMM().format(provider.displayedNepaliMonth)
        : provider.getEnglishMonthName(provider.displayedEnglishMonth.month);
    
    final year = provider.isNepali
        ? provider.displayedNepaliMonth.year.toString()
        : provider.displayedEnglishMonth.year.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => provider.previousMonth(),
            color: primaryColor,
          ),
          Text(
            '$monthName $year',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => provider.nextMonth(),
            color: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    final weekdays = provider.isNepali
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
                      color: textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildNepaliCalendarGrid(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    final daysInMonth = provider.daysInNepaliMonth;
    final firstDayWeekday = provider.firstDayWeekdayNepali;
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
                provider.displayedNepaliMonth.year,
                provider.displayedNepaliMonth.month,
                day,
              );

              final isSelected = date.year == provider.selectedNepaliDate.year &&
                  date.month == provider.selectedNepaliDate.month &&
                  date.day == provider.selectedNepaliDate.day;

              return GestureDetector(
                onTap: () => provider.selectNepaliDate(date),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor : Colors.transparent,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : textColor,
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

  Widget _buildEnglishCalendarGrid(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    final daysInMonth = provider.daysInEnglishMonth;
    final firstDayWeekday = provider.firstDayWeekdayEnglish;
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
                provider.displayedEnglishMonth.year,
                provider.displayedEnglishMonth.month,
                day,
              );

              final isSelected = date.year == provider.selectedEnglishDate.year &&
                  date.month == provider.selectedEnglishDate.month &&
                  date.day == provider.selectedEnglishDate.day;

              return GestureDetector(
                onTap: () => provider.selectEnglishDate(date),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryColor : Colors.transparent,
                  ),
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : textColor,
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
}
