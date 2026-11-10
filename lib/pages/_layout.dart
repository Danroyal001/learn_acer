import 'package:flutter/material.dart';

import '../components/ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// Every page sits between the header and the footer and scrolls as one
/// document, on paper with a red margin line (yellow chalk in the dark).
class Layout extends DartvelLayout {
  const Layout({super.key, required super.child});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: palette.page,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _Header(),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: palette.margin.withValues(alpha: 0.55), width: MediaQuery.sizeOf(context).width < 600 ? 3 : 4)),
                ),
                child: ConstrainedBox(constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.7), child: child),
              ),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

const List<(String, String)> _sections = <(String, String)>[
  ('Classes', 'Start a class or join one with a code'),
  ('Exam prep', 'Practise and see your scores'),
  ('Periodic table', 'All 118 elements'),
  ('Calculator', 'A scientific calculator'),
];

DVRouteTarget _routeFor(String label) => switch (label) {
      'Classes' => DVRoutes.classes,
      'Exam prep' => DVRoutes.examprep,
      'Periodic table' => DVRoutes.periodictable,
      _ => DVRoutes.calculator,
    };

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final bool narrow = MediaQuery.sizeOf(context).width < 1000;
    return Container(
      decoration: BoxDecoration(color: palette.surface, border: Border(bottom: BorderSide(color: palette.rule))),
      padding: EdgeInsets.symmetric(horizontal: narrow ? Space.lg : Space.x2, vertical: Space.sm),
      child: Row(
        children: <Widget>[
          Tooltip(
            message: 'Learn Acer home',
            excludeFromSemantics: true,
            child: DVNavLink(
              to: DVRoutes.index,
              preview: DVLinkPreview.none,
              semanticLabel: 'Learn Acer home',
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset('assets/icon.png', width: 32, height: 32, excludeFromSemantics: true),
                  const SizedBox(width: Space.sm),
                  Text('Learn Acer', style: displayStyle(context, size: 21)),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (narrow)
            PopupMenuButton<String>(
              tooltip: 'Open menu',
              icon: Icon(Icons.menu, color: palette.ink),
              onSelected: (String label) => context.navigateToPage(_routeFor(label)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                for (final (String label, String _) in _sections) PopupMenuItem<String>(value: label, child: Text(label, style: textStyle(context))),
              ],
            )
          else
            for (final (String label, String hint) in _sections)
              Padding(
                padding: const EdgeInsets.only(left: Space.lg),
                child: Tooltip(
                  message: hint,
                  excludeFromSemantics: true,
                  child: DVNavLink(
                    to: _routeFor(label),
                    preview: DVLinkPreview.none,
                    semanticLabel: label,
                    padding: const EdgeInsets.symmetric(vertical: Space.md),
                    child: Text(label, style: textStyle(context, size: 15, weight: FontWeight.w600)),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: palette.rule))),
      padding: const EdgeInsets.symmetric(horizontal: Space.x2, vertical: Space.xl),
      child: Wrap(
        spacing: Space.xl,
        runSpacing: Space.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text('Learn Acer: learn with ease, at school or at home.', style: textStyle(context, size: 14, color: palette.muted)),
          Tooltip(
            message: 'The licence of the element data',
            excludeFromSemantics: true,
            child: DVNavLink.external(
              'https://creativecommons.org/licenses/by-sa/3.0/',
              semanticLabel: 'Element data from Wikipedia, CC BY-SA 3.0',
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              child: Text('Element data: Wikipedia, CC BY-SA 3.0', style: textStyle(context, size: 14, color: palette.muted).copyWith(decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}
