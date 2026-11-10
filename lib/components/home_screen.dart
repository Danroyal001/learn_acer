import 'package:flutter/widgets.dart';

import 'ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// Home: what Learn Acer is for, and the five things it does.

/// The five things Learn Acer does: title, description, where it lives.
const List<(String, String, String)> homeFeatures = <(String, String, String)>[
  ('Classes', 'Start a class if you are a teacher; join one with its code if you are a student or a parent.', 'classes'),
  ('Learning aid', 'Notes, links and resources your teacher posts in the class, in one place.', 'classes'),
  ('Exam prep', 'Your teacher’s quizzes and quick practice sets, marked at once with a WAEC grade.', 'exam'),
  ('Periodic table', 'All 118 elements: mass, configuration, melting point and who discovered each one.', 'table'),
  ('Calculator', 'A scientific calculator with brackets, powers, roots and trigonometry, in degrees or radians.', 'calculator'),
];

DVRouteTarget homeRoute(String place) => switch (place) {
      'classes' => DVRoutes.classes,
      'exam' => DVRoutes.examprep,
      'table' => DVRoutes.periodictable,
      _ => DVRoutes.calculator,
    };

@DVFunctionalWidget()
Widget _homeScreen(BuildContext context) {
  final Palette palette = Palette.of(context);
  final double screen = MediaQuery.sizeOf(context).width;
  final bool wide = screen >= 760;
  // Two columns where they fit, inside the page's 1040 column and its margins.
  final double column = (screen < 1040 ? screen : 1040) - (screen < 600 ? 2 * Space.lg : 2 * Space.x2);
  final double cardWidth = wide ? (column - Space.lg) / 2 : column;
  return PageColumn(
    maxWidth: 1040,
    children: <Widget>[
      DVText('LEARN WITH EASE').modifier(DVModifier().fontFamily(textFont).fontSize(13).fontWeight(FontWeight.w700).letterSpacing(1.6).color(palette.margin).paddingOnly(bottom: Space.md)),
      const PageTitle(
        title: 'Your class, your notes and your exam practice, in one exercise book.',
        lead: 'Teachers start a class and read out a six-letter code. Students join, read the notes and take quizzes. Parents join the same class to see how their child is doing.',
      ),
      DVBox.wrapLine(<Widget>[
        PrimaryButton(label: 'Start or join a class', tooltip: 'Teachers start a class; students and parents join with a code', onTap: () => context.navigateToPage(DVRoutes.classes)),
        QuietButton(label: 'Practise for exams', tooltip: 'Quick practice sets with a WAEC grade at the end', onTap: () => context.navigateToPage(DVRoutes.examprep)),
      ], spacing: Space.md, crossAlign: DVCrossAlign.center),
      DVBox.wrapLine(<Widget>[
        for (final (String title, String description, String place) in homeFeatures)
          DVBox(HomeFeature(title: title, description: description, place: place), DVModifier().width(cardWidth)),
      ], spacing: Space.lg, crossAlign: DVCrossAlign.start, modifier: const DVModifier().paddingOnly(top: Space.x3)),
    ],
  );
}

@DVFunctionalWidget()
Widget _homeFeature(BuildContext context, {required String title, required String description, required String place}) => DVNavLink(
      to: homeRoute(place),
      preview: DVLinkPreview.none,
      semanticLabel: '$title. $description',
      child: Panel(
        spacing: Space.xs,
        children: <Widget>[
          SectionTitle(title: title, level: 2, size: 20),
          BodyText(text: description, size: 15, muted: true),
        ],
      ),
    );
