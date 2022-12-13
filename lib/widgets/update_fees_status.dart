import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:student_management_system/models/student.dart';

import '../providers/students.dart';

class UpdateFeesStatus extends StatefulWidget {
  final Student student;
  const UpdateFeesStatus({Key? key, required this.student}) : super(key: key);

  @override
  State<UpdateFeesStatus> createState() => _UpdateFeesStatusState();
}

class _UpdateFeesStatusState extends State<UpdateFeesStatus> {
  DateTime _selectedDate = DateTime.now();
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
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: monthPicker(),
              ),
              yearPicker(),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Select Payment Date",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black54.withOpacity(0.5)),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: Colors.black54.withOpacity(0.2), width: 1)),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      DateFormat('dd MMM yyyy').format(_selectedDate),
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 100)),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        setState(() {
                          if (value != null) {
                            _selectedDate = value;
                          }
                        });
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer<Students>(
            builder: (c, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    month == null && _selectedDate == null
                        ? ScaffoldMessenger.of(c).showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 1),
                              content: Text("Please check your entry"),
                            ),
                          )
                        : model
                            .updateStudentFee(
                                "$_selectedYear/$month",
                                widget.student,
                                (_selectedDate as DateTime).toIso8601String(),
                                month)
                            .then((value) => Navigator.of(c).pop());
                  },
                  child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text("Update Fees")),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container monthPicker() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.black54.withOpacity(0.2), width: 1)),
      margin: const EdgeInsets.all(5),
      child: DropdownButton(
        underline: const SizedBox(),
        menuMaxHeight: 200,
        elevation: 3,
        hint: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Select a Month"),
        ),
        value: month,
        items: monthsList.map((val) {
          return DropdownMenuItem(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(val),
            ),
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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: Colors.black54.withOpacity(0.2), width: 1)),
      child: DropdownButton(
        underline: const SizedBox(),
        menuMaxHeight: 200,
        elevation: 3,
        hint: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Select Year"),
        ),
        value: _selectedYear,
        items: _pastFiveYears.map((val) {
          return DropdownMenuItem(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(val),
            ),
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
