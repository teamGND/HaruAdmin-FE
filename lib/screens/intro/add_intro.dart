import 'package:flutter/material.dart';
import 'package:haru_admin/api/intro_data_services.dart';
import 'package:haru_admin/model/intro_data_model.dart';
import 'package:haru_admin/widgets/colors.dart';

enum Level { ALPHABET, LEVEL1 }

enum Category { WORD, EXPRESSION, TEST, MIDTERM }

/// 인트로 데이터 조회/수정 화면
/// 수정 -> 타이틀만 수정가능

class AddIntro extends StatefulWidget {
  const AddIntro({super.key});

  @override
  State<AddIntro> createState() => _AddIntroState();
}

class _AddIntroState extends State<AddIntro> {
  final IntroDataRepository introRepository = IntroDataRepository();

  static const Map<String, String> categoryMap = {
    'WORD': '단어',
    'GRAMMAR': '문법',
    'TEST': '테스트',
    'MIDTERM': '중간평가',
  };

  Level? _selectedLevel = Level.ALPHABET;
  Category? _selectedCategory = Category.WORD;

  Future<IntroModel?> fetchIntroData() async {
    try {
      IntroModel introModel;

      List<String> urlParam = Uri.base.toString().split('/');
      int len = urlParam.length;
      int chapterId = int.parse(urlParam[len - 1]);
      String categoryName = urlParam[len - 2];

      introRepository.getIntroData(id: chapterId).then((value) {
        introModel = value;
        introModel.copyWith(category: categoryName);

        return introModel;
      });
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              "인트로 데이터 조회/수정",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      HeaderText(text: "레벨"),
                      HeaderText(text: "유형"),
                      HeaderText(text: "사이클"),
                      HeaderText(text: "회차"),
                      HeaderText(text: "타이틀"),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                FutureBuilder(
                  future: fetchIntroData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // if (snapshot.hasData == false) {
                    //   return const CircularProgressIndicator();
                    // } else
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RowBox(
                              child: DropdownButton(
                                value: _selectedLevel,
                                isExpanded: true,
                                items: Level.values
                                    .map((Level option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(
                                              option.toString().split('.')[1]),
                                        ))
                                    .toList(),
                                onChanged: (Level? value) {
                                  setState(() {
                                    _selectedLevel = value;
                                  });
                                },
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                borderRadius: BorderRadius.circular(10),
                                underline: Container(
                                  height: 0,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: Category.values
                                    .map((Category option) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Radio<Category>(
                                              value: option,
                                              groupValue: _selectedCategory,
                                              onChanged: (Category? value) {
                                                setState(() {
                                                  _selectedCategory = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              categoryMap[option
                                                  .toString()
                                                  .split('.')[1]]!,
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                            RowBox(child: Text(snapshot.data.cycle.toString())),
                            RowBox(
                                child: Text(snapshot.data.chapter.toString())),
                            RowBox(child: Text(snapshot.data.title)),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 130,
                vertical: 25,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {},
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

class RowBox extends StatelessWidget {
  const RowBox({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 350,
        height: 50,
        child: Center(child: child),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 20,
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: ' *',
              style: TextStyle(
                color: Color(0xFFF05A2A),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
