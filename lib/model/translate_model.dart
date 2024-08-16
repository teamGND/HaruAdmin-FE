class TranslatedResponse {
  String? korean;
  String? chinese;
  String? english;
  String? russian;
  String? vietnam;

  TranslatedResponse({
    required this.korean,
    required this.chinese,
    required this.english,
    required this.russian,
    required this.vietnam,
  });

  factory TranslatedResponse.fromJson(Map<String, dynamic> json) {
    return TranslatedResponse(
      korean: json['korean'],
      chinese: json['chinese'],
      english: json['english'],
      russian: json['russian'],
      vietnam: json['vietnam'],
    );
  }
}
