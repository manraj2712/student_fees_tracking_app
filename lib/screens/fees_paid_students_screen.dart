import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/students.dart';

class FeesPaidStudents extends StatefulWidget {
  const FeesPaidStudents({Key? key}) : super(key: key);

  @override
  State<FeesPaidStudents> createState() => _FeesPaidStudentsState();
}

class _FeesPaidStudentsState extends State<FeesPaidStudents> {
  final monthsList = const [
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final int _currentYear = DateTime.now().year;
  String _selectedYear = DateTime.now().year.toString();
  var month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees Paid Students"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: monthPicker(),
                ),
                yearPicker(),
              ],
            ),
            const Spacer(),
            Consumer<Students>(
              builder: (c, model, child) {
                return ElevatedButton(
                  onPressed: () {
                    month == null
                        ? ScaffoldMessenger.of(c).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1),
                              content: Text("Please select a Month"),
                            ),
                          )
                        : model.fetchFeesPaidStudentsByMonth(
                            "$_selectedYear/$month");
                  },
                  child: const Text("Update Fees"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container monthPicker() {
    return Container(
      margin: const EdgeInsets.all(5),
      child: DropdownButton(
        menuMaxHeight: 200,
        elevation: 3,
        hint: const Text("Select a Month"),
        value: month,
        items: monthsList.map((val) {
          return DropdownMenuItem(
            child: Text(val),
            value: val,
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            month = val.toString();
          });
        },
      ),
    );
  }

  Container yearPicker() {
    List<String> _pastFiveYears = [
      (_currentYear - 4).toString(),
      (_currentYear - 3).toString(),
      (_currentYear - 2).toString(),
      (_currentYear - 1).toString(),
      _currentYear.toString(),
    ];
    return Container(
      margin: const EdgeInsets.all(5),
      child: DropdownButton(
        menuMaxHeight: 200,
        elevation: 3,
        hint: const Text("Select Year"),
        value: _selectedYear,
        items: _pastFiveYears.map((val) {
          return DropdownMenuItem(
            child: Text(val),
            value: val,
          );
        }).toList(),
        onChanged: (val) {
          setState(() {
            _selectedYear = val.toString();
          });
        },
      ),
    );
  }
}
