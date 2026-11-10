import 'package:flutter/widgets.dart';
import '../dartvel_client/dartvel_client.dart';
import '../components/home_screen.dart';

@DVPage(
  title: 'Learn Acer: classes, exam practice, periodic table and calculator',
  description: 'Learn with ease at home or at school. Teachers start a class and share a code; students and parents join, read notes, take quizzes and practise for exams. Free periodic table and scientific calculator.',
)
Widget _indexPage(BuildContext context) => const HomeScreen();
