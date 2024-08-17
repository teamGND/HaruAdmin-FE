import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enum_type.dart';

class IntroInfo {
  int? dataId;
  LEVEL? level;
  CATEGORY? category;
  int? cycle;
  int? sets;
  int? chapter;
  String? title;
  List<String>? wordDatas;

  IntroInfo({
    this.dataId,
    this.level,
    this.category,
    this.cycle,
    this.sets,
    this.chapter,
    this.title,
    this.wordDatas,
  });

  IntroInfo copyWith({
    int? dataId,
    LEVEL? level,
    CATEGORY? category,
    int? cycle,
    int? sets,
    int? chapter,
    String? title,
    List<String>? wordDatas,
  }) {
    return IntroInfo(
      dataId: dataId ?? this.dataId,
      level: level ?? this.level,
      category: category ?? this.category,
      cycle: cycle ?? this.cycle,
      sets: sets ?? this.sets,
      chapter: chapter ?? this.chapter,
      title: title ?? this.title,
      wordDatas: wordDatas ?? this.wordDatas,
    );
  }
}

class IntroInfoNotifier extends Notifier<IntroInfo> {
  @override
  IntroInfo build() => IntroInfo();

  void update({
    int? dataId,
    LEVEL? level,
    CATEGORY? category,
    int? cycle,
    int? sets,
    int? chapter,
    String? title,
    List<String>? wordDatas,
  }) {
    state = state.copyWith(
      dataId: dataId,
      level: level,
      category: category,
      cycle: cycle,
      sets: sets,
      chapter: chapter,
      title: title,
      wordDatas: wordDatas,
    );
  }

  void clear() {
    state = IntroInfo();
  }

  int? get dataId => state.dataId;
  int? get chapter => state.chapter;
}

/// 인트로 데이터 조회/수정 화면
/// 수정 -> 타이틀만 수정가능
///
final introProvider =
    NotifierProvider<IntroInfoNotifier, IntroInfo>(IntroInfoNotifier.new);
