import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

enum CalendarType {
  nepali,
  english,
}

class CalendarProvider extends ChangeNotifier {
  // Current calendar type
  CalendarType _currentType;
  
  // Selected dates
  DateTime _selectedEnglishDate;
  NepaliDateTime _selectedNepaliDate;
  
  // Displayed month
  DateTime _displayedEnglishMonth;
  NepaliDateTime _displayedNepaliMonth;

  CalendarProvider({
    CalendarType initialCalendarType = CalendarType.nepali,
  }) : _currentType = initialCalendarType,
       _selectedEnglishDate = DateTime.now(),
       _selectedNepaliDate = NepaliDateTime.now(),
       _displayedEnglishMonth = DateTime(DateTime.now().year, DateTime.now().month, 1),
       _displayedNepaliMonth = NepaliDateTime(NepaliDateTime.now().year, NepaliDateTime.now().month, 1);

  // Getters
  CalendarType get currentType => _currentType;
  DateTime get selectedEnglishDate => _selectedEnglishDate;
  NepaliDateTime get selectedNepaliDate => _selectedNepaliDate;
  DateTime get displayedEnglishMonth => _displayedEnglishMonth;
  NepaliDateTime get displayedNepaliMonth => _displayedNepaliMonth;
  bool get isNepali => _currentType == CalendarType.nepali;

  // Toggle calendar type
  void toggleCalendarType() {
    _currentType = _currentType == CalendarType.nepali 
        ? CalendarType.english 
        : CalendarType.nepali;
    notifyListeners();
  }

  // Select English date
  void selectEnglishDate(DateTime date) {
    _selectedEnglishDate = date;
    _selectedNepaliDate = NepaliDateTime.fromDateTime(date);
    notifyListeners();
  }

  // Select Nepali date
  void selectNepaliDate(NepaliDateTime date) {
    _selectedNepaliDate = date;
    _selectedEnglishDate = date.toDateTime();
    notifyListeners();
  }

  // Navigate to previous month
  void previousMonth() {
    if (isNepali) {
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
    notifyListeners();
  }

  // Navigate to next month
  void nextMonth() {
    if (isNepali) {
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
    notifyListeners();
  }

  // Get days in current Nepali month
  int get daysInNepaliMonth {
    final nepaliDate = _displayedNepaliMonth;
    final lastDayOfMonth = nepaliDate.month == 12 
        ? NepaliDateTime(nepaliDate.year + 1, 1, 1).subtract(const Duration(days: 1))
        : NepaliDateTime(nepaliDate.year, nepaliDate.month + 1, 1).subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

  // Get days in current English month
  int get daysInEnglishMonth {
    return DateTime(
      _displayedEnglishMonth.year,
      _displayedEnglishMonth.month + 1,
      0,
    ).day;
  }

  // Get weekday of first day in Nepali month (0 = Sunday)
  int get firstDayWeekdayNepali {
    final firstDay = NepaliDateTime(_displayedNepaliMonth.year, _displayedNepaliMonth.month, 1);
    // Convert to DateTime to get the correct weekday
    final firstDayDateTime = firstDay.toDateTime();
    return firstDayDateTime.weekday % 7;
  }

  // Get weekday of first day in English month (0 = Sunday)
  int get firstDayWeekdayEnglish {
    return _displayedEnglishMonth.weekday % 7;
  }

  // Get English month name
  String getEnglishMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Format Nepali date
  String formatNepaliDate(NepaliDateTime date) {
    return '${date.day} ${NepaliDateFormat.MMMM().format(date)} ${date.year}';
  }

  // Format English date
  String formatEnglishDate(DateTime date) {
    return '${date.day} ${getEnglishMonthName(date.month)} ${date.year}';
  }
}
