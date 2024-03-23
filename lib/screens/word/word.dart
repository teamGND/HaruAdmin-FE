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
      Future.delayed(const Duration(milliseconds: 500 ), () {
    return WordDataRepository().getWordDataList();
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultFutureBuilder(
          future: fetchWordDataList,
          titleRow: const ListTile(
            title: Text('단어 목록'),
          ),
          childRow: (dynamic wordData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: wordData.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(wordData.content[index].titleKor),
                        subtitle: Text(wordData.content[index].contentKor),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }
}
