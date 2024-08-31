String? escapeJsonString(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAllMapped(RegExp(r'(?<!\\)\\'),
          (match) => '\\\\') // Avoid double escaping backslash
      .replaceAllMapped(RegExp(r'(?<!\\)"'),
          (match) => '\\"') // Avoid double escaping double quote
      .replaceAllMapped(RegExp(r'(?<!\\)\b'),
          (match) => '\\b') // Avoid double escaping backspace
      .replaceAllMapped(RegExp(r'(?<!\\)\f'),
          (match) => '\\f') // Avoid double escaping form feed
      .replaceAllMapped(RegExp(r'(?<!\\)\n'),
          (match) => '\\n') // Avoid double escaping newline
      .replaceAllMapped(RegExp(r'(?<!\\)\r'),
          (match) => '\\r') // Avoid double escaping carriage return
      .replaceAllMapped(
          RegExp(r'(?<!\\)\t'), (match) => '\\t') // Avoid double escaping tab
      .replaceAllMapped(RegExp(r'(?<!\\)\['),
          (match) => '\\[') // Avoid double escaping left square bracket
      .replaceAllMapped(RegExp(r'(?<!\\)\]'),
          (match) => '\\]') // Avoid double escaping right square bracket
      .replaceAllMapped(RegExp(r'(?<!\\)\{'),
          (match) => '\\{') // Avoid double escaping left curly brace
      .replaceAllMapped(RegExp(r'(?<!\\)\}'),
          (match) => '\\}') // Avoid double escaping right curly brace
      .replaceAllMapped(RegExp(r'(?<!\\)\('),
          (match) => '\\(') // Avoid double escaping left parenthesis
      .replaceAllMapped(RegExp(r'(?<!\\)\)'),
          (match) => '\\)') // Avoid double escaping right parenthesis
      .replaceAllMapped(RegExp(r'(?<!\\)\*'),
          (match) => '\\*') // Avoid double escaping asterisk
      .replaceAllMapped(
          RegExp(r'(?<!\\)\^'), (match) => '\\^') // Avoid double escaping caret
      .replaceAllMapped(RegExp(r'(?<!\\)\@'),
          (match) => '\\@') // Avoid double escaping at symbol
      .replaceAllMapped(RegExp(r'(?<!\\)\!'),
          (match) => '\\!') // Avoid double escaping exclamation mark
      .replaceAllMapped(RegExp(r'(?<!\\)\<'),
          (match) => '\\<') // Avoid double escaping less than symbol
      .replaceAllMapped(RegExp(r'(?<!\\)\>'),
          (match) => '\\>') // Avoid double escaping greater than symbol
      .replaceAllMapped(RegExp(r'(?<!\\)\#'),
          (match) => '\\#') // Avoid double escaping hash symbol
      .replaceAllMapped(RegExp(r'(?<!\\)\$'),
          (match) => '\\\$') // Avoid double escaping dollar sign
      .replaceAllMapped(RegExp(r'(?<!\\)\:'),
          (match) => '\\:'); // Avoid double escaping colon
}
