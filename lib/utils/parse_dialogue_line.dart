import 'package:flutter/material.dart';

List<InlineSpan> parseDialogueLine(String line) {
  List<InlineSpan> spans = [];
  RegExp exp =
      RegExp(r'<(.*?)>|\[(.*?)\]|\*(.*?)\*|\{(.*?)\}|([^<>\[\]\*\{\}]+)');
  Iterable<RegExpMatch> matches = exp.allMatches(line);

  for (var match in matches) {
    if (match.group(0)!.startsWith('<') && match.group(0)!.endsWith('>')) {
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity, // Expand the container to full width
            child: Text(
              match.group(1)!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    } else if (match.group(0)!.startsWith('[') &&
        match.group(0)!.endsWith(']')) {
      spans.add(
        TextSpan(
          text: match.group(2),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        ),
      );
    } else if (match.group(0)!.startsWith('*') &&
        match.group(0)!.endsWith('*')) {
      spans.add(
        TextSpan(
          text: match.group(3),
          style: const TextStyle(color: Colors.red, fontSize: 11),
        ),
      );
    } else if (match.group(0)!.startsWith('{') &&
        match.group(0)!.endsWith('}')) {
      // Matching for the color codes inside {}
      String colorName = match.group(4)!;
      String imageName =
          'assets/images/character_$colorName.png'; // adjust the path as necessary
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Image.asset(
            imageName,
            width: 20, // adjust size as necessary
            height: 20,
          ),
        ),
      );
    } else {
      spans.add(
        TextSpan(
          text: match.group(0),
          style: const TextStyle(fontSize: 10),
        ),
      );
    }
  }
  return spans;
}
