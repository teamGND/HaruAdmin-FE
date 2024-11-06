import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/provider/intro_provider.dart';

import '../../../api/grammer_data_services.dart';
import '../../../api/translate_service.dart';
import '../../../model/translate_model.dart';
import '../../../provider/grammar_provider.dart';
import '../../../utils/grammar_parse_line_function.dart';

// 제시문
class DescriptionWidget extends ConsumerStatefulWidget {
  const DescriptionWidget({
    super.key,
    required this.descriptionControllers,
  });

  final List<TextEditingController> descriptionControllers;

  @override
  ConsumerState<DescriptionWidget> createState() => DescriptionWidgetState();
}

class DescriptionWidgetState extends ConsumerState<DescriptionWidget> {
  final TranslateRepository translateRepository = TranslateRepository();
  final GrammerDataRepository grammarDataRepository = GrammerDataRepository();

  final List<String> _languageTitles = ["한국어", "ENG", "CHN", "VIE", "RUS"];
  int _selectedLanguage = 0;
  bool _isTranslating = false;

  String? imageUrl = '';

  Future<void> getImageUrl() async {
    IntroInfo info = ref.read(introProvider);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await grammarDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName:
              'grammar_${info.level.toString().split('.').last}_${info.cycle.toString()}_${info.sets.toString()}_${info.chapter.toString()}',
          fileType: file.extension!,
        )
            .then((value) {
          ref.watch(grammarDataProvider.notifier).updateDescriptionImageUrl(
                value,
              );

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

  save() {
    ref.read(grammarDataProvider.notifier).updateDescription(
          description: widget.descriptionControllers[0].text,
          descriptionEng: widget.descriptionControllers[1].text,
          descriptionChn: widget.descriptionControllers[2].text,
          descriptionVie: widget.descriptionControllers[3].text,
          descriptionRus: widget.descriptionControllers[4].text,
          grammarImageUrl: imageUrl,
        );
  }

  //translate
  translate() async {
    setState(() {
      _isTranslating = true;
    });
    try {
      bool isKoreanFilled = widget.descriptionControllers[0].text.isNotEmpty;

      if (isKoreanFilled == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('한국어 제시문을 입력해주세요.')),
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return;
      }

      TranslatedResponse? response = await translateRepository.translate(
        korean: widget.descriptionControllers[0].text,
        english: widget.descriptionControllers[1].text,
      );

      widget.descriptionControllers[1].text = response?.english ?? '';
      widget.descriptionControllers[2].text = response?.chinese ?? '';
      widget.descriptionControllers[3].text = response?.vietnam ?? '';
      widget.descriptionControllers[4].text = response?.russian ?? '';
    } catch (e) {
      print("error : $e");
    }
    setState(() {
      _isTranslating = false;
    });
  }

  @override
  void initState() {
    super.initState();

    widget.descriptionControllers[0].text =
        ref.read(grammarDataProvider).description ?? '';
    widget.descriptionControllers[1].text =
        ref.read(grammarDataProvider).descriptionEng ?? '';
    widget.descriptionControllers[2].text =
        ref.read(grammarDataProvider).descriptionChn ?? '';
    widget.descriptionControllers[3].text =
        ref.read(grammarDataProvider).descriptionVie ?? '';
    widget.descriptionControllers[4].text =
        ref.read(grammarDataProvider).descriptionRus ?? '';
  }

  @override
  void dispose() {
    for (var controller in widget.descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _languageTitles.length; i++)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedLanguage = i;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: i == _selectedLanguage
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              child: Text(
                                _languageTitles[i],
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16.0,
                      ),
                      child: TextFormField(
                        maxLines: 15,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          hintText: '제시문을 입력해주세요.',
                        ),
                        controller:
                            widget.descriptionControllers[_selectedLanguage],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: save,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '완료',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => translate(),
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFF484848),
                          border: Border.all(
                            color: const Color(0xFF484848),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isTranslating
                              ? const CircularProgressIndicator()
                              : const Text(
                                  '번역',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: getImageUrl,
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCDCDCD),
                          border: Border.all(
                            color: const Color(0xFFCDCDCD),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            '이미지 등록',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 1,
          child: Container(
            height: 500,
            width: 300,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xffd4f3ff),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    color: const Color(0xFFFFFFFF),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 300,
                          child: RichText(
                            text: TextSpan(
                              // parse
                              children: parseDescriptionLine(widget
                                  .descriptionControllers[_selectedLanguage]
                                  .text),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        (imageUrl != null && imageUrl != '')
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
