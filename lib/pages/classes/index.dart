import 'package:flutter/widgets.dart';
import '../../dartvel_client/dartvel_client.dart';
import '../../components/classes_screen.dart';

@DVPage(
  title: 'Your classes – Learn Acer',
  description: 'Start a class as a teacher and share its code, or join one as a student or parent.',
)
Widget _classesPage(BuildContext context) => const ClassesScreen();
