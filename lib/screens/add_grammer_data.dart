import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/data_search_area.dart';

const List<String> levelType = <String>['자음모음', '1급', '2급', '3급', '4급'];

class ModifyGrammer extends StatefulWidget {
  const ModifyGrammer({super.key});

  @override
  State<ModifyGrammer> createState() => _ModifyGrammerState();
}

class _ModifyGrammerState extends State<ModifyGrammer> {
  String selectedlevel = levelType.first;

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
                '문법 회차 데이터 조회/수정',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RequiredInfoName('레벨'),
                    DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width * 0.2,
                      hintText: '레벨을 선택해주세요',
                      onSelected: (String? value) {
                        if (value != null) {
                          setState(() {
                            selectedlevel = value;
                          });
                        }
                      },
                      dropdownMenuEntries: levelType
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                        );
                      }).toList(),
                    ),
                    InfoName('사이클'),
                    const textformfield(),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RequiredInfoName(
                        '타이틀',
                      ),
                      const textformfield(),
                      InfoName('회차'),
                      const textformfield(),
                    ],
                  )),
              const SizedBox(height: 20.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Row(
                  children: [
                    Text(
                      '• 대표문장',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '하이라이트 되는 부분은 [ ] 사이에 넣어주세요',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              //DataTable(columns: DataColumn, rows: rows)
            ],
          ),
        ),
      ),
    );
  }
}
