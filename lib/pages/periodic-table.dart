import 'package:flutter/widgets.dart';
import '../dartvel_client/dartvel_client.dart';
import '../components/periodic_table_screen.dart';

@DVPage(
  title: 'Periodic table: all 118 elements – Learn Acer',
  description: 'A free periodic table of all 118 elements with atomic mass, electron configuration, melting and boiling points and a short summary of each.',
)
Widget _periodicTablePage(BuildContext context) => const PeriodicTableScreen();
