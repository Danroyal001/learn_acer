import 'package:flutter/widgets.dart';
import '../../dartvel_client/dartvel_client.dart';
import '../../components/element_screen.dart';

@DVPage(
  title: 'Element – Learn Acer periodic table',
  description: 'An element of the periodic table: atomic number, atomic mass, electron configuration, shells, melting and boiling points, density and who discovered it.',
)
Widget _elementPage(BuildContext context) => ElementScreen(symbol: context.dvParams['symbol'] ?? '');
