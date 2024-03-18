import 'package:flutter/material.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/utils/future_layout.dart';

class Word extends StatefulWidget {
  const Word({super.key});

  @override
  State<Word> createState() => _WordState();
}

class _WordState extends State<Word> {
  Future<dynamic> fetchWordDataList =
      Future.delayed(const Duration(seconds: 1), () {
    return WordDataRepository().getWordDataList();
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: DefaultFutureBuilder(
            future: fetchWordDataList,
            titleRow: const ListTile(
              title: Text('단어 목록'),
            ),
            childRow: (dynamic wordData) {
              return Row(children: [
                Text(wordData.title),
                Text(wordData.level),
                Text(wordData.wordCount.toString()),
              ]);
            }),
      ),
    );
  }
}
