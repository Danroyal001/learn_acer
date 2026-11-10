import 'package:flutter/widgets.dart';
import '../dartvel_client/dartvel_client.dart';
import '../components/exam_prep_screen.dart';

@DVPage(
  title: 'Exam practice – Learn Acer',
  description: 'Free exam practice for students: element symbols, times tables and mental maths, ten questions at a time, marked at once with a WAEC grade and the right answers.',
)
Widget _examPrepPage(BuildContext context) => const ExamPrepScreen();
