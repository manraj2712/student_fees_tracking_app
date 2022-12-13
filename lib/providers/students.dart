import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'package:student_management_system/models/exception.dart';
import '../models/student.dart';

class Students with ChangeNotifier {
  late StreamSubscription _studentsStream;
  final _databaseReference = FirebaseDatabase().reference();
  final _studentsPath = "/students";
  final _studentIdPath = "/StudentId";
  List<Student> _studentsList = [];
  List<Student> _feesPaidStudents = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // instantiating fetchStudents method on screen load to use the realtime update functionality

  Students() {
    fetchStudents();
  }

  Future<bool> checkIfStudentExists(String name, String parentsMob) async {
    try {
      DataSnapshot fetchedName = await _databaseReference
          .child(_studentsPath)
          .orderByChild("name")
          .equalTo(name)
          .once();
      DataSnapshot fetchedMob = await _databaseReference
          .child(_studentsPath)
          .orderByChild('parentsMob')
          .equalTo(parentsMob)
          .once();
      if (fetchedMob.exists && fetchedName.exists) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Map studentModelToMap(Student student) {
    return {
      'name': student.name,
      'parentsName': student.parentsName,
      'joinDate': student.joinDate,
      'parentsMob': student.parentsMob,
      'school': student.school,
      'standard': student.standard,
      'address': student.address,
      'altMob': student.alternateMob,
      'studentMob': student.studentsMob,
      'id': student.id,
      'serverId': student.serverId,
      'existingStudent': student.existingStudent,
    };
  }

  Map convertStudentKeysMap(Map<StudentKeys, String> s) {
    var listKeys = s.keys.map((e) => e.toString().substring(12)).toList();
    Map<String, String> newMap = Map.fromIterables(listKeys, s.values.toList());
    return newMap;
  }

  Future<void> pushStudentData(Map studentData) async {
    try {
      var studentExists = await checkIfStudentExists(
        studentData['name'],
        studentData['parentsMob'],
      );
      if (studentExists) {
        throw fireBaseException("Student already exists");
      }
      DataSnapshot snapshot =
          await _databaseReference.child(_studentIdPath).once();
      var idValue = snapshot.value;
      var studentId =
          "ST/${'0' * (5 - idValue.toString().length)}${idValue.toString()}";
      studentData['id'] = studentId;
      await _databaseReference.child(_studentIdPath).set(idValue + 1);
      await _databaseReference.child(_studentsPath).push().set(studentData);
    } catch (e) {
      rethrow;
    }
  }
// fetching the details of students who have paid fees for the selected month

  Future<void> nonExistentPathFetchCheck() async {
    var data = await _databaseReference
        .child("2021/April")
        .orderByChild("id")
        .equalTo("-MkuT0PQameQEuXOZWx7")
        .once();
    print(data.exists);
  }

  Future<List<Map>> fetchLastFiveFeesRecordsOfStudent(String studentId) async {
    List<String> dataExists = [];
    List<Map> dataMaps = [];
    List<String> pathsList = getPaths();
    print(getPaths());
    for (var i in pathsList) {
      var data = await _databaseReference
          .child(i)
          .orderByChild("studentId")
          .equalTo(studentId)
          .once();
      if (data.exists) {
        dataMaps.add(data.value as Map);
        // print(dataMap);
      }
    }
    return dataMaps;
  }
  // fetching the records of students which is updated realtime using streamsubscription

  void fetchStudents() async {
    _studentsList.clear();
    _studentsStream =
        _databaseReference.child(_studentsPath).onValue.listen((event) {
      if (event.snapshot.value != null) {
        var studentsData = event.snapshot.value as Map;
        int index = -1;
        _studentsList = studentsData.values.map((event) {
          index++;
          return Student.fromRTDB(
            event as Map,
            studentsData.keys.elementAt(index),
          );
        }).toList();
        notifyListeners();
      }
    });
  }

  // update students fees payment details

  Future<void> updateStudentFee(
      String path, Student student, String paymentDate, String forMonth) async {
    var data = await _databaseReference
        .child(path)
        .orderByChild('studentId')
        .equalTo(student.id)
        .once();
    if (data.exists) {
      throw fireBaseException(
          "Student has already paid the fees for this month");
    }
    await _databaseReference.child(path).push().set({
      "paymentDate": paymentDate,
      "studentId": student.id,
      "amount": student.fees,
      "forMonth": forMonth,
    });
  }

  Future<List<Student>> fetchFeesUnpaidStudentsByMonth(String path) async {
    int selectedYear = int.parse(path.split('/')[0]);
    int selectedMonth =
        months.indexOf(path.split('/')[1].replaceFirst('/', '')) + 1;
    var studentData = await _databaseReference.child(_studentsPath).once();
    Map studentDataMap = studentData.value as Map;
    var studentsInMonthMap = {};
    var studentsInMonth = await _databaseReference.child(path).get();
    if (studentsInMonth.value != null) {
      studentsInMonthMap = studentsInMonth.value as Map;
    }
    List<String> studentInMonthIds = [];
    List<Student> studentsList = [];
    int i = -1;
    await Future.forEach(studentsInMonthMap.values, (element) {
      studentInMonthIds.add((element as Map)['studentId']);
    });
    await Future.forEach(studentDataMap.values, (element) {
      i++;
      if (studentInMonthIds.contains((element as Map)['id']) ||
          DateTime(selectedYear, selectedMonth)
              .isBefore(DateTime.parse(element['joinDate']))) {
      } else {
        studentsList
            .add(Student.fromRTDB(element, studentDataMap.keys.elementAt(i)));
      }
    });
    return studentsList;
  }

  Future<List<Student>> fetchFeesPaidStudentsByMonth(String path) async {
    List<Student> studentsList = [];
    var data =
        await _databaseReference.child(path).orderByChild('studentId').once();
    if (data.exists) {
      Map dataMap = data.value as Map;
      List<String> studentIds = dataMap.values.map((entry) {
        return entry['studentId'].toString();
      }).toList();
      var studentData = await _databaseReference
          .child(_studentsPath)
          .orderByChild('id')
          .once();
      var studentDataMap = studentData.value as Map;
      int i = -1;
      await Future.forEach(studentDataMap.values, (element) {
        if (element != null) {
          i++;
          if (studentIds.contains((element as Map)['id'])) {
            studentsList.add(
                Student.fromRTDB(element, studentDataMap.keys.elementAt(i)));
          }
        }
      });
    }
    return studentsList;
  }

  // returning list of students

  List<Student> get studentsList {
    return _studentsList;
  }

  // returning list of students who have paid fees for particular month

  List<Student> get feesPaidStudents {
    return _feesPaidStudents;
  }

  @override
  void dispose() {
    _studentsStream.cancel();
    super.dispose();
  }
}

List<String> getPaths() {
  List<String> pathList = [];
  var startMonth;
  var startYear;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 120));
  if (DateUtils.addMonthsToMonthDate(startDate, 4).isAfter(DateTime.now())) {
    startMonth = startDate.month + 1;
  } else {
    startMonth = startDate.month;
  }
  startYear = startDate.year;
  for (var i = 0; i < 5; i++) {
    var formatedDate = DateFormat.yMMMM().format(
        DateUtils.addMonthsToMonthDate(DateTime(startYear, startMonth), i));
    var path =
        "${formatedDate.split(" ")[1].trim()}/${formatedDate.split(" ")[0]}";
    pathList.add(path);
  }
  return pathList;
}
