import 'package:flutter/widgets.dart';
import '../../dartvel_client/dartvel_client.dart';
import '../../components/quiz_screen.dart';

@DVPage(
  title: 'Quiz – Learn Acer',
  description: 'A class quiz on Learn Acer, marked at once with a WAEC grade and the right answers.',
)
Widget _quizPage(BuildContext context) => QuizScreen(id: context.dvParams['id'] ?? '');
