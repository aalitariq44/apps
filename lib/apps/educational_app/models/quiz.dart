class Quiz {
  final String id;
  final String title;
  final String courseId;
  final List<Question> questions;
  final int timeLimit; // in minutes
  final int passingScore;

  Quiz({
    required this.id,
    required this.title,
    required this.courseId,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
  });

  static List<Quiz> getDummyQuizzes() {
    return [
      Quiz(
        id: '1',
        title: 'Flutter Basics Quiz',
        courseId: '1',
        timeLimit: 15,
        passingScore: 70,
        questions: [
          Question(
            id: '1',
            text: 'What is Flutter?',
            options: [
              'A UI toolkit for building natively compiled applications',
              'A programming language',
              'A database management system',
              'A web browser'
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            id: '2',
            text: 'Which programming language does Flutter use?',
            options: ['Java', 'Swift', 'Dart', 'JavaScript'],
            correctAnswerIndex: 2,
          ),
          Question(
            id: '3',
            text: 'Flutter apps are compiled to:',
            options: ['Bytecode', 'Native code', 'Interpreted code', 'Web assembly'],
            correctAnswerIndex: 1,
          ),
        ],
      ),
      Quiz(
        id: '2',
        title: 'UI/UX Design Quiz',
        courseId: '2',
        timeLimit: 20,
        passingScore: 75,
        questions: [
          Question(
            id: '4',
            text: 'What does UX stand for?',
            options: ['User Experience', 'User Extension', 'Universal Experience', 'User Execution'],
            correctAnswerIndex: 0,
          ),
          Question(
            id: '5',
            text: 'Which color combination provides the best contrast?',
            options: ['Red and green', 'Black and white', 'Blue and purple', 'Yellow and orange'],
            correctAnswerIndex: 1,
          ),
        ],
      ),
    ];
  }
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizResult {
  final String quizId;
  final int score;
  final int totalQuestions;
  final List<int> userAnswers;
  final DateTime completedAt;

  QuizResult({
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.completedAt,
  });

  double get percentage => (score / totalQuestions) * 100;
  bool get passed => percentage >= 70; // Assuming 70% is passing score
}
