import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_info/student_model.dart';

class AddNewStudent extends StatefulWidget {
  const AddNewStudent({super.key});

  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _rollNumberTEController = TextEditingController();
  final TextEditingController _courseTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String _collectionName = 'students';

  bool _inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Add New Student',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: InputDecoration(
                  hintText: 'Student name',
                  border: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  focusedBorder: _buildOutlineInputBorder().copyWith(
                    borderSide: BorderSide(width: 2, color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rollNumberTEController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: 'Roll number',
                  border: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  focusedBorder: _buildOutlineInputBorder().copyWith(
                    borderSide: BorderSide(width: 2, color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter student roll number';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Only numbers are allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _courseTEController,
                decoration: InputDecoration(
                  hintText: 'Course name',
                  border: _buildOutlineInputBorder(),
                  enabledBorder: _buildOutlineInputBorder(),
                  focusedBorder: _buildOutlineInputBorder().copyWith(
                    borderSide: BorderSide(width: 2, color: Colors.teal),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter student course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: !_inProgress,
                replacement: const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                ),
                child: ElevatedButton(
                  onPressed: onTapAddStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  child: Text('Add Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.teal),
    );
  }

  Future<void> onTapAddStudent() async {
    _inProgress = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      try {
        StudentModel _student = StudentModel(
          name: _nameTEController.text.trim(),
          rollNumber: int.parse(_rollNumberTEController.text.trim()),
          course: _courseTEController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection(_collectionName)
            .add(_student.toJson());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New Student has been added....!')),
          );
        }
        _clearText();
      } on FirebaseException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      } finally {
        _inProgress = false;
        setState(() {});
      }
    }
  }



  void _clearText(){
    _nameTEController.clear();
    _rollNumberTEController.clear();
    _courseTEController.clear();
  }

  @override
  void dispose(){
    _nameTEController.dispose();
    _rollNumberTEController.dispose();
    _courseTEController.dispose();
    super.dispose();
  }
}
