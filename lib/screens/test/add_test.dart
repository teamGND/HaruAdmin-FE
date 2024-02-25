import 'package:flutter/material.dart';
import 'package:haru_admin/api/test_data_services.dart';
import 'package:haru_admin/model/test_data_model.dart';

class AddTest extends StatefulWidget {
  const AddTest({super.key});

  @override
  State<AddTest> createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  final TestDataRepository testRepository = TestDataRepository();

  // final AddTestData sampleData = AddTestData(
  //   level: 'ALPHABET',
  //   category: 'WORD',
  //   chapter: 1,
  //   cycle: 1,
  //   state: 'NOTCOMPLETED',
  //   titleKor: '안녕하세요',
  //   contentKor: '안녕하세요',
  //   titleEng: 'Hello',
  //   contentEng: 'Hello',
  //   titleVie: 'Hello',
  //   contentVie: 'Hello',
  //   titleChn: 'Hello',
  //   contentChn: 'Hello',
  //   titleRus: 'Hello',
  //   contentRus: 'Hello',
  // );

  @override
  void initState() {
    super.initState();
    // testRepository
    //     .addToIntroDataList(
    //   sampleData,
    // )
    //     .then((value) {
    //   setState(() {
    //     print(value);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
