import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/buttons.dart';

class MetaGrammarModal extends StatelessWidget {
  const MetaGrammarModal({
    super.key,
  });

  void addMetaGrammar(context) {
    Navigator.of(context).pop();
  }

  void cancel(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('메타 문법'),
      content: const SingleChildScrollView(
        child: Column(
          children: [
            // Add meta grammar form fields here
          ],
        ),
      ),
      actions: [
        MyCustomButton(
            text: '추가',
            onTap: () => addMetaGrammar(context),
            color: Colors.blue),
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
