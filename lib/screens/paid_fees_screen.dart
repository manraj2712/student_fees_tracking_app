import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management_system/models/student.dart';
import 'package:student_management_system/screens/students_list_view.dart';
import '../providers/students.dart';

enum loadScreen {
  paidScreen,
  unpaidScreen,
}

class FeesPaidUnpaidByMonthScreen extends StatefulWidget {
  final loadScreen toLoad;
  const FeesPaidUnpaidByMonthScreen({Key? key, required this.toLoad})
      : super(key: key);

  @override
  _FeesPaidUnpaidByMonthScreenState createState() =>
      _FeesPaidUnpaidByMonthScreenState();
}

class _FeesPaidUnpaidByMonthScreenState
    extends State<FeesPaidUnpaidByMonthScreen> {
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
  String? month;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.toLoad == loadScreen.paidScreen
            ? const Text("Fees Paid Students")
            : const Text("Unpaid Fees Students"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: monthPicker(),
              ),
              Expanded(
                child: yearPicker(),
              ),
            ],
          ),
          if (month != null)
            FutureBuilder(
                future: widget.toLoad == loadScreen.paidScreen
                    ? Provider.of<Students>(context)
                        .fetchFeesPaidStudentsByMonth(
                            '$_selectedYear/${month as String}')
                    : Provider.of<Students>(context)
                        .fetchFeesUnpaidStudentsByMonth(
                            '$_selectedYear/${month as String}'),
                builder: (c, dataSnapshot) {
                  if (dataSnapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (dataSnapshot.data == null) {
                    return const Text("No Data Available");
                  }
                  return Expanded(
                    child: StudentsListView(
                        studentsList: dataSnapshot.data as List<Student>),
                  );
                })
        ],
      ),
    );
  }

  Container monthPicker() {
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
            Provider.of<Students>(context, listen: false)
                .fetchFeesPaidStudentsByMonth(
                    "$_selectedYear/${month as String}");
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
        hint: const Text("Select Year"),
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
