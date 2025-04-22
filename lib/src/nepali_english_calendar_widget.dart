import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';

import 'providers/calendar_provider.dart';
import 'widgets/calendar_header.dart';
import 'widgets/calendar_body.dart';

class NepaliEnglishCalendar extends StatelessWidget {
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
    this.primaryColor = Colors.teal,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.initialCalendarType = CalendarType.nepali,
    this.onDateSelected,
    this.onNepaliDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarProvider(
        initialCalendarType: initialCalendarType,
      ),
      child: _CalendarContent(
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
        textColor: textColor,
        onDateSelected: onDateSelected,
        onNepaliDateSelected: onNepaliDateSelected,
      ),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundColor;
  final Color textColor;
  final Function(DateTime)? onDateSelected;
  final Function(NepaliDateTime)? onNepaliDateSelected;

  const _CalendarContent({
    Key? key,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.onDateSelected,
    this.onNepaliDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, provider, _) {
        // Set up callbacks
        if (onDateSelected != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onDateSelected!(provider.selectedEnglishDate);
          });
        }
        
        if (onNepaliDateSelected != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onNepaliDateSelected!(provider.selectedNepaliDate);
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
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
                primaryColor: primaryColor,
                textColor: textColor,
              ),
              CalendarBody(
                primaryColor: primaryColor,
                textColor: textColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
