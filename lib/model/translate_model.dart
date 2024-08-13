class TranslatedResponse {
  String? chinese;
  String? english;
  String? russian;
  String? vietnam;

  TranslatedResponse({
    required this.chinese,
    required this.english,
    required this.russian,
    required this.vietnam,
  });

  factory TranslatedResponse.fromJson(Map<String, dynamic> json) {
    return TranslatedResponse(
      chinese: json['chinese'],
      english: json['english'],
      russian: json['russian'],
      vietnam: json['vietnam'],
    );
  }
}
