import 'package:flutter/material.dart';
import 'package:nepali_english_calendar/nepali_english_calendar.dart';
import 'package:nepali_utils/nepali_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nepali English Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _selectedEnglishDate;
  NepaliDateTime? _selectedNepaliDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali English Calendar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NepaliEnglishCalendar(
                primaryColor: Colors.teal,
                onDateSelected: (date) {
                  setState(() {
                    _selectedEnglishDate = date;
                  });
                },
                onNepaliDateSelected: (date) {
                  setState(() {
                    _selectedNepaliDate = date;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (_selectedEnglishDate != null && _selectedNepaliDate != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Selected Date:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'English (AD): ${_formatEnglishDate(_selectedEnglishDate!)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nepali (BS): ${_formatNepaliDate(_selectedNepaliDate!)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEnglishDate(DateTime date) {
    return '${date.day} ${_getEnglishMonth(date.month)} ${date.year}';
  }

  String _formatNepaliDate(NepaliDateTime date) {
    return '${date.day} ${NepaliDateFormat.MMMM().format(date)} ${date.year}';
  }

  String _getEnglishMonth(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
