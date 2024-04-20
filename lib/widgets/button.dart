import 'package:flutter/material.dart';

class filledButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final void Function() onPressed;

  const filledButton({
    super.key,
    required this.buttonName,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
        padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
      child: Text(
        buttonName,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      onPressed: () {
        onPressed();
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return const AlertDialog(
        //       title: Text('tapped!'),
        //     );
        //   },
        // );
      },
    );
  }
}
