import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/model/test_data_model.dart';
import 'package:haru_admin/utils/convert_problem_list.dart';
import 'package:haru_admin/utils/enum_type.dart';

import '../api/test_data_services.dart';
import '../utils/generate_word_quiz.dart';
import 'intro_provider.dart';

final testProvider = StateNotifierProvider<TestStateNotifier, TestState>(
  (ref) => TestStateNotifier(
    testDataRepository: ref.watch(testDataRepositoryProvider),
    intro: ref.watch(introProvider),
    ref: ref,
  ),
);

class TestState {
  final IntroInfo info;
  final List<String> exampleData;
  final List<ProblemDataModel> problemList;
  final List<ProblemDataModel> previousProblemList;
  final bool isLoading;
  final int focusedProbelmIdx;
  final int focusedColumnIdx;

  const TestState({
    required this.problemList,
    required this.isLoading,
    required this.info,
    required this.previousProblemList,
    required this.exampleData,
    this.focusedProbelmIdx = -1,
    this.focusedColumnIdx = -1,
  });

  // copy with
  TestState copyWith({
    List<ProblemDataModel>? problemList,
    bool? isLoading,
    IntroInfo? info,
    List<ProblemDataModel>? previousProblemList,
    List<String>? exampleData,
    int? focusedProbelmIdx,
    int? focusedColumnIdx,
  }) {
    return TestState(
      problemList: problemList ?? this.problemList,
      isLoading: isLoading ?? this.isLoading,
      info: info ?? this.info,
      previousProblemList: previousProblemList ?? this.previousProblemList,
      exampleData: exampleData ?? this.exampleData,
      focusedProbelmIdx: focusedProbelmIdx ?? this.focusedProbelmIdx,
      focusedColumnIdx: focusedColumnIdx ?? this.focusedColumnIdx,
    );
  }
}

class TestStateNotifier extends StateNotifier<TestState> {
  final TestDataRepository testDataRepository;
  final StateNotifierProviderRef<TestStateNotifier, TestState> ref;
  final IntroInfo intro;

  TestStateNotifier({
    required this.testDataRepository,
    required this.ref,
    required this.intro,
  }) : super(TestState(
          problemList: [],
          isLoading: false,
          info: IntroInfo(
            dataId: null,
            level: LEVEL.LEVEL1,
            cycle: null,
            sets: null,
            chapter: null,
            category: CATEGORY.TEST,
            title: '',
          ),
          previousProblemList: [],
          exampleData: [],
        )) {
    // 데이터 불러오기
    fetchTestData(
        categ: intro.category.toString().split('.').last,
        id: intro.dataId.toString());
  }

  String get level => state.info.level == null
      ? ''
      : state.info.level.toString().split('.').last;
  String get cycle =>
      state.info.cycle == null ? '' : state.info.cycle.toString();
  String get sets => state.info.sets == null ? '' : state.info.sets.toString();
  String get chapter =>
      state.info.chapter == null ? '' : state.info.chapter.toString();
  String get category => state.info.category == null
      ? ''
      : state.info.category.toString().split('.').last;
  String get title => state.info.title == null ? '' : state.info.title!;

  // 데이터 불러오기
  Future<void> fetchTestData({
    required String? categ, // category
    required String? id, // introId
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      if (categ == null || id == null) {
        return;
      }
      // 데이터 넣기
      await testDataRepository.getTestData(id: id).then((value) {
        List<ProblemDataModel>? tempList = value.problemList;
        if (tempList != null) {
          tempList.sort((a, b) => a.sequence.compareTo(b.sequence));
        }

        // tempList set valu.sets'
        tempList?.forEach((element) {
          element.sets = value.set;
        });

        // '<' 포함하는 예문은 제외, 문법 케이스에서
        List<String> exmapleSentences = value.exampleList.where((element) {
          return !element.contains('<');
        }).toList();

        state = state.copyWith(
          isLoading: false,
          exampleData: exmapleSentences,
          problemList: tempList ?? [],
          info: IntroInfo(
            dataId: int.parse(id),
            category: categoryFromString(categ),
            level: levelFromString(value.level),
            cycle: value.cycle,
            sets: value.set,
            chapter: value.chapter,
            title: value.title,
          ),
        );
      });
    } catch (e) {
      print(e);
    }
    state = state.copyWith(isLoading: false);

    return;
  }

  clickProblemColumn({
    required int problemIdx,
    required int columnIdx,
  }) {
    state = state.copyWith(
      focusedProbelmIdx: problemIdx,
      focusedColumnIdx: columnIdx,
    );
  }

  updateProblemTexts({
    required int problemIdx,
    required List<String?> problemTexts,
  }) {
    state.problemList[problemIdx] = convertListToProblemContents(
            contents: problemTexts,
            frameModel: state.problemList[problemIdx]) ??
        state.problemList[problemIdx];
  }

