import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/model/grammer_data_model.dart';

class GrammarData {
  // [1] 제시문 - 대표문장 순서 '0'에 해당
  int? dialogueId;
  String? dialogue;
  String? dialogueEng;
  String? dialogueChn;
  String? dialogueVie;
  String? dialogueRus;

  // [2] 문법 설명
  String? description;
  String? descriptionEng;
  String? descriptionChn;
  String? descriptionVie;
  String? descriptionRus;
  String? grammarImageUrl;
  String? grammarAudioUrl;

  // [3] 메타 문법 ids
  List<MetaGrammar>? metaGrammars;

  GrammarData(
      {this.dialogueId,
      this.dialogue,
      this.dialogueEng,
      this.dialogueChn,
      this.dialogueVie,
      this.dialogueRus,
      this.description,
      this.descriptionEng,
      this.descriptionChn,
      this.descriptionVie,
      this.descriptionRus,
      this.grammarImageUrl,
      this.grammarAudioUrl,
      this.metaGrammars});

  GrammarData copyWith({
    int? dialogueId,
    String? dialogue,
    String? dialogueEng,
    String? dialogueChn,
    String? dialogueVie,
    String? dialogueRus,
    String? description,
    String? descriptionEng,
    String? descriptionChn,
    String? descriptionVie,
    String? descriptionRus,
    String? grammarImageUrl,
    String? grammarAudioUrl,
    List<MetaGrammar>? metaGrammars,
  }) {
    return GrammarData(
      dialogueId: dialogueId ?? this.dialogueId,
      dialogue: dialogue ?? this.dialogue,
      dialogueEng: dialogueEng ?? this.dialogueEng,
      dialogueChn: dialogueChn ?? this.dialogueChn,
      dialogueVie: dialogueVie ?? this.dialogueVie,
      dialogueRus: dialogueRus ?? this.dialogueRus,
      description: description ?? this.description,
      descriptionEng: descriptionEng ?? this.descriptionEng,
      descriptionChn: descriptionChn ?? this.descriptionChn,
      descriptionVie: descriptionVie ?? this.descriptionVie,
      descriptionRus: descriptionRus ?? this.descriptionRus,
      grammarImageUrl: grammarImageUrl ?? this.grammarImageUrl,
      grammarAudioUrl: grammarAudioUrl ?? this.grammarAudioUrl,
      metaGrammars: metaGrammars ?? this.metaGrammars,
    );
  }
}

class GrammarDataNotifier extends Notifier<GrammarData> {
  @override
  GrammarData build() => GrammarData();

  get getGrammarData => state;

  get getDialogueId => state.dialogueId;

  get getImageUrl => state.grammarImageUrl;

  get getAudioUrl => state.grammarAudioUrl;

  get getMetaGrammars => state.metaGrammars;

  updateDescriptionImageUrl(String? imageUrl) {
    state = state.copyWith(grammarImageUrl: imageUrl);
  }

  updateDialogueAudioUrl(String? audioUrl) {
    state = state.copyWith(grammarAudioUrl: audioUrl);
  }

  updateDialogue({
    int? dialogueId,
    String? dialogue,
    String? dialogueEng,
    String? dialogueChn,
    String? dialogueVie,
    String? dialogueRus,
  }) {
    state = state.copyWith(
      dialogueId: dialogueId,
      dialogue: dialogue,
      dialogueEng: dialogueEng,
      dialogueChn: dialogueChn,
      dialogueVie: dialogueVie,
      dialogueRus: dialogueRus,
    );
  }

  updateDescription({
    String? description,
    String? descriptionEng,
    String? descriptionChn,
    String? descriptionVie,
    String? descriptionRus,
    String? grammarImageUrl,
  }) {
    state = state.copyWith(
      description: description,
      descriptionEng: descriptionEng,
      descriptionChn: descriptionChn,
      descriptionVie: descriptionVie,
      descriptionRus: descriptionRus,
      grammarImageUrl: grammarImageUrl,
    );
  }

  updateMetaGrammars(List<MetaGrammar> metaGrammars) {
    state = state.copyWith(metaGrammars: metaGrammars);
  }
}

final grammarDataProvider =
    NotifierProvider<GrammarDataNotifier, GrammarData>(GrammarDataNotifier.new);
