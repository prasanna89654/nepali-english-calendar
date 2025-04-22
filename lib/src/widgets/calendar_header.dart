import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calendar_provider.dart';

class CalendarHeader extends StatelessWidget {
  final Color primaryColor;
  final Color textColor;

  const CalendarHeader({
    Key? key,
    required this.primaryColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    
    final title = provider.isNepali 
        ? 'नेपाली पात्रो (BS)' 
        : 'English Calendar (AD)';
    
    final formattedDate = provider.isNepali
        ? provider.formatNepaliDate(provider.selectedNepaliDate)
        : provider.formatEnglishDate(provider.selectedEnglishDate);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Switch(
                value: provider.isNepali,
                onChanged: (_) => provider.toggleCalendarType(),
                activeColor: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
