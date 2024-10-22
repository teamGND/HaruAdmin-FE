import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../api/test_data_services.dart';
import '../provider/test_provider.dart';

enum BoxType { text, number, image, audio }

class ProblemTable extends ConsumerWidget {
  ProblemTable({
    super.key,
    required this.problemType,
    required this.problemIdx,
    required this.problemTexts,
    this.isPrev = false,
  });
  final TestDataRepository testDataRepository = TestDataRepository();
  final List<String?> problemTexts;
  final int problemType;
  final int problemIdx;
  final bool isPrev;

  static const Map<int, List<String>> tableTitle = {
    101: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나'],
    102: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나 '],
    103: ['단어'],
    104: ['단어'],
    201: ['그림', ' 그림 설명', '문장 - 정답 하나 당 빈칸 () 하나', '정답 - 여러 개면 /로 구분'],
    202: ['문장 - /로 구분', '정답 순서 - ,로 구분 0부터 카운트'],
    203: ['문장 - 빈칸에 ()넣기', '선지0', '선지1', '선지2 - 없으면 비우기', '정답 - 0,1,2 중 하나'],
    204: ['문장 - 빈칸에 ()넣기', '선지0', '선지1', '선지2', '정답 - 틀린 문장. 0,1,2 중 하나'],
    205: ['예시 문장(원래)', '예시 문장(바꾼)', '문제 문장(원래)', '정답 문장 - 여러 개면 /로 구분'],
    206: ['문장 - 띄어쓰기 기준. 틀린 부분 ()로 표시', '올바른 문장 - 여러 개면 /로 구분'],
    207: ['문장', '음성파일 (파일 추가)'],
    208: ['제시 문장', '옳은 문장 - 여러 개면 /로 구분', '정답 여부(대문자 O,X 중 하나)'],
  };

  bool isUncomplete({
    required String? text,
    required int problemType,
    required int idx,
  }) {
    if (text != null) return false;

    if (problemType == 201 && idx == 1) {
      return false;
    } else if (problemType == 203 && idx == 3) {
      return false;
    } else if (problemType == 208 && idx == 1) {
      return false;
    }

    return true;
  }

  void getImageUrl(WidgetRef ref, BuildContext context,
      {required int problemType}) async {
    if (problemType != 201) {
      return;
    }
    String fileName = '';

    if (problemTexts[2] == null || problemTexts[3] == null) {
      // 문제 문장과 정답을 먼저 입력해주세요 snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('문제 문장과 정답을 먼저 입력해주세요'),
        ),
      );

      return;
    }
    List<String> answers = problemTexts[3]!.split('/');
    int i = 0;
    problemTexts[2]!.split('()').forEach((element) {
      fileName += element;
      if (i < answers.length) {
        fileName += answers[i];
      }
      i++;
    });

    print(fileName);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await testDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: '${problemType}_$fileName',
          fileType: file.extension!,
        )
            .then((value) {
          // index 번째 problemData update
          ref
              .watch(testProvider.notifier)
              .updateProblemTexts(problemIdx: problemIdx, problemTexts: [
            value,
            problemTexts[1],
            problemTexts[2],
            problemTexts[3],
          ]);
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void getAudioUrl(WidgetRef ref, BuildContext context,
      {required int problemType}) async {
    String fileName = '';
    if (problemType != 207) {
      return;
    }
    if (problemType == 207) {
      if (problemTexts[0] == null) {
        return;
      }
      fileName = problemTexts[0]!;
    }
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await testDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: '${problemType}_$fileName',
          fileType: file.extension!,
        )
            .then((value) {
          // index 번째 problemData update

          ref.watch(testProvider.notifier).updateProblemTexts(
            problemIdx: problemIdx,
            problemTexts: [
              problemTexts[0],
              value,
            ],
          );
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  playAudio({required int problemType}) async {
    try {
      if (problemType != 207) return;
      if (problemTexts[1] == null) return;
      final player = AudioPlayer();

      await player.setUrl(problemTexts[1]!);
      await player.setVolume(0.5);
      await player.pause();
      await player.stop();
      player.play();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          vertical: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      height: 80,
      child: Column(
        children: [
          // 제목
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: tableTitle[problemType]!
                  .map(
                    (title) => Flexible(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: const Border.symmetric(
                              vertical: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                        ),
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          // 내용
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(tableTitle[problemType]!.length, (idx) {
                return Flexible(
                  child: GestureDetector(
                    onTap: () {
                      if (problemType == 201 && idx == 0) {
                        getImageUrl(ref, context, problemType: problemType);
                      } else if (problemType == 207 && idx == 1) {
                        getAudioUrl(ref, context, problemType: problemType);
                      } else {
                        ref.watch(testProvider.notifier).clickProblemColumn(
                              problemIdx: problemIdx,
                              columnIdx: idx,
                            );
                      }
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.symmetric(
                            vertical: BorderSide(
                          color: isUncomplete(
                            text: problemTexts[idx],
                            problemType: problemType,
                            idx: idx,
                          )
                              ? Colors.black
                              : Colors.grey,
                          width: 0.5,
                        )),
                      ),
                      child: Center(
                        child: (problemType == 201 && idx == 0)
                            ? Image.network(
                                problemTexts[idx] ?? '',
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image),
                              )
                            : (problemType == 207 && idx == 1)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            playAudio(problemType: problemType);
                                          },
                                          icon: const Icon(Icons.audio_file)),
                                      TextButton(
                                          onPressed: () {
                                            getAudioUrl(ref, context,
                                                problemType: problemType);
                                          },
                                          child: const Text('파일 추가'))
                                    ],
                                  )
                                : (ref.watch(testProvider).focusedProbelmIdx ==
                                            problemIdx &&
                                        ref
                                                .watch(testProvider)
                                                .focusedColumnIdx ==
                                            idx)
                                    ? TextField(
                                        textAlign: TextAlign.center,
                                        controller: TextEditingController(
                                            text: problemTexts[idx]),
                                        onChanged: (text) {
                                          problemTexts[idx] = text;
                                          ref
                                              .watch(testProvider.notifier)
                                              .updateProblemTexts(
                                                problemIdx: problemIdx,
                                                problemTexts: problemTexts,
                                              );
                                        },
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      )
                                    : Text(
                                        problemTexts[idx] ?? '',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
