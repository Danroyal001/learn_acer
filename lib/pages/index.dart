import 'package:flutter/material.dart';

import '../components/ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// Home: what Learn Acer is for, and the five things it does.
@DVPage(
  title: 'Learn Acer: classes, exam practice, periodic table and calculator',
  description: 'Learn with ease at home or at school. Teachers start a class and share a code; students and parents join, read notes, take quizzes and practise for exams. Free periodic table and scientific calculator.',
)
Widget _indexPage(BuildContext context) {
  final Palette palette = Palette.of(context);
  final bool wide = MediaQuery.sizeOf(context).width >= 760;
  return PageColumn(
    maxWidth: 1040,
    children: <Widget>[
      Text(
        'LEARN WITH EASE',
        style: textStyle(
          context,
          size: 13,
          weight: FontWeight.w700,
          color: palette.margin,
        ).copyWith(letterSpacing: 1.6),
      ),
      const SizedBox(height: Space.md),
      const PageTitle(
        'Your class, your notes and your exam practice, in one exercise book.',
        lead: 'Teachers start a class and read out a six-letter code. Students join, read the notes and take quizzes. Parents join the same class to see how their child is doing.',
      ),
      Wrap(
        spacing: Space.md,
        runSpacing: Space.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          PrimaryButton(
            'Start or join a class',
            icon: Icons.groups_outlined,
            tooltip:
                'Teachers start a class; students and parents join with a code',
            onPressed: () => context.navigateToPage(DVRoutes.classes),
          ),
          QuietButton(
            'Practise for exams',
            tooltip: 'Quick practice sets with a WAEC grade at the end',
            onPressed: () => context.navigateToPage(DVRoutes.examprep),
          ),
        ],
      ),
      const SizedBox(height: Space.x3),
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Wrap(
          spacing: Space.lg,
          runSpacing: Space.lg,
          children: <Widget>[
            for (final Widget card in <Widget>[
              HomeFeature(
                'Classes',
                'Start a class if you are a teacher; join one with its code if you are a student or a parent.',
                Icons.groups_outlined,
                DVRoutes.classes,
              ),
              HomeFeature(
                'Learning aid',
                'Notes, links and resources your teacher posts in the class, in one place.',
                Icons.menu_book_outlined,
                DVRoutes.classes,
              ),
              HomeFeature(
                'Exam prep',
                'Your teacher’s quizzes and quick practice sets, marked at once with a WAEC grade.',
                Icons.fact_check_outlined,
                DVRoutes.examprep,
              ),
              HomeFeature(
                'Periodic table',
                'All 118 elements: mass, configuration, melting point and where each one is found.',
                Icons.science_outlined,
                DVRoutes.periodictable,
              ),
              HomeFeature(
                'Calculator',
                'A scientific calculator with brackets, powers, roots and trigonometry, in degrees or radians.',
                Icons.calculate_outlined,
                DVRoutes.calculator,
              ),
            ])
              SizedBox(
                width: wide
                    ? (constraints.maxWidth - Space.lg) / 2
                    : constraints.maxWidth,
                child: card,
              ),
          ],
        ),
      ),
    ],
  );
}

class HomeFeature extends StatelessWidget {
  const HomeFeature(this.title, this.description, this.icon, this.to);

  final String title;
  final String description;
  final IconData icon;
  final DVRouteTarget to;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Tooltip(
      message: 'Open $title',
      excludeFromSemantics: true,
      child: DVNavLink(
        to: to,
        preview: DVLinkPreview.none,
        semanticLabel: '$title. $description',
        child: Panel(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: palette.accent),
              ),
              const SizedBox(width: Space.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: displayStyle(context, size: 20)),
                    const SizedBox(height: Space.xs),
                    Text(
                      description,
                      style: textStyle(context, size: 15, color: palette.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
