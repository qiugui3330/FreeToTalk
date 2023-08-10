class Word {
  final int? id;
  final int? wordbookId;
  final String word;
  final String translation;
  final DateTime addDate;
  int practiceTimes;
  bool mastered;
  final String originalSentence;

  Word({
    this.id,
    this.wordbookId,
    required this.word,
    required this.translation,
    required this.addDate,
    this.practiceTimes = 0,
    this.mastered = false,
    required this.originalSentence,
  });

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'translation': translation,
      'addDate': addDate.toIso8601String(),
      'practiceTimes': practiceTimes,
      'mastered': mastered ? 1 : 0,
      'originalSentence': originalSentence,
    };
  }
}
