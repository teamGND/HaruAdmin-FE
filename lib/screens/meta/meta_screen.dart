import 'package:flutter/material.dart';
import 'package:haru_admin/api/meta_grammar_services.dart';
import 'package:haru_admin/model/meta_data_model.dart';

class MetaGrammarScreen extends StatefulWidget {
  const MetaGrammarScreen({super.key});

  @override
  State<MetaGrammarScreen> createState() => _MetaGrammarScreenState();
}

class _MetaGrammarScreenState extends State<MetaGrammarScreen> {
  static const MAX_META_DATA = 20;
  late Future<void> _metaListDataFuture;
  List<MetaGrammarData> _metaGrammarTitles = [];

  fetchMetaListData() async {
    // 메타문법 데이터를 가져오는 비동기 함수
    try {
      await MetaGrammarDataRepository()
          .getMetaGrammerDataList(page: 0, size: MAX_META_DATA)
          .then((value) {
        setState(() {
          _metaGrammarTitles =
              value.MetaGrammarDataList; // 메타데이터 리스트에서 타이틀만 가져오기
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  getSelectedMetaData() async {
    // 선택된 메타데이터를 가져오는 비동기 함수
  }

  updateSelectedMetaData() async {
    // 선택된 메타데이터를 업데이트하는 비동기 함수
  }

  addNewMetaData() {
    // 새로운 메타데이터를 추가하는 gkatn
  }

  saveNewMetaData() async {
    // 새로운 메타데이터를 저장하는 비동기 함수
  }

  @override
  void initState() {
    super.initState();
    _metaListDataFuture = fetchMetaListData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              '메타문법 데이터',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: _metaListDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (_metaGrammarTitles == []) {
                  return const Text('데이터가 없습니다.');
                } else {
                  return SizedBox(
                    width: 500,
                    height: 500,
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              child: Text('ID'),
                            ),
                            TableCell(
                              child: Text('Title'),
                            ),
                          ],
                        ),
                        for (var meta in _metaGrammarTitles)
                          TableRow(
                            children: [
                              TableCell(
                                child: Text(meta.id.toString()),
                              ),
                              TableCell(
                                child: Text(meta.title.toString()),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
