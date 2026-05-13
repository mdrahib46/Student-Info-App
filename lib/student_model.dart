class StudentModel {
  final String name, course;
  final int rollNumber;

  StudentModel({
    required this.name,
    required this.rollNumber,
    required this.course,
  });

  factory StudentModel.formJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'],
      rollNumber: json['rollNumber'],
      course: json['course'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"course": course, "name": name, "rollNumber": rollNumber};
  }
}
