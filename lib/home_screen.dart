import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_info/add_new_student.dart';
import 'package:student_info/student_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentModel> studentList = [];
  final String _collectionName = 'students';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Student Information',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: _moveToAddStudent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        child: Icon(Icons.person_add_alt_1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(_collectionName)
            .snapshots(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            return Center(child: Text(asyncSnapshot.error.toString()));
          }
          if (asyncSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No student available...!'));
          }

          if (asyncSnapshot.hasData) {
            studentList.clear();
            for (QueryDocumentSnapshot snapshot in asyncSnapshot.data!.docs) {
              studentList.add(
                StudentModel.formJson(snapshot.data() as Map<String, dynamic>),
              );
            }
          }

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              final student = studentList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: ListTile(
                  tileColor: Colors.teal.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.teal.shade400,
                  ),
                  title: Text(
                    student.name,
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal.shade900),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Roll: ${student.rollNumber}'),
                      Text('Course : ${student.course}'),
                    ],
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }

  void _moveToAddStudent(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewStudent(),),);
  }
}