  // 단어 문제 자동 생성
  Future<void> createWordProblem({
    required List<int> wordTypes,
  }) async {
    state = state.copyWith(isLoading: true);

    List<ProblemDataModel> problems = generateWordQuiz(
      words: state.exampleData,
      wordsTypes: wordTypes,
      frameModel: ProblemDataModel(
        sequence: 0, // 덮어씌우기
        problemType: 101, // 덮어씌우기
        level: state.info.level.toString().split('.').last,
        category: 'WORD',
        cycle: state.info.cycle,
        sets: state.info.sets,
        chapter: state.info.chapter,
      ),
    );

    // 문제 덮어씌우기
    state = state.copyWith(problemList: problems);

    try {
      await testDataRepository.postTestData(testDataList: problems);
    } catch (e) {
      print(e);
    }

    state = state.copyWith(isLoading: false);
  }

  // 이전 문제들 중 선택된 문제들 추가하기

  // 저장
  Future<void> save({
    required bool isFinal,
  }) async {
    state = state.copyWith(isLoading: true);

    print(state.problemList);

    try {
      await testDataRepository.postTestData(testDataList: state.problemList);

      if (isFinal) {
        await testDataRepository.approveTest(
          level: state.info.level.toString().split('.').last,
          cycle: state.info.cycle!,
          set: state.info.sets!,
          chapter: state.info.chapter!,
        );
      }
    } catch (e) {
      throw Exception(e);
    }

    state = state.copyWith(isLoading: false);
  }

  // 문제 순서 바꾸기
  void reorderProblemOrder({
    required int oldIndex,
    required int newIndex,
  }) {
    // sequence 변경
    for (var i = 0; i < state.problemList.length; i++) {
      if (i == oldIndex) {
        state.problemList[i] = state.problemList[i].copyWith(
          sequence: newIndex + 1,
        );
      } else if (oldIndex < newIndex) {
        if (i > oldIndex && i <= newIndex) {
          state.problemList[i] = state.problemList[i].copyWith(
            sequence: i,
          );
        }
      } else {
        if (i < oldIndex && i >= newIndex) {
          state.problemList[i] = state.problemList[i].copyWith(
            sequence: i + 2,
          );
        }
      }
    }

    final item = state.problemList.removeAt(oldIndex);
    state.problemList.insert(newIndex, item);
  }

  // 새로 문제 추가
  void addNewProblem({
    required int problemType,
  }) {
    if (problemType == 0) {
      return;
    }
    int len = state.problemList.length;
    state = state.copyWith(
      problemList: [
        ...state.problemList,
        ProblemDataModel(
          sequence: len + 1,
          problemType: problemType,
          level: state.info.level.toString().split('.').last,
          category: state.info.category.toString().split('.').last,
          cycle: state.info.cycle,
          sets: state.info.sets,
          chapter: state.info.chapter,
        ),
      ],
    );
  }

  Future<void> fetchPreviousTestData() async {
    try {
      if ((state.info.category != CATEGORY.TEST &&
              state.info.category != CATEGORY.MIDTERM) ||
          state.info.category == null ||
          state.info.cycle == null ||
          state.info.sets == null) {
        return;
      }
      if (state.info.category == CATEGORY.TEST) {
        await testDataRepository
            .getCurrentSetsTest(
          level: state.info.level.toString().split('.').last,
          cycle: state.info.cycle!,
          set: state.info.sets!,
        )
            .then((value) {
          state = state.copyWith(previousProblemList: value);
        });
      } else if (state.info.category == CATEGORY.TEST) {
        await testDataRepository
            .getCurrentCycleTest(
          level: state.info.level.toString().split('.').last,
          cycle: state.info.cycle!,
        )
            .then((value) {
          state = state.copyWith(previousProblemList: value);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void saveSelectPreviousTestProblems({
    required List<bool> selectedPrevious,
  }) {
    List<ProblemDataModel> selectedPreviousData = [];
    for (var i = 0; i < state.previousProblemList.length; i++) {
      if (selectedPrevious[i]) {
        selectedPreviousData.add(state.previousProblemList[i].copyWith(
            id: null,
            level: state.info.level.toString().split('.').last,
            category: state.info.category.toString().split('.').last,
            cycle: state.info.cycle,
            sets: state.info.sets,
            chapter: state.info.chapter,
            sequence: state.problemList.length + 1 + i));
      }
    }
    // 선택된 문제들을 _problemList에 추가
    state = state.copyWith(
      problemList: [...state.problemList, ...selectedPreviousData],
    );
  }

  String getSelectedProblems({required List<bool> selected}) {
    return state.problemList.fold(
        "",
        (previousValue, element) =>
            previousValue +
            (selected[state.problemList.indexOf(element)]
                ? '${state.problemList.indexOf(element) + 1} 번\n'
                : ''));
  }

  deleteSelected({required List<bool> selected}) async {
    if (state.problemList.isEmpty) {
      return;
    }
    List<ProblemDataModel> newProblemList = [];
    List<int> selectedProblemIds = [];
    int len = 1;
    for (int idx = 0; idx < state.problemList.length; idx++) {
      if (selected[idx] && state.problemList[idx].id != null) {
        selectedProblemIds.add(state.problemList[idx].id!);
      }
      if (!selected[idx]) {
        newProblemList.add(state.problemList[idx].copyWith(
          sequence: len,
        ));
        len++;
      }
    }

    for (var id in selectedProblemIds) {
      await testDataRepository.deleteTest(id: id);
    }

    state = state.copyWith(problemList: newProblemList);
  }
}
