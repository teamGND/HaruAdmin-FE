import 'package:flutter/material.dart';
import 'package:haru_admin/widgets/button.dart';
import 'package:haru_admin/widgets/gaps.dart';

class PopupModal extends StatelessWidget {
  const PopupModal({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final String content;
  final List<ClickableButton> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      alignment: Alignment.center,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 300,
        ),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            Text(
              content,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
                top: 10,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions),
            ),
          ],
        ),
      ),
    );
  }
}
