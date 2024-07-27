import 'package:flutter/material.dart';

class MetaGrammarModal extends StatelessWidget {
  const MetaGrammarModal({
    super.key,
  });

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
        TextButton(
          onPressed: () {
            // Perform the necessary actions when the user clicks on the "Add" button
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.blue),
          ),
          child: const Text(
            '추가',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.grey),
          ),
          child: const Text(
            '취소',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
