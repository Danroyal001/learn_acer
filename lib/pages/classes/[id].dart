import 'package:flutter/widgets.dart';
import '../../dartvel_client/dartvel_client.dart';
import '../../components/class_screen.dart';

@DVPage(
  title: 'Class – Learn Acer',
  description: 'A Learn Acer class: the teacher’s notes and links, quizzes, and the scores each person may see.',
)
Widget _classPage(BuildContext context) => ClassScreen(id: context.dvParams['id'] ?? '');
