import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record/db/model/data.dart';

class AddStudentData extends ChangeNotifier {
  List<StudentData> _students = [];
  List<StudentData> get students => _students;
  Future<void> addToHive(StudentData student) async {
    final box = Hive.box<StudentData>('studentBox');
    final id = await box.add(student);
    student.id = id;
    await box.put(id, student);
    _students.add(student);
    notifyListeners();
  }

  Future<void> getAllStudent() async {
    final box = Hive.box<StudentData>('studentBox');
    _students = box.values.toList();
    notifyListeners();
  }

  Future<void> deletData(int id) async {
    final box = await Hive.openBox<StudentData>('studentBox');
    box.delete(id);
    getAllStudent();
    notifyListeners();
  }

  Future<void> updateData(StudentData student) async {
    final box = await Hive.openBox<StudentData>('studentBox');
    await box.put(student.id, student);
    int index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
      notifyListeners();
    }
  }
}
