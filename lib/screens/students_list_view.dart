import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'student_description.dart';
import 'package:student_management_system/models/student.dart';

class StudentsListView extends StatelessWidget {
  final List<Student> studentsList;
  const StudentsListView({
    required this.studentsList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (studentsList.isEmpty) {
      return const Center(
        child: Text("No Student to Show"),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
      ),
      body: ListView.builder(
          itemBuilder: (ctx, idx) {
            List<InkWell> studentsCards = studentsList
                .map((student) => InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return StudentDescription(student: student);
                        }),
                      ),
                      child: Card(
                        borderOnForeground: true,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/no_profile_photo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              radius: 25.0,
                            ),
                            title: Text(student.name),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                descriptionText("Student ID: ${student.id}"),
                                descriptionText(
                                    "Class: ${student.standard}  School: ${student.school}"),
                                descriptionText(
                                    "Parent's Name: ${student.parentsName}"),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                makePhoneCall(int.parse(student.parentsMob));
                              },
                              icon: const Icon(
                                Icons.phone,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList();
            return studentsCards.elementAt(idx);
          },
          itemCount: studentsList.length),
    );
  }

  Padding descriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Text(
        text,
        softWrap: true,
      ),
    );
  }
}

makePhoneCall(int phoneNumber) async {
  final url = Uri(scheme: "tel", path: "+91-$phoneNumber");
  await launchUrl(url);
}
