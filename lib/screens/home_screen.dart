import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management_system/providers/students.dart';
import 'package:student_management_system/screens/add_new_student.dart';
import 'package:student_management_system/screens/paid_fees_screen.dart';
import 'students_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    var studentsProvider = Provider.of<Students>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Student's List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paid),
            label: "Fees Paid",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.paid_outlined), label: "Fees Not Paid"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: "Add a Student"),
        ],
        onTap: (val) {
          setState(() {
            selectedItem = val;
          });
        },
        currentIndex: selectedItem,
        unselectedItemColor: Colors.white,
      ),
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         Navigator.of(context)
      //             .push(
      //               MaterialPageRoute(
      //                 builder: (_) => const AddNewStudent(),
      //               ),
      //             )
      //             .then((value) => value == true
      //                 ? ScaffoldMessenger.of(context)
      //                     .showSnackBar(const SnackBar(
      //                     content: Text("Student added successfully!"),
      //                     behavior: SnackBarBehavior.floating,
      //                   ))
      //                 : null);
      //       },
      //       icon: const Icon(Icons.add),
      //     ),
      //   ],
      // ),
      body: selectedItem == 0
      
          ? StudentsListView(studentsList: studentsProvider.studentsList)
          : selectedItem == 1
              ? const FeesPaidUnpaidByMonthScreen(toLoad: loadScreen.paidScreen)
              : selectedItem == 2
                  ? const FeesPaidUnpaidByMonthScreen(
                      toLoad: loadScreen.unpaidScreen)
                  : const AddNewStudent(),
    );
  }
}
