String convertWordListToString({
  required title,
  required List<String>? words,
}) {
  String result = title.trim() + ' [';
  if (words != null) {
    for (var i = 0; i < words.length; i++) {
      result += words[i];
      if (i < words.length - 1) {
        result += ', ';
      }
    }
  }
  result += ']';
  return result;
}

List<String>? convertWordStringToList({
  required String title,
}) {
  final start = title.indexOf('[');
  final end = title.indexOf(']');
  final wordList =
      (start + 1 == end) ? null : title.substring(start + 1, end).split(', ');
  return wordList;
}

String convertWordStringToTitle({
  required String title,
}) {
  final start = title.indexOf('[');
  return title.substring(0, start).trim();
}
