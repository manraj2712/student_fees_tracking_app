import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_management_system/models/fees_details.dart';
import 'package:student_management_system/screens/fees_paid_students_screen.dart';
import 'package:student_management_system/screens/students_list_view.dart';
import 'package:student_management_system/widgets/update_fees_status.dart';

import '../providers/students.dart';

import 'package:student_management_system/models/student.dart';

class StudentDescription extends StatefulWidget {
  static const routeName = "/student-description";
  final Student student;
  const StudentDescription({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDescription> createState() => _StudentDescriptionState();
}

class _StudentDescriptionState extends State<StudentDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(widget.student.name),
      ),
      body: Consumer<Students>(
        builder: (ctx, model, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //----------------------- Student Details -----------------------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 4),
                              shape: BoxShape.circle),
                          height: 80,
                          child: const ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: Image(
                              image: AssetImage('assets/images/add_image.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            widget.student.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Text(
                          "Student id: ${widget.student.id}",
                        ),
                        Text(
                          "Joining Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.student.joinDate))}",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Fees: ₹${widget.student.fees}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),

                //----------------------- Contact Details -----------------------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Contact",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  makePhoneCall(
                                      int.parse(widget.student.parentsMob));
                                },
                                child: contactItem(
                                  title: "Parent's Mobile Number",
                                  icon: const Icon(Icons.phone),
                                  data: widget.student.parentsMob,
                                ),
                              ),
                              if (widget.student.alternateMob.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall(
                                        int.parse(widget.student.alternateMob));
                                  },
                                  child: contactItem(
                                    title: "Alternate Mobile Number",
                                    icon: const Icon(Icons.phone),
                                    data: widget.student.alternateMob,
                                  ),
                                ),
                              if (widget.student.studentsMob.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    makePhoneCall(
                                        int.parse(widget.student.studentsMob));
                                  },
                                  child: contactItem(
                                    title: "Student's Mobile Number",
                                    icon: const Icon(Icons.phone),
                                    data: widget.student.studentsMob,
                                  ),
                                ),
                              if (widget.student.address.isNotEmpty)
                                contactItem(
                                  title: "Address",
                                  icon: const Icon(Icons.home),
                                  data: widget.student.address,
                                ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                //----------------------- Recent Fees Details -----------------------
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Recent Fees Transactions",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                                future: model.fetchLastFiveFeesRecordsOfStudent(
                                    widget.student.id),
                                builder: (ctx, dataSnapshot) {
                                  if (dataSnapshot.connectionState !=
                                      ConnectionState.done) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if ((dataSnapshot.data as List).isNotEmpty) {
                                    return ListView.builder(
                                        itemCount:
                                            (dataSnapshot.data as List).length,
                                        itemBuilder: (c, idx) {
                                          var dataMap =
                                              (dataSnapshot.data as List)
                                                  .elementAt(idx);

                                          Map dataValueMap =
                                              dataMap.values.first as Map;
                                          FeesDetails feesTransaction =
                                              FeesDetails.fromRTDB(dataValueMap,
                                                  dataMap.keys.first);
                                          return Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 8,
                                                ),
                                                title: Text(
                                                  "For Month : ${feesTransaction.forMonth}",
                                                  softWrap: true,
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Amount: ₹${feesTransaction.amount}",
                                                      softWrap: true,
                                                    ),
                                                    Text(
                                                      "Paid on Date: ${DateFormat("dd MMM yyyy").format(DateTime.parse(feesTransaction.paymentDate))}",
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                height: 2,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  return const Center(
                                    child: Text("No Records Found"),
                                  );
                                }),
                          ),
                        ),
                        Card(
                          child: ElevatedButton(
                            child: const Text("Update Fees Details"),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15),
                              ),
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Scaffold(
                                    body: UpdateFeesStatus(
                                      student: widget.student,
                                    ),
                                  );
                                },
                              ).then((value) {
                                setState(() {});
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  ListTile contactItem(
      {required String title, required Icon icon, required String data}) {
    return ListTile(
      leading: icon,
      title: Text(title),
      subtitle: Text(data),
    );
  }
}
