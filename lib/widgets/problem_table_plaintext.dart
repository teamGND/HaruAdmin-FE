import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:just_audio/just_audio.dart';

import '../api/test_data_services.dart';

class ProblemTablePlaintext extends ConsumerWidget {
  ProblemTablePlaintext({
    super.key,
    required this.problem,
    required this.texts,
  });
  final TestDataRepository testDataRepository = TestDataRepository();
  final ProblemDataModel problem;
  final List<String?> texts;

  String? imageUrl = ''; // 201 타입 0번 인덱스
  String? audioUrl = ''; // 207 타입 1번 인덱스

  static const Map<int, List<String>> tableTitle = {
    101: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나'],
    102: ['선지 0', '선지 1', '선지 2', '정답 - 0,1,2 중 하나 '],
    103: ['단어'],
    104: ['단어'],
    201: ['그림', ' 그림 설명', '문장 - 빈칸에 ()넣기', '정답 - 여러 개면 /로 구분'],
    202: ['문장 - /로 구분', '정답 순서 - ,로 구분 0부터 카운트'],
    203: ['문장 - 빈칸에 ()넣기', '선지0', '선지1', '선지2 - 없으면 비우기', '정답 - 0,1,2 중 하나'],
    204: ['문장 - 빈칸에 ()넣기', '선지0', '선지1', '선지2', '정답 - 틀린 문장. 0,1,2 중 하나'],
    205: ['예시 문장(원래)', '예시 문장(바꾼)', '문제 문장(원래)', '정답 문장 - 여러 개면 /로 구분'],
    206: ['문장 - 띄어쓰기 기준. 틀린 부분 ()로 표시', '올바른 문장 - 여러 개면 /로 구분'],
    207: ['문장', '음성파일 (파일 추가)'],
    208: ['제시 문장', '옳은 문장', '정답 여부(대문자 O,X 중 하나)'],
  };

  void getImageUrl(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'svg', 'jpeg']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await testDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: 'test_${problem.chapter}_${index + 1}',
          fileType: file.extension!,
        )
            .then((value) {
          imageUrl = value;
        });
      } else {
        // User canceled the picker
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void getAudioUrl(int index) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);

      if (result != null) {
        PlatformFile file = result.files.first;

        await testDataRepository
            .uploadFile(
          fileBytes: file.bytes!,
          fileName: 'test_${problem.chapter}_${index + 1}',
          fileType: file.extension!,
        )
            .then((value) {
          audioUrl = value;
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

      await player.setUrl(audioUrl!);
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
  Widget build(BuildContext context, ref) {
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
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: tableTitle[problem.problemType]!
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
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  List.generate(tableTitle[problem.problemType]!.length, (idx) {
                return Flexible(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border.symmetric(
                          vertical: BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      )),
                    ),
                    child: Center(
                      child: (problem.problemType == 201 && idx == 0)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (texts[idx] != '' && texts[idx] != null)
                                    ? Image.network(
                                        texts[idx]!,
                                      )
                                    : const SizedBox(),
                                GestureDetector(
                                  onTap: () {
                                    // add Image
                                    getImageUrl(idx);
                                  },
                                  child: const Text('이미지 추가하기',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue)),
                                ),
                              ],
                            )
                          : (problem.problemType == 207 && idx == 1)
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    texts[idx] != ''
                                        ? GestureDetector(
                                            onTap: () {
                                              playAudio(idx);
                                            },
                                            child: const Icon(Icons.play_arrow),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              // add Image
                                              getAudioUrl(idx);
                                            },
                                            child: const Text('오디오 추가하기',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue)),
                                          ),
                                  ],
                                )
                              : Text(
                                  texts[idx] ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
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
