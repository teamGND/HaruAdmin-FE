import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/screens/intro/add_intro.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';
import 'package:just_audio/just_audio.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({super.key});

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final WordDataRepository wordRepository = WordDataRepository();
  late List<TextEditingController> titleControllers;
  late List<TextEditingController> englishControllers;
  late List<TextEditingController> chineseControllers;
  late List<TextEditingController> vietnamControllers;
  late List<TextEditingController> russianControllers;
  late List<TextEditingController> descriptionControllers;

  // 회차 데이터 가져오기
  IntroInfo info = IntroInfo();
  List<WordChapterData> _datas = [];
  final List<bool> _isChecked = List<bool>.filled(10, false);

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

  late Future<void> _wordDataFuture;

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

  void save() async {
    if (_datas.isNotEmpty) {
      bool isWordFilled = _datas.every((element) {
        if (element.title.isEmpty || element.title == '') {
          return false;
        }
        return true;
      });

      if (!isWordFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('단어를 입력해주세요')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }
    }

    try {
      if (info.dataId != null) {
        for (int i = 0; i < _datas.length; i++) {
          _datas[i].order = i + 1;
        }
        for (int i = 0; i < _datas.length; i++) {
          _datas[i].title = titleControllers[i].text;
          _datas[i].english = englishControllers[i].text;
          _datas[i].chinese = chineseControllers[i].text;
          _datas[i].vietnam = vietnamControllers[i].text;
          _datas[i].russian = russianControllers[i].text;
          _datas[i].description = descriptionControllers[i].text;
        }

        await wordRepository
            .saveWordData(
          id: info.dataId!,
          data: PatchWordChapterData(
            level: info.level.toString().split('.').last,
            title: info.title,
            chapter: info.chapter,
            sets: info.sets,
            cycle: info.cycle,
            word: _datas,
          ),
        )
            .then((value) {
          if (value != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(child: Text(value)),
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ),
            );
          }
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void translate() {}

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
            .uploadFile(
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

  void getAudioUrl(int index) async {
    if (_datas[index].title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('음성 업로드 전, 단어를 입력해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await wordRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: _datas[index].title,
        )
            .then((value) {
          setState(() {
            _datas[index].voiceUrl = value;
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  playAudio(int index) async {
    try {
      final player = AudioPlayer();
      await player.setUrl(_datas[index].voiceUrl!);
      await player.setVolume(0.5);
      await player.pause();
      await player.stop();
      player.play();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchWordData() async {
    try {
      if (info.dataId != null) {
        await wordRepository.getWordData(id: info.dataId!).then((value) {
          _datas = value.wordDataList;
        });

        titleControllers = _datas
            .map((data) => TextEditingController(text: data.title))
            .toList();
        englishControllers = _datas
            .map((data) => TextEditingController(text: data.english))
            .toList();
        chineseControllers = _datas
            .map((data) => TextEditingController(text: data.chinese))
            .toList();
        vietnamControllers = _datas
            .map((data) => TextEditingController(text: data.vietnam))
            .toList();
        russianControllers = _datas
            .map((data) => TextEditingController(text: data.russian))
            .toList();
        descriptionControllers = _datas
            .map((data) => TextEditingController(text: data.description))
            .toList();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    info = ref.read(introProvider);
    _wordDataFuture = fetchWordData();
  }

  @override
  void dispose() {
    for (var controller in titleControllers) {
      controller.dispose();
    }
    for (var controller in englishControllers) {
      controller.dispose();
    }
    for (var controller in chineseControllers) {
      controller.dispose();
    }
    for (var controller in vietnamControllers) {
      controller.dispose();
    }
    for (var controller in russianControllers) {
      controller.dispose();
    }
    for (var controller in descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
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
              Center(
                child: ChapterCatalogTable(
                  level: info.level.toString().split('.').last,
                  cycle: info.cycle,
                  sets: info.sets,
                  chapter: info.chapter,
                  title: info.title,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder(
                    future: _wordDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return SizedBox(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
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
                                    // 1. 체크박스
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
                                    // 2. 순서
                                    TableComponent(
                                      width: tabletitle[1].values.first,
                                      child: Text(
                                        _datas[index].order.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 3. 단어
                                    TableComponent(
                                      width: tabletitle[2].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: titleControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 4. 이미지
                                    TableComponent(
                                      width: tabletitle[3].values.first,
                                      child: _datas[index].imgUrl != null
                                          ? Image.network(
                                              _datas[index].imgUrl!,
                                              fit: BoxFit.cover,
                                            )
                                          : TextButton(
                                              onPressed: () {
                                                // 이미지 불러오기
                                                getImageUrl(index);
                                              },
                                              child: const Text(
                                                '불러오기',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                    ),
                                    // 5. 음성
                                    TableComponent(
                                        width: tabletitle[4].values.first,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            _datas[index].voiceUrl != null
                                                ? IconButton(
                                                    onPressed: () {
                                                      playAudio(index);
                                                    },
                                                    icon: const Icon(Icons
                                                        .volume_up_rounded),
                                                  )
                                                : const SizedBox(),
                                            TextButton(
                                              onPressed: () {
                                                // 오디오 불러오기
                                                getAudioUrl(index);
                                              },
                                              child: const Text(
                                                '불러오기',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    // 6. ENG
                                    TableComponent(
                                      width: tabletitle[5].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: englishControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 7. CHN
                                    TableComponent(
                                      width: tabletitle[6].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: chineseControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 8. VIE
                                    TableComponent(
                                      width: tabletitle[7].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: vietnamControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 9. RUS
                                    TableComponent(
                                      width: tabletitle[8].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: russianControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 10. 추가 설명
                                    TableComponent(
                                      width: tabletitle[9].values.first,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller:
                                            descriptionControllers[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = _datas.removeAt(oldIndex);
                                  _datas.insert(newIndex, item);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }),
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
                      onPressed: () {
                        confirm();
                      },
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '번역 불러오기',
                      color: const Color(0xFF484848),
                      onPressed: () {
                        translate();
                      },
                    ),
                    const SizedBox(width: 10),
                    filledButton(
                      buttonName: '저장하기',
                      color: const Color(0xFF3F99F7),
                      onPressed: () {
                        save();
                      },
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
