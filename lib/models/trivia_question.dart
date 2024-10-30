// lib/models/trivia_question.dart

class TriviaQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  TriviaQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    return TriviaQuestion(
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
    );
  }
}
