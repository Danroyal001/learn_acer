// The periodic table's family colours: soft tints dark ink reads on (light),
// muted chalk tones light text reads on (dark).
import 'package:flutter/material.dart';

import 'ui.dart';

const List<String> elementFamilies = <String>[
  'Alkali metal',
  'Alkaline earth metal',
  'Transition metal',
  'Post-transition metal',
  'Metalloid',
  'Nonmetal',
  'Noble gas',
  'Lanthanide',
  'Actinide',
  'Unknown properties',
];

Color familyColour(BuildContext context, String family) {
  final bool dark = Palette.of(context).dark;
  return switch (family) {
    'Alkali metal' => dark ? const Color(0xFF6B3A3A) : const Color(0xFFFFD6D1),
    'Alkaline earth metal' => dark ? const Color(0xFF6B4E2E) : const Color(0xFFFFE3BF),
    'Transition metal' => dark ? const Color(0xFF5E5A2C) : const Color(0xFFFFF2B3),
    'Post-transition metal' => dark ? const Color(0xFF2F5A3E) : const Color(0xFFD4F2DC),
    'Metalloid' => dark ? const Color(0xFF2E5658) : const Color(0xFFCDEEEF),
    'Nonmetal' => dark ? const Color(0xFF2C4867) : const Color(0xFFD5E5FB),
    'Noble gas' => dark ? const Color(0xFF4A3B6B) : const Color(0xFFE5DBFB),
    'Lanthanide' => dark ? const Color(0xFF66385A) : const Color(0xFFF9D6EE),
    'Actinide' => dark ? const Color(0xFF5A3448) : const Color(0xFFF3D3E1),
    _ => dark ? const Color(0xFF3C4642) : const Color(0xFFE6E8EA),
  };
}
