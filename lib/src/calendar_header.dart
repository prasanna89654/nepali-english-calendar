import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class CalendarHeader extends StatelessWidget {
  final bool isNepali;
  final VoidCallback onToggle;
  final Color primaryColor;
  final Color textColor;
  final NepaliDateTime nepaliDate;
  final DateTime englishDate;

  const CalendarHeader({
    Key? key,
    required this.isNepali,
    required this.onToggle,
    required this.primaryColor,
    required this.textColor,
    required this.nepaliDate,
    required this.englishDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                isNepali ? 'नेपाली पात्रो (BS)' : 'English Calendar (AD)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Switch(
                value: isNepali,
                onChanged: (_) => onToggle(),
                activeColor: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isNepali 
                ? _formatNepaliDate(nepaliDate)
                : _formatEnglishDate(englishDate),
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

  String _formatNepaliDate(NepaliDateTime date) {
    return '${date.day} ${NepaliDateFormat.MMMM().format(date)} ${date.year}';
  }

  String _formatEnglishDate(DateTime date) {
    return '${date.day} ${_getEnglishMonth(date.month)} ${date.year}';
  }

  String _getEnglishMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
