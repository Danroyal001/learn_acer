import 'package:flutter/widgets.dart';
import '../dartvel_client/dartvel_client.dart';
import '../components/calculator_screen.dart';

@DVPage(
  title: 'Scientific calculator – Learn Acer',
  description: 'A free online scientific calculator for students: brackets, powers, roots, factorials, sin, cos, tan in degrees or radians, log and ln, with plain-English errors.',
)
Widget _calculatorPage(BuildContext context) => const CalculatorScreen();
