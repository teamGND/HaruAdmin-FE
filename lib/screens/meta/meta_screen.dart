import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/api/meta_grammar_services.dart';
import 'package:haru_admin/model/meta_data_model.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/gaps.dart';

import '../../api/translate_service.dart';
import '../../model/translate_model.dart';

class MetaGrammarScreen extends StatefulWidget {
  const MetaGrammarScreen({super.key});

  @override
  State<MetaGrammarScreen> createState() => _MetaGrammarScreenState();
}

class _MetaGrammarScreenState extends State<MetaGrammarScreen> {
  final MetaGrammarDataRepository metaGrammarDataRepository =
      MetaGrammarDataRepository();
  final TranslateRepository translateRepository = TranslateRepository();

  static const MAX_META_DATA = 20;
  late Future<void> _metaListDataFuture;
  List<MetaGrammarData> _metaGrammarTitles = [];
  int? _selectedMetaDataIdx;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController koreanControllers = TextEditingController();
  final TextEditingController englishControllers = TextEditingController();
  final TextEditingController chineseControllers = TextEditingController();
  final TextEditingController vietnamControllers = TextEditingController();
  final TextEditingController russianControllers = TextEditingController();
  List<String> titles = [
    '한국어',
    '영어',
    '중국어',
    '베트남어',
    '러시아어',
  ];

  String? imageUrl;

  fetchMetaListData() async {
    // 메타문법 데이터를 가져오는 비동기 함수
    try {
      await MetaGrammarDataRepository()
          .getMetaGrammerDataList(page: 0, size: MAX_META_DATA)
          .then((value) {
        _metaGrammarTitles = value.content; // 메타데이터 리스트에서 타이틀만 가져오기
      });
      _metaGrammarTitles.add(MetaGrammarData());
    } catch (e) {
      throw Exception(e);
    }
  }

