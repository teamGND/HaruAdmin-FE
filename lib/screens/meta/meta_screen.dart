import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:haru_admin/api/meta_grammar_services.dart';
import 'package:haru_admin/model/meta_data_model.dart';

import '../../api/translate_service.dart';
import '../../model/translate_model.dart';
import '../../widgets/buttons.dart';

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

  updateSelectedMetaData() async {
    // 선택된 메타데이터를 업데이트하는 비동기 함수
    try {
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

  saveMetaGrammarData() async {
    // 새로운 메타데이터를 추가하는 함수

    try {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                '메타문법 데이터',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text(
                '10개 이상 추가될 경우, 연진 또는 개발자에게 문의하세요',
                style: TextStyle(
                  fontSize: 5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              if (_selectedMetaDataIdx != null) buildMetaGrammarDetailView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMetaGrammarTable() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 200,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(
          color: const Color(0xFFB9B9B9),
          width: 1,
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(4), // 사이클
          2: FlexColumnWidth(1), // 세트
          3: FlexColumnWidth(4), // 회차
        },
        children: [
          metaGrammarListTitle(),
          for (var i = 0; i < 5; i++)
            TableRow(
              children: [
                buildTableCell(i * 2 + 1),
                buildMetaTitleCell(i * 2),
                buildTableCell(i * 2 + 2),
                buildMetaTitleCell(i * 2 + 1),
              ],
            )
        ],
      ),
    );
  }

  Widget buildTableCell(int number) {
    return TableCell(
      child: SizedBox(
        height: 30,
        child: Center(
          child: Text(number.toString()),
        ),
      ),
    );
  }

  Widget buildMetaTitleCell(int index) {
    if (_metaGrammarTitles.length < index) return const Text('');

    return TableCell(
        child: Container(
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedMetaDataIdx == index
              ? Colors.lightBlue
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: _metaGrammarTitles.length == (index + 1)
          ? TextButton(
              onPressed: () {
                addMetaGrammarData();
              },
              child: const Text(
                '추가하기',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            )
          : TextButton(
              onPressed: () {
                getSelectedMetaData(index);
              },
              child: Text(
                _metaGrammarTitles.length > index
                    ? _metaGrammarTitles[index].title ?? ''
                    : '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
    ));
  }

  Widget buildMetaGrammarDetailView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('<메타문법 용어 수정/추가>',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Text('번호'),
              const SizedBox(width: 20),
              Text(
                  '${_selectedMetaDataIdx == null ? '' : (_selectedMetaDataIdx! + 1)}'),
            ],
          ),
          Row(
            children: [
              const Text('제목'),
              const SizedBox(width: 20),
              buildTitleTextField(),
            ],
          ),
          const SizedBox(height: 20),
          buildDescriptionTable(),
          const SizedBox(height: 10),
          buildActionButtons(),
        ],
      ),
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
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget buildDescriptionTable() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            Expanded(
              child: Table(
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
            ),
            buildImageSection(),
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

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MyCustomButton(
          text: '삭제',
          onTap: delete,
          color: Colors.red,
        ),
        const SizedBox(width: 10),
        MyCustomButton(
          text: '번역',
          onTap: translate,
          color: const Color(0XFF484848),
        ),
        const SizedBox(width: 10),
        MyCustomButton(
          text: '저장하기',
          onTap: () {
            if (_metaGrammarTitles[_selectedMetaDataIdx!].id == null) {
              saveMetaGrammarData();
            } else {
              updateSelectedMetaData();
            }
          },
          color: const Color(0xFF3F99F7),
        ),
      ],
    );
  }

  TableRow metaGrammarListTitle() {
    return const TableRow(
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
      ),
      children: [
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '순서',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '제목',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '순서',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        TableCell(
          child: SizedBox(
            height: 30,
            child: Center(
                child: Text(
              '제목',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
      ],
    );
  }
}

TableRow MetagrammarDescriptionTableRow({
  required String title,
  required int index,
  required TextEditingController textController,
}) {
  return TableRow(children: [
    Container(
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F0F0),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 30, // Minimum height
          maxHeight: 200, // You can adjust the max height as needed
        ),
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
    ),
  ]);
}
