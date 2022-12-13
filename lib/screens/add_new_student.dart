import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_management_system/models/exception.dart';
import 'package:student_management_system/models/student.dart';
import 'package:student_management_system/providers/students.dart';

class AddNewStudent extends StatefulWidget {
  static const routeName = "/add-student";
  const AddNewStudent({Key? key}) : super(key: key);

  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  var students;
  @override
  void initState() {
    students = Provider.of<Students>(context, listen: false);
    (students as Students).nonExistentPathFetchCheck();
    super.initState();
  }

  bool isLoading = false;

  void saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _formData.putIfAbsent(StudentKeys.existingStudent, () => "true");
      Map newMap = (students as Students).convertStudentKeysMap(_formData);
      print(newMap);
      try {
        setState(() {
          isLoading = true;
        });
        await (students as Students).pushStudentData(newMap);
        _formData.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student added successfully."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on fireBaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong! Please try after sometime."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  var mobileNumberFocusNode = FocusNode();
  Map<StudentKeys, String> _formData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Student's Full Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null ||
                          value.length < 3 ||
                          value.contains(
                            RegExp(r'[0-9]'),
                          )) {
                        return "Please enter a valid name";
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.name, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Parent's Name"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null ||
                          value.length < 3 ||
                          value.contains(
                            RegExp(r'[0-9]'),
                          )) {
                        return "Please enter a valid name";
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.parentsName, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("School"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null ||
                          value.length < 3 ||
                          value.contains(
                            RegExp(r'[0-9]'),
                          )) {
                        return "Please enter a valid school name";
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.school, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Class"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null ||
                          int.parse(value) < 1 ||
                          int.parse(value) > 12) {
                        return "Please enter a valid class";
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.standard, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Fees in ₹"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          int.tryParse(value) == null ||
                          int.parse(value) > 100000) {
                        return "Please enter a valid amount";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.fees, () => value.toString());
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: FormField(
                    validator: (value) {
                      if (_selectedDate == null) {
                        return "Please select a joining date";
                      }
                    },
                    builder: (ctx) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: _selectedDate == null
                                  ? const Text(
                                      "Select Joining Date",
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  : Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(_selectedDate as DateTime),
                                    ),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime.now(),
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      _selectedDate = value;
                                      mobileNumberFocusNode.requestFocus();
                                    }
                                  });
                                });
                              },
                            ),
                          ),
                          if (ctx.hasError)
                            const Text(
                              "Please select a date",
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.left,
                            ),
                        ],
                      );
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(StudentKeys.joinDate,
                          () => (_selectedDate as DateTime).toIso8601String());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    focusNode: mobileNumberFocusNode,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      label: Text("Parent's Mobile Number"),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null ||
                          value.length < 10 ||
                          value.contains(RegExp(r'[A-z][a-z]')) ||
                          value.startsWith(RegExp(r'[1-5]'))) {
                        return "Please enter a valid mobile number";
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.parentsMob, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                      label: Text("Student's Mobile Number"),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 10 ||
                            value.length > 10 ||
                            value.contains(RegExp(r'[A-z][a-z]')) ||
                            value.startsWith(RegExp(r'[1-5]'))) {
                          return "Please enter a valid mobile number";
                        }
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.studentMob, () => value.toString());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      label: Text("Address"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 10) {
                          return "Please enter a valid address";
                        }
                      }
                    },
                    onSaved: (value) {
                      _formData.putIfAbsent(
                          StudentKeys.address, () => value.toString());
                    },
                  ),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: saveForm,
                        child: const Text("Add Student"),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(15),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
