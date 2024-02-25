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

  final AddIntroData sampleData = AddIntroData(
    level: 'ALPHABET',
    category: 'WORD',
    chapter: 1,
    cycle: 1,
    state: 'NOTCOMPLETED',
    titleKor: '안녕하세요',
    contentKor: '안녕하세요',
    titleEng: 'Hello',
    contentEng: 'Hello',
    titleVie: 'Hello',
    contentVie: 'Hello',
    titleChn: 'Hello',
    contentChn: 'Hello',
    titleRus: 'Hello',
    contentRus: 'Hello',
  );

  @override
  void initState() {
    super.initState();
    introRepository
        .addToIntroDataList(
      sampleData,
    )
        .then((value) {
      setState(() {
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
