import 'package:flutter/material.dart';

List<InlineSpan> parseDialogueLine(String line) {
  List<InlineSpan> spans = [];
  RegExp exp =
      RegExp(r'<(.*?)>|\[(.*?)\]|\*(.*?)\*|\{(.*?)\}|([^<>\[\]\*\{\}\\]+)');
  Iterable<RegExpMatch> matches = exp.allMatches(line);
  const double defaultFontSize = 16.0;

  for (var match in matches) {
    String? matchedText = match.group(0);

    if (matchedText!.startsWith('<') && matchedText.endsWith('>')) {
      // Handle `<...>` with `\` for new lines
      List<String> parts = match.group(1)!.split(r'\');
      for (int i = 0; i < parts.length; i++) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity, // Expand the container to full width
              child: Text(
                parts[i],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
          ),
        );

        // Add a newline if it's not the last part
        if (i < parts.length - 1) {
          spans.add(const TextSpan(text: '\n'));
        }
      }
      spans.add(const TextSpan(text: '\n\n'));
    } else if (matchedText.startsWith('[') && matchedText.endsWith(']')) {
      spans.add(
        TextSpan(
          text: match.group(2),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: defaultFontSize,
          ),
        ),
      );
    } else if (matchedText.startsWith('*') && matchedText.endsWith('*')) {
      spans.add(
        TextSpan(
          text: match.group(3),
          style: const TextStyle(
            color: Colors.red,
            fontSize: defaultFontSize,
            height: 1.5,
          ),
        ),
      );
    } else if (matchedText.startsWith('{') && matchedText.endsWith('}')) {
      String characterName = match.group(4)!;
      String imageName = 'assets/images/character_$characterName.png';
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imageName,
              width: 24,
              height: 24,
            ),
          ),
        ),
      );
    } else {
      spans.add(
        TextSpan(
          text: matchedText,
          style: const TextStyle(
              fontSize: defaultFontSize,
              height: 1.5,
              fontWeight: FontWeight.w500),
        ),
      );
    }
  }
  return spans;
}

RichText getExampleSentence(String kor) {
  List<InlineSpan> spans = [];
  final regex = RegExp(r'\[(.*?)\]'); // Matches text inside [ ]

  int lastMatchEnd = 0;

  for (final match in regex.allMatches(kor)) {
    // Add the part before the [ ... ] as black text
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(
        text: kor.substring(lastMatchEnd, match.start),
        style: const TextStyle(color: Colors.black),
      ));
    }

    // Add the part inside [ ... ] as blue text
    spans.add(TextSpan(
      text: match.group(1), // This is the text inside [ ... ]
      style: const TextStyle(
        color: Color(0xFF00A1F8),
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ));

    lastMatchEnd = match.end;
  }

  // Add any remaining text after the last match as black text
  if (lastMatchEnd < kor.length) {
    spans.add(TextSpan(
      text: kor.substring(lastMatchEnd),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ));
  }

  return RichText(
    text: TextSpan(
      children: spans,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

List<InlineSpan> parseDescriptionLine(String line) {
  List<InlineSpan> spans = [];
  RegExp exp = RegExp(
      r'<(.*?)>|\[(.*?)\]|\{(.*?)\}|\@(.*?)\@|\^\^(.*?)\^\^|([^\<\>\[\]\{\}\@\^\^]+)');
  Iterable<RegExpMatch> matches = exp.allMatches(line);
  const double defaultFontSize = 16.0;

  bool hasNumberPrefix = false;

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
          style: const TextStyle(
            color: Color(0xFF00A1F8),
            fontSize: defaultFontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else if (match.group(0)!.startsWith('{') &&
        match.group(0)!.endsWith('}')) {
      String innerText = match.group(3)!;
      List<InlineSpan> innerSpans = [];
      RegExp innerExp = RegExp(r'\[(.*?)\]|([^\[\]]+)');
      Iterable<RegExpMatch> innerMatches = innerExp.allMatches(innerText);

      for (var innerMatch in innerMatches) {
        if (innerMatch.group(0)!.startsWith('[') &&
            innerMatch.group(0)!.endsWith(']')) {
          innerSpans.add(
            TextSpan(
              text: innerMatch.group(1),
              style: const TextStyle(
                color: Color(0xFF00A1F8),
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          innerSpans.add(
            TextSpan(
              text: innerMatch.group(0),
              style: const TextStyle(
                color: Color(0xFF959595),
                fontSize: defaultFontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }
      }

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                width: 26,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFB1B1B1),
                ),
                child: const Center(
                  child: Text(
                    'ex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              RichText(text: TextSpan(children: innerSpans)),
            ],
          ),
        ),
      );
    } else if (match.group(0)!.startsWith('@') &&
        match.group(0)!.endsWith('@')) {
      hasNumberPrefix = true;
      String number = match.group(4)!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00A1F8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: defaultFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (match.group(0)!.startsWith('^^') &&
        match.group(0)!.endsWith('^^')) {
      spans.add(
        TextSpan(
          text: match.group(5),
          style: const TextStyle(
            backgroundColor: Color(0xFF5BD1FF),
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: defaultFontSize,
          ),
        ),
      );
    } else {
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            fontSize: defaultFontSize,
            fontWeight: hasNumberPrefix ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      );
      if (match.group(0)!.contains('\n')) {
        hasNumberPrefix = false; // Reset font weight after a new line
      }
    }
  }
  return spans;
}
