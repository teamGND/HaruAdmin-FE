import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({
    super.key,
  });

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final WordDataRepository wordRepository = WordDataRepository();

  // 회차 데이터 가져오기
  bool _isLoading = false;
  late IntroInfo info;
  List<WordChapterData> _datas = [];
  List<bool> _isChecked = List<bool>.filled(10, false);

  List<Map<String, double>> tabletitle = [
    {'': 50},
    {'순서': 50},
    {'단어': 150},
    {'이미지': 200},
    {'음성': 100},
    {'ENG': 100},
    {'CHN': 100},
    {'VIE': 100},
    {'RUS': 100},
    {'추가 설명': 100},
  ];

  void addNewWord() {
    if (_datas.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('단어는 최대 10개까지 추가 가능합니다.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }
    setState(() {
      _datas.add(
        WordChapterData(
          order: _datas.length + 1,
          title: '',
        ),
      );
    });
  }

  void deleteSelectedWord() {
    setState(() {
      _datas = _datas
          .where((element) => !_isChecked[_datas.indexOf(element)])
          .toList();
    });
  }

  void translate() {}
  void save() {}
  void confirm() {}
  void getImageUrl(int index) async {
    if (_datas[index].title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('이미지 업로드 전, 단어를 입력해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await wordRepository
            .uploadImage(
          fileBytes: file.bytes!,
          fileName: _datas[index].title,
        )
            .then((value) {
          setState(() {
            _datas[index].imgUrl = value;
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchWordData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (info.dataId != null) {
        await wordRepository.getWordData(id: info.dataId!).then((value) {
          _datas = value.wordDataList;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    info = ref.read(introProvider);
    fetchWordData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '단어 데이터 조회/수정',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ChapterCatalogTable(
                      level: info.level.toString().split('.').last,
                      cycle: info.cycle,
                      chapter: info.chapter,
                      title: info.title,
                    ),
              const SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ReorderableListView(
                      scrollDirection: Axis.vertical,
                      header: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          tabletitle.length,
                          (index) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              color: Colors.grey[200],
                            ),
                            width: tabletitle[index].values.first,
                            height: 40,
                            child: Center(
                              child: Text(
                                tabletitle[index].keys.first,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      children: List.generate(
                        _datas.length,
                        (index) => Row(
                          key: ValueKey(index),
                          children: [
                            TableComponent(
                              width: tabletitle[0].values.first,
                              child: Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked[index] = value!;
                                  });
                                },
                                value: _isChecked[index],
                              ),
                            ),
                            TableTextComponent(
                              tabletitle: (index + 1).toString(),
                              width: tabletitle[1].values.first,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].title,
                              width: tabletitle[2].values.first,
                            ),
                            TableComponent(
                              width: tabletitle[3].values.first,
                              child: Image.network(
                                'https://haru-hangeul.s3.ap-northeast-2.amazonaws.com/hello.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // TableComponent(
                            //   width: tabletitle[3].values.first,
                            //   child: _datas[index].imgUrl != null
                            //       ? Image.network(
                            //           '_datas[index].imgUrl!',
                            //           fit: BoxFit.cover,
                            //         )
                            //       : TextButton(
                            //           onPressed: () {
                            //             // 이미지 불러오기
                            //             getImageUrl(index);
                            //           },
                            //           child: const Text(
                            //             '불러오기',
                            //             style: const TextStyle(
                            //               color: Colors.blue,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 10,
                            //             ),
                            //           ),
                            //         ),
                            // ),
                            TableTextComponent(
                              tabletitle: _datas[index].voiceUrl ?? '소리없음',
                              width: tabletitle[4].values.first,
                              isEditable: false,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].english ?? '',
                              width: tabletitle[5].values.first,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].chinese ?? '',
                              width: tabletitle[6].values.first,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].vietnam ?? '',
                              width: tabletitle[7].values.first,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].russian ?? '',
                              width: tabletitle[8].values.first,
                            ),
                            TableTextComponent(
                              tabletitle: _datas[index].description ?? '',
                              width: tabletitle[9].values.first,
                            ),
                          ],
                        ),
                      ),
                      onReorder: (int oldIndex, int newIndex) {
                        // setState(() {
                        //   if (oldIndex < newIndex) {
                        //     newIndex -= 1;
                        //   }
                        //   final testDataEntityProvider =
                        //       context.read<TestDataEntityProvider>();
                        //   final testDataList =
                        //       testDataEntityProvider.testDataList;

                        //   // Remove the item from the list at the old index
                        //   final item = testDataList.removeAt(oldIndex);
                        //   // Insert the item into the list at the new index
                        //   testDataList.insert(newIndex, item);
                        // });
                      },
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Row(
                  children: [
                    filledButton(
                      buttonName: '단어 추가',
                      color: const Color(0xFF3F99F7),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '단어 빼기',
                      color: const Color(0xFFFFCC4A),
                      onPressed: () {
                        deleteSelectedWord();
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    filledButton(
                      buttonName: 'Confirm',
                      color: const Color(0xFFFF7D53),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '번역 불러오기',
                      color: const Color(0xFF484848),
                      onPressed: addNewWord,
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '저장하기',
                      color: const Color(0xFF3F99F7),
                      onPressed: addNewWord,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TableTextComponent extends StatelessWidget {
  const TableTextComponent({
    super.key,
    required this.tabletitle,
    required this.width,
    this.isEditable = true,
  });

  final String tabletitle;
  final double width;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Colors.white,
      ),
      width: width,
      height: 100,
      child: Center(
          child: isEditable
              ? TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: TextEditingController(
                    text: tabletitle ?? '',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                )
              : Text(
                  tabletitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                )),
    );
  }
}

class TableComponent extends StatelessWidget {
  const TableComponent({
    super.key,
    required this.child,
    required this.width,
  });

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Colors.white,
      ),
      width: width,
      height: 100,
      child: Center(child: child),
    );
  }
}
