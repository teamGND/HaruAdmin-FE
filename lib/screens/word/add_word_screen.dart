import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/translate_service.dart';
import 'package:haru_admin/api/word_data_services.dart';
import 'package:haru_admin/model/translate_model.dart';
import 'package:haru_admin/model/word_data_model.dart';
import 'package:haru_admin/utils/enum_type.dart';
import 'package:haru_admin/widgets/chapter_catalog_table.dart';
import 'package:just_audio/just_audio.dart';

import '../../widgets/buttons.dart';
import '../../provider/intro_provider.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen(this.wordId, {super.key});

  final String? wordId;

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final WordDataRepository wordRepository = WordDataRepository();
  final TranslateRepository translateRepository = TranslateRepository();
  TextEditingController titleController = TextEditingController();
  late List<TextEditingController> englishControllers;
  late List<TextEditingController> chineseControllers;
  late List<TextEditingController> vietnamControllers;
  late List<TextEditingController> russianControllers;
  late List<TextEditingController> descriptionControllers;

  // 회차 데이터 가져오기
  IntroInfo info = IntroInfo();
  List<PatchWordChapterDataComponent> _datas = [];
  final List<bool> _isChecked = List<bool>.filled(10, false);
  bool _isWaiting = false;

  List<Map<String, double>> tabletitle = [
    {'': 50},
    {'순서': 50},
    {'단어': 150},
    {'이미지': 200},
    {'음성': 100},
    {'ENG': 150},
    {'CHN': 150},
    {'VIE': 150},
    {'RUS': 150},
    {'추가 설명': 100},
  ];

  late Future<void> _wordDataFuture;

  void deleteSelectedWord() {
    setState(() {
      List<int> indicesToRemove = [];
      for (int i = 0; i < _datas.length; i++) {
        if (_isChecked[i]) {
          indicesToRemove.add(i);
        }
      }

      // 뒤에서부터 지워서 index shift 방지
      indicesToRemove.sort((a, b) => b.compareTo(a));

      // 데이터와 컨트롤러 삭제
      for (int index in indicesToRemove) {
        _datas.removeAt(index);
        englishControllers.removeAt(index);
        chineseControllers.removeAt(index);
        vietnamControllers.removeAt(index);
        russianControllers.removeAt(index);
        descriptionControllers.removeAt(index);
      }

      // 순서 재정렬
      for (int i = 0; i < _datas.length; i++) {
        _datas[i].order = i + 1;
      }
      _isChecked.fillRange(0, 10, false);
    });
  }

  void save() async {
    try {
      if (info.dataId != null) {
        for (int i = 0; i < _datas.length; i++) {
          _datas[i].order = i + 1;
        }
        for (int i = 0; i < _datas.length; i++) {
          _datas[i].english = englishControllers[i].text;
          _datas[i].chinese = chineseControllers[i].text;
          _datas[i].vietnam = vietnamControllers[i].text;
          _datas[i].russian = russianControllers[i].text;
          _datas[i].description = descriptionControllers[i].text;
        }

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
            status: 'WAIT',
          ),
        )
            .then((value) {
          if (value != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('저장 완료')),
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

  void translate() async {
    // 한국어, 영어 모두 입력안했을 때 '한국어와 영어를 모두 입력해주세요' snack bar
    bool isKoreanFilled = _datas.every((element) {
      if (element.title.isEmpty ||
          element.title == '' ||
          element.english == '') {
        return false;
      }
      return true;
    });

    if (isKoreanFilled == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('한국어와 영어를 모두 입력하고 저장한 후 번역해주세요')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      for (var data in _datas) {
        TranslatedResponse? response = await translateRepository.translate(
          korean: data.title,
          english: data.english,
        );
        print(response);
        if (response != null) {
          setState(() {
            data.english = response.english;
            data.chinese = response.chinese;
            data.vietnam = response.vietnam;
            data.russian = response.russian;
          });
        }
      }

      for (int i = 0; i < _datas.length; i++) {
        englishControllers[i].text = _datas[i].english ?? '';
        chineseControllers[i].text = _datas[i].chinese ?? '';
        vietnamControllers[i].text = _datas[i].vietnam ?? '';
        russianControllers[i].text = _datas[i].russian ?? '';
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  void confirm() async {
    // (description 제외) 모든 데이터 null 값 체크
    bool isAllNull = _datas.every((element) {
      if (element.title.isEmpty ||
          element.title == '' ||
          element.english == '' ||
          element.chinese == '' ||
          element.vietnam == '' ||
          element.russian == '' ||
          // element.imgUrl == null ||
          element.voiceUrl == null) {
        return false;
      }
      return true;
    });

    if (isAllNull == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('모든 데이터를 입력해주세요. \'저장하기\'를 먼저 해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    // CONFRIM 확정하겠냐는 dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('데이터를 유저 앱에 반영합니다.'),
          content: const Text(
              '체크리스트\n1. 단어의 맞춤법을 확인했나요?\n2. 영어, 중국어, 베트남어, 러시아어 - 번역을 검토했나요?\n3. 이미지가 정확한지 확인했나요?\n4. 음성이 정확한지 확인했나요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  // 확정하면 데이터 저장
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
                        status: 'APPROVE'),
                  )
                      .then((value) {
                    if (value != null) {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('유저 앱 반영 완료 🤠')),
                          showCloseIcon: true,
                          closeIconColor: Colors.white,
                        ),
                      );
                    }
                  });
                } catch (e) {
                  throw Exception(e);
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

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
        setState(() {
          _isWaiting = true;
        });
        await wordRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: _datas[index].title,
          fileType: file.extension!,
        )
            .then((value) {
          setState(() {
            _datas = _datas.map((PatchWordChapterDataComponent data) {
              if (data.order == index + 1) {
                return data.copyWith(imageUrl: value);
              }
              return data;
            }).toList();

            _isWaiting = false;
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
          fileType: file.extension!,
        )
            .then((value) {
          setState(() {
            _datas = _datas.map((data) {
              if (data.order == index + 1) {
                data.voiceUrl = value;
              }
              return data;
            }).toList();
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  playAudio(int index) async {
    try {
      final player = AudioPlayer();
      if (_datas[index].voiceUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('음성 파일이 없습니다.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }
      await player.setUrl(_datas[index].voiceUrl!);
      await player.setVolume(0.5);
      await player.pause();
      await player.stop();
      player.play();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<void> fetchWordData() async {
    try {
      if (widget.wordId != null) {
        await wordRepository
            .getWordData(id: int.parse(widget.wordId!))
            .then((value) {
          _datas = value.wordDataList.map((data) {
            return PatchWordChapterDataComponent(
              id: data.id,
              order: data.order,
              title: data.title,
              imageUrl: data.imgUrl,
              voiceUrl: data.voiceUrl,
              english: data.english,
              chinese: data.chinese,
              vietnam: data.vietnam,
              russian: data.russian,
              description: data.description,
            );
          }).toList();

          setState(() {
            info = IntroInfo(
              dataId: value.id,
              level: levelFromString(value.level),
              category: CATEGORY.WORD,
              cycle: value.cycle,
              sets: value.sets,
              chapter: value.chapter,
              title: value.title,
            );
          });
        });

        // 순서 0 일때
        for (int i = 0; i < _datas.length; i++) {
          if (_datas[i].order == 0) {
            _datas[i].order = i + 1;
          }
        }
        titleController.text = info.title ?? '';

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
    _wordDataFuture = fetchWordData();
  }

  @override
  void dispose() {
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
                  titleController: titleController,
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
                              shrinkWrap: true,
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
                                      child: Text(
                                        _datas[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // 4. 이미지
                                    TableComponent(
                                      width: tabletitle[3].values.first,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (_isWaiting == false &&
                                                  _datas[index].imageUrl !=
                                                      null)
                                              ? Image.network(
                                                  _datas[index].imageUrl!,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                )
                                              : const SizedBox(),
                                          TextButton(
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
                                        ],
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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              '[ENG] ${_datas[index].title}',
                                          hintStyle: const TextStyle(
                                              color: Colors.orange),
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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              '[中文] ${_datas[index].title}',
                                          hintStyle: const TextStyle(
                                              color: Colors.orange),
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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              '[Tiếng Việt] ${_datas[index].title}',
                                          hintStyle: const TextStyle(
                                              color: Colors.orange),
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
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              '[Русский язык] ${_datas[index].title}',
                                          hintStyle: const TextStyle(
                                              color: Colors.orange),
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
                                  _datas = _datas.map((data) {
                                    data.order = _datas.indexOf(data) + 1;
                                    return data;
                                  }).toList();
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
                    MyCustomButton(
                      text: '단어 뺴기',
                      onTap: () => deleteSelectedWord(),
                      color: const Color(0xFFFFCC4A),
                    ),
                    const Expanded(child: SizedBox()),
                    MyCustomButton(
                      text: 'CONFIRM',
                      onTap: () => confirm(),
                      color: const Color(0xFFFF7D53),
                    ),
                    const SizedBox(width: 10),
                    MyCustomButton(
                      text: '번역하기',
                      onTap: () => translate(),
                      color: const Color(0xFF484848),
                    ),
                    const SizedBox(width: 10),
                    MyCustomButton(
                      text: '저장하기',
                      onTap: () => save(),
                      color: const Color(0xFF3F99F7),
                    )
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
