import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/api/grammer_data_services.dart';
import 'package:haru_admin/utils/enum_type.dart';

class GrammerData extends StatefulWidget {
  const GrammerData({super.key});

  @override
  State<GrammerData> createState() => _GrammerDataState();
}

class _GrammerDataState extends State<GrammerData> {
  final int _pageSize = 8;
  int _currentPage = 0;
  bool _isLoading = true;
  var grammarData;
  LEVEL dropdownValue = LEVEL.ALPHABET;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // await GrammerDataRepository()
      //     .getGrammerDataList().then()

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void goToPage(int page) {
    if (page < 0 || page >= grammarData.totalPages) {
      return;
    } else {
      setState(() {
        _currentPage = page;
      });
    }
    fetchData();
  }

  void addChapter(int? id) {
    context.go('/word/add');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          const Text(
            '문법 학습 데이터',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '레벨',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              DropdownMenu<String>(
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Colors.white,
                  focusColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
                width: 300,
                initialSelection: LEVEL.ALPHABET.toString(),
                onSelected: (value) {
                  setState(() {
                    dropdownValue = value as LEVEL;
                  });
                },
                dropdownMenuEntries: LEVEL.values.map((value) {
                  return DropdownMenuEntry<String>(
                    value: value.toString(),
                    label: value.toString().split('.')[1],
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Table(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _currentPage != 0
                        ? GestureDetector(
                            onTap: () {
                              goToPage(_currentPage - 1);
                            },
                            child:
                                const SizedBox(width: 50, child: Text('< 이전')))
                        : const SizedBox(width: 50),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                      child: Text(
                        (_currentPage + 1).toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _currentPage != grammarData.totalPages
                        ? GestureDetector(
                            onTap: () {
                              goToPage(_currentPage + 1);
                            },
                            child:
                                SizedBox(width: 50, child: const Text('다음 >')),
                          )
                        : SizedBox(width: 50),
                    GestureDetector(
                      onTap: () {
                        goToPage(grammarData.totalPages - 1);
                      },
                      child: const Text('맨뒤로 >>'),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  addChapter(null);
                },
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                child: const Text('회차추가'),
              )
            ],
          ),
        ]),
      ),
    ));
  }
}