  getSelectedMetaData(int index) async {
    setState(() {
      _selectedMetaDataIdx = index;
    });

    if (_metaGrammarTitles[index].id == null) {
      return;
    }

    try {
      await metaGrammarDataRepository
          .getMetaGrammarData(
        metaId: _metaGrammarTitles[index].id!,
      )
          .then((value) {
        setState(() {
          titleController.text = value.title ?? '';
          koreanControllers.text = value.content ?? '';
          englishControllers.text = value.english ?? '';
          chineseControllers.text = value.chinese ?? '';
          vietnamControllers.text = value.vietnam ?? '';
          russianControllers.text = value.russian ?? '';
          imageUrl = value.image;
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  addMetaGrammarData() {
    if (_metaGrammarTitles.length <= 1 ||
        _metaGrammarTitles[_metaGrammarTitles.length - 2].title != null) {
      setState(() {
        _selectedMetaDataIdx = _metaGrammarTitles.length - 1;
        _metaGrammarTitles.add(MetaGrammarData());
        titleController.text = '';
        koreanControllers.text = '';
        englishControllers.text = '';
        chineseControllers.text = '';
        vietnamControllers.text = '';
        russianControllers.text = '';
      });
    }
  }

  saveMetaGrammarData({int? metaId}) async {
    // 새로운 메타데이터를 추가하는 함수

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('제목을 입력해주세요')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      if (metaId != null) {
        await metaGrammarDataRepository.updateMetaGrammarData(
          metaId: _metaGrammarTitles[_selectedMetaDataIdx!].id!,
          data: MetaGrammarDataModel(
            id: _metaGrammarTitles[_selectedMetaDataIdx!].id,
            title: titleController.text,
            content: koreanControllers.text,
            english: englishControllers.text,
            chinese: chineseControllers.text,
            vietnam: vietnamControllers.text,
            russian: russianControllers.text,
          ),
        );

        return;
      } else {
        await metaGrammarDataRepository.addNewMetaData(
          data: AddMetaData(
            title: titleController.text,
            content: koreanControllers.text,
            english: englishControllers.text,
            chinese: chineseControllers.text,
            vietnam: vietnamControllers.text,
            russian: russianControllers.text,
          ),
        );
      }

      await fetchMetaListData();
    } catch (e) {
      throw Exception(e);
    }
  }

  translate() async {
    // 한국어 '한국어를 입력해주세요' snack bar

    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('한국어를 입력해주세요')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      TranslatedResponse? response = await translateRepository.translate(
        korean: koreanControllers.text,
        english: englishControllers.text,
      );
      print(response);
      if (response != null) {
        englishControllers.text = response.english ?? '';
        chineseControllers.text = response.chinese ?? '';
        vietnamControllers.text = response.vietnam ?? '';
        russianControllers.text = response.russian ?? '';
      }
    } catch (e) {
      print(e);
    }
  }

  void getImageUrl() async {
    if (titleController.text == '') {
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

        await metaGrammarDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName:
              'meta_grammar_${_metaGrammarTitles[_selectedMetaDataIdx!].title!}',
          fileType: file.extension!,
        )
            .then((value) {
          setState(() {
            imageUrl = value;
          });
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  delete() async {
    if (_selectedMetaDataIdx == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('삭제할 데이터를 선택해주세요.')),
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      return;
    }

    try {
      if (_metaGrammarTitles[_selectedMetaDataIdx!].id == null) {
        setState(() {
          _metaGrammarTitles.removeAt(_selectedMetaDataIdx!);
          _selectedMetaDataIdx = null;
        });
        return;
      }

      await metaGrammarDataRepository.deleteMetaData(
        metaIdList: [_metaGrammarTitles[_selectedMetaDataIdx!].id!],
      );
      setState(() {
        _metaGrammarTitles.removeAt(_selectedMetaDataIdx!);
        _selectedMetaDataIdx = null;
      });
    } catch (e) {
      throw Exception(e);
    }
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _metaListDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading data');
                      } else {
                        // Process the data and build the UI
                        return buildMetaGrammarTable();
                      }
                    },
                  ),
                  Gaps.h20,
                  if (_selectedMetaDataIdx != null)
                    buildMetaGrammarDetailView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMetaGrammarTable() {
    //  const Text(
    //             '최대 10개 추가 가능',
    //             style: TextStyle(
    //               fontSize: 10,
    //               fontWeight: FontWeight.w500,
    //               color: Color(0xFF585858),
    //             ),
    //           ),
    return Container(
      width: 210,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
            children: List.generate(10, (idx) {
          return _metaGrammarTitles.length - 1 > idx
              ? GestureDetector(
                  onTap: () {
                    getSelectedMetaData(idx);
                  },
                  child: Container(
                    width: 170,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _selectedMetaDataIdx == idx
                          ? const Color(0xFFD9D9D9)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Gaps.h10,
                          SizedBox(
                            width: 25,
                            child: Text(
                              '${(idx + 1).toString()}.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _selectedMetaDataIdx == idx
                                    ? Colors.black
                                    : const Color(0xFF9C9C9C),
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Gaps.h20,
                          SizedBox(
                            width: 110,
                            child: Text(
                              _metaGrammarTitles[idx].title ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _selectedMetaDataIdx == idx
                                    ? Colors.black
                                    : const Color(0xFF9C9C9C),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : _metaGrammarTitles.length - 1 == (idx)
                  ? GestureDetector(
                      onTap: () {
                        addMetaGrammarData();
                      },
                      child: SizedBox(
                        width: 170,
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Gaps.h10,
                              SizedBox(
                                width: 25,
                                child: Text(
                                  '${(idx + 1).toString()}.',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ColorPallete.blue,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Gaps.h20,
                              const SizedBox(
                                width: 110,
                                child: Text(
                                  '추가하기',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ColorPallete.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 170,
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Gaps.h10,
                            SizedBox(
                              width: 25,
                              child: Text(
                                '${(idx + 1).toString()}.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF9C9C9C),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        })),
      ),
    );
  }

  Widget buildMetaGrammarDetailView() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '문법 용어 수정/추가하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v20,
                Row(
                  children: [
                    Text(
                      '${_selectedMetaDataIdx == null ? '' : (_selectedMetaDataIdx! + 1)}.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.h10,
                    buildTitleTextField(),
                  ],
                ),
                const SizedBox(height: 20),
                buildDescriptionTable(),
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClickableButton(
                  onPressed: delete, color: ColorPallete.red, text: '삭제'),
              ClickableButton(
                  onPressed: translate, color: ColorPallete.gray, text: '번역'),
              ClickableButton(
                  onPressed: saveMetaGrammarData,
                  color: ColorPallete.green,
                  text: '저장'),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTitleTextField() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 300,
        height: 40,
        child: TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: '제목을 입력해주세요',
            hintStyle: TextStyle(
              fontSize: 15,
              color: Color(0xFF9C9C9C),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFCDCDCD)),
            ),
          ),
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget buildDescriptionTable() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 350,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            buildImageSection(),
            Table(
              border: TableBorder.all(
                color: const Color(0xFFB9B9B9),
                width: 1,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(8),
              },
              children: List.generate(
                titles.length,
                (index) => MetagrammarDescriptionTableRow(
                  title: titles[index],
                  index: index,
                  textController: index == 0
                      ? koreanControllers
                      : index == 1
                          ? englishControllers
                          : index == 2
                              ? chineseControllers
                              : index == 3
                                  ? vietnamControllers
                                  : russianControllers,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageSection() {
    return Column(
      children: [
        (imageUrl == '' || imageUrl == null)
            ? const Icon(
                Icons.image,
                size: 100,
                color: Colors.grey,
              )
            : Image.network(imageUrl!),
        TextButton(
          onPressed: getImageUrl,
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
    );
  }

  TableRow MetagrammarDescriptionTableRow({
    required String title,
    required int index,
    required TextEditingController textController,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            maxLines: null, // Allows the text field to grow vertically
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              // no border
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
