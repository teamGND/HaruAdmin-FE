import 'package:flutter/material.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  @override
  Widget build(BuildContext context) {
    return Text("data id : ${widget.id}");
  }
}
