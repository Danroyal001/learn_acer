// The header with its menu, and the footer, on every page.
import 'package:flutter/widgets.dart';

import '../dartvel_client/dartvel_client.dart';
import 'ui.dart';

/// The sections, each with the hint its link shows.
const List<(String, String)> siteSections = <(String, String)>[
  ('Classes', 'Start a class or join one with a code'),
  ('Exam prep', 'Practise and see your scores'),
  ('Periodic table', 'All 118 elements'),
  ('Calculator', 'A scientific calculator'),
];

DVRouteTarget routeForSection(String label) => switch (label) {
      'Classes' => DVRoutes.classes,
      'Exam prep' => DVRoutes.examprep,
      'Periodic table' => DVRoutes.periodictable,
      _ => DVRoutes.calculator,
    };

@DVFunctionalWidget()
Widget _siteHeader(BuildContext context) {
  final Palette palette = Palette.of(context);
  final bool narrow = MediaQuery.sizeOf(context).width < 1000;
  final DVSignal<bool> menuOpen = context.signal(false);
  final Widget brand = DVNavLink(
    to: DVRoutes.index,
    preview: DVLinkPreview.none,
    semanticLabel: 'Learn Acer home',
    padding: const EdgeInsets.symmetric(vertical: Space.md),
    child: DVBox.row(<Widget>[
      DVBox.image(const DVImage.asset('assets/icon.png', alt: ''), width: 32, height: 32),
      DVText('Learn Acer').modifier(DVModifier().fontFamily(displayFont).fontSize(21).lineHeight(1.5).color(palette.ink).tooltip('Learn Acer home')),
    ], spacing: Space.sm, crossAlign: DVCrossAlign.start),
  );
  Widget link(String label, String hint) => DVNavLink(
        to: routeForSection(label),
        preview: DVLinkPreview.none,
        semanticLabel: label,
        padding: const EdgeInsets.symmetric(vertical: Space.md),
        child: DVText(label).modifier(DVModifier().fontFamily(textFont).fontSize(15).fontWeight(FontWeight.w600).color(palette.ink).tooltip(hint)),
      );
  return DVBox.list(<Widget>[
    DVBox.row(<Widget>[
      brand,
      if (narrow)
        DVText(menuOpen.value ? 'Close' : 'Menu').modifier(
          DVModifier()
              .fontFamily(textFont)
              .fontSize(15)
              .fontWeight(FontWeight.w700)
              .color(palette.accent)
              .paddingSymmetric(horizontal: Space.md, vertical: Space.md)
              .minimumTapTarget()
              .tooltip(menuOpen.value ? 'Close the menu' : 'Open the menu')
              .onTap(() => menuOpen.value = !menuOpen.read()),
        )
      else
        DVBox.row(<Widget>[for (final (String label, String hint) in siteSections) link(label, hint)], spacing: Space.xl),
    ], align: DVAlign.spaceBetween),
    if (narrow && menuOpen.value) DVBox.list(<Widget>[for (final (String label, String hint) in siteSections) link(label, hint)], spacing: 0),
  ], spacing: 0, modifier: DVModifier().backgroundColor(palette.surface).border(Border(bottom: BorderSide(color: palette.rule))).paddingSymmetric(horizontal: narrow ? Space.lg : Space.x2, vertical: Space.sm));
}

@DVFunctionalWidget()
Widget _siteFooter(BuildContext context) {
  final Palette palette = Palette.of(context);
  return DVBox.wrapLine(<Widget>[
    const BodyText(text: 'Learn Acer: learn with ease, at school or at home.', size: 14, muted: true),
    const OutLink(label: 'Element data: Wikipedia, CC BY-SA 3.0', url: 'https://creativecommons.org/licenses/by-sa/3.0/', tooltip: 'The licence of the element data', size: 14, muted: true),
  ], spacing: Space.xl, crossAlign: DVCrossAlign.center, modifier: DVModifier().border(Border(top: BorderSide(color: palette.rule))).paddingSymmetric(horizontal: Space.x2, vertical: Space.xl));
}
