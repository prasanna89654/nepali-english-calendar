import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'calendar_header.dart';
import 'calendar_body.dart';
import 'models/calendar_type.dart';

class NepaliEnglishCalendar extends StatefulWidget {
  /// Primary color used for highlighting selected dates and buttons
  final Color primaryColor;
  
  /// Background color of the calendar
  final Color backgroundColor;
  
  /// Text color for dates
  final Color textColor;
  
  /// Initial calendar type to display (Nepali or English)
  final CalendarType initialCalendarType;
  
  /// Callback when a date is selected
  final Function(DateTime)? onDateSelected;
  
  /// Callback when a Nepali date is selected
  final Function(NepaliDateTime)? onNepaliDateSelected;

  const NepaliEnglishCalendar({
    Key? key,
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.initialCalendarType = CalendarType.nepali,
    this.onDateSelected,
    this.onNepaliDateSelected,
  }) : super(key: key);

  @override
  State<NepaliEnglishCalendar> createState() => _NepaliEnglishCalendarState();
}

class _NepaliEnglishCalendarState extends State<NepaliEnglishCalendar> {
  late CalendarType _currentType;
  late DateTime _selectedEnglishDate;
  late NepaliDateTime _selectedNepaliDate;

  @override
  void initState() {
    super.initState();
    _currentType = widget.initialCalendarType;
    _selectedEnglishDate = DateTime.now();
    _selectedNepaliDate = NepaliDateTime.now();
  }

  void _toggleCalendarType() {
    setState(() {
      _currentType = _currentType == CalendarType.nepali 
          ? CalendarType.english 
          : CalendarType.nepali;
    });
  }

  void _onEnglishDateSelected(DateTime date) {
    setState(() {
      _selectedEnglishDate = date;
      _selectedNepaliDate = NepaliDateTime.fromDateTime(date);
    });
    
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(date);
    }
  }

  void _onNepaliDateSelected(NepaliDateTime date) {
    setState(() {
      _selectedNepaliDate = date;
      _selectedEnglishDate = date.toDateTime();
    });
    
    if (widget.onNepaliDateSelected != null) {
      widget.onNepaliDateSelected!(date);
    }
    
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(date.toDateTime());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CalendarHeader(
            isNepali: _currentType == CalendarType.nepali,
            onToggle: _toggleCalendarType,
            primaryColor: widget.primaryColor,
            textColor: widget.textColor,
            nepaliDate: _selectedNepaliDate,
            englishDate: _selectedEnglishDate,
          ),
          CalendarBody(
            isNepali: _currentType == CalendarType.nepali,
            primaryColor: widget.primaryColor,
            textColor: widget.textColor,
            selectedNepaliDate: _selectedNepaliDate,
            selectedEnglishDate: _selectedEnglishDate,
            onNepaliDateSelected: _onNepaliDateSelected,
            onEnglishDateSelected: _onEnglishDateSelected,
          ),
        ],
      ),
    );
  }
}
