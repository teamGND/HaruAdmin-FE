import 'package:flutter/material.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';

class AddIntro extends StatefulWidget {
  const AddIntro({super.key});

  @override
  State<AddIntro> createState() => _AddIntroState();
}

class _AddIntroState extends State<AddIntro> {
  final IntroDataRepository introRepository = IntroDataRepository();

  Future<AddIntroData?> fetchIntroData(int id) async {
    try {
      introRepository.getIntroData(id: id).then((value) {
        return value;
      });
    } catch (e) {
      print("error : $e");
      throw Exception(e);
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Add Intro'),
    );
  }
}
