enum StudentKeys {
  name,
  parentsName,
  joinDate,
  parentsMob,
  school,
  standard,
  address,
  altMob,
  studentMob,
  id,
  serverId,
  existingStudent,
  fees,
}

class Student {
  String id,
      name,
      joinDate,
      parentsName,
      parentsMob,
      alternateMob,
      studentsMob,
      school,
      address,
      standard,
      serverId,
      existingStudent,
      fees;

  Student({
    required this.existingStudent,
    required this.name,
    required this.parentsName,
    required this.joinDate,
    required this.parentsMob,
    this.alternateMob = "",
    this.studentsMob = "",
    required this.school,
    required this.standard,
    this.address = "",
    required this.id,
    required this.serverId,
    required this.fees,
  });
  factory Student.fromRTDB(Map data, String serverId) {
    return Student(
        name: data['name'] ?? "",
        parentsName: data['parentsName'] ?? "",
        joinDate: data['joinDate'] ?? "",
        parentsMob: data['parentsMob'] ?? "",
        school: data['school'] ?? "",
        standard: data['standard'] ?? "",
        address: data['address'] ?? "",
        alternateMob: data['altMob'] ?? "",
        studentsMob: data['studentMob'] ?? "",
        serverId: serverId,
        id: data['id'] ?? "id",
        existingStudent: data['existingStudent'] ?? "true",
        fees: data['fees']);
  }
}
