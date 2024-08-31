import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haru_admin/api/meta_grammar_services.dart';
import 'package:haru_admin/model/grammer_data_model.dart';
import 'package:haru_admin/provider/grammar_provider.dart';
import 'package:haru_admin/widgets/buttons.dart';

import '../../../model/meta_data_model.dart';

class MetaGrammarModal extends ConsumerStatefulWidget {
  MetaGrammarModal({
    super.key,
    required this.grammarId,
    required this.updateFunction,
  });

  int? grammarId;
  final Function updateFunction;

  @override
  ConsumerState<MetaGrammarModal> createState() => _MetaGrammarModalState();
}

class _MetaGrammarModalState extends ConsumerState<MetaGrammarModal> {
  final MetaGrammarDataRepository metaGrammarRepository =
      MetaGrammarDataRepository();

  static int MAX_META_GRAMMAR = 20;
  List<MetaGrammarData> metaGrammarDataList = [];
  final List<bool> _isSelected = List.filled(MAX_META_GRAMMAR, false);
  late Future metaGrammarFuture;

  getMetaGrammarList() async {
    try {
      await metaGrammarRepository
          .getMetaGrammerDataList(page: 0, size: MAX_META_GRAMMAR)
          .then((value) {
        setState(() {
          metaGrammarDataList = value.content;
        });
      });

      List<MetaGrammar>? selectedMetaGrammars =
          ref.read(grammarDataProvider.notifier).getMetaGrammars;
      if (selectedMetaGrammars == null) return;
      // 기존에 체크 한거 유지
      for (int i = 0; i < metaGrammarDataList.length; i++) {
        if (selectedMetaGrammars
            .any((element) => element.id == metaGrammarDataList[i].id)) {
          setState(() {
            _isSelected[i] = true;
          });
        }
      }
    } catch (e) {
      print("error : $e");
    }
  }

  void saveSelectedMetaGrammar(context) {
    List<MetaGrammar> selectedMetaGrammar = [];
    for (int i = 0; i < metaGrammarDataList.length; i++) {
      if (_isSelected[i] &&
          metaGrammarDataList[i].id != null &&
          metaGrammarDataList[i].title != null) {
        selectedMetaGrammar.add(MetaGrammar(
          id: metaGrammarDataList[i].id!,
          title: metaGrammarDataList[i].title!,
        ));
      }
    }

    widget.updateFunction(selectedMetaGrammar);

    Navigator.of(context).pop();
  }

  void cancel(context) {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    metaGrammarFuture = getMetaGrammarList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('메타 문법'),
      content: SingleChildScrollView(
        child: FutureBuilder(
            future: metaGrammarFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Column(
                // metaGrammarDataList and a checkbox
                children: List.generate(metaGrammarDataList.length, (index) {
                  return CheckboxListTile(
                    title: Text(metaGrammarDataList[index].title ?? ''),
                    value: _isSelected[index],
                    onChanged: (value) {
                      setState(() {
                        _isSelected[index] = value!;
                      });
                    },
                  );
                }),
              );
            }),
      ),
      actions: [
        MyCustomButton(
            text: '완료',
            onTap: () => saveSelectedMetaGrammar(context),
            color: Colors.blue),
        const SizedBox(
          height: 10,
        ),
        MyCustomButton(
            text: '취소', onTap: () => cancel(context), color: Colors.grey)
      ],
    );
  }
}

class DescriptionTableComponent extends StatelessWidget {
  const DescriptionTableComponent({
    super.key,
    required this.title,
    required this.textController,
  });

  final String title;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
              ),
              controller: textController,
            ),
          ),
        ],
      ),
    );
  }
}
