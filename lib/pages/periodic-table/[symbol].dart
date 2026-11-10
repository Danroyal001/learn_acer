import 'package:flutter/material.dart';

import '../../components/element_colours.dart';
import '../../components/ui.dart';
import '../../content/element.dart';
import '../../dartvel_client/dartvel_client.dart';

/// One element's page: its card, its numbers and a short summary.
@DVPage(
  title: 'Element – Learn Acer periodic table',
  description: 'An element of the periodic table: atomic number, atomic mass, electron configuration, shells, melting and boiling points, density and who discovered it.',
)
Widget _elementPage(BuildContext context) =>
    ElementScreen(symbol: context.dvParams['symbol'] ?? '');

class ElementScreen extends StatelessWidget {
  const ElementScreen({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final ChemicalElement? element = elementBySymbol(symbol);
    final Palette palette = Palette.of(context);
    if (element == null) {
      return PageColumn(
        children: <Widget>[
          const PageTitle(
            'No such element',
            lead: 'There is no element with that symbol.',
          ),
          RouteLink(
            'Back to the periodic table',
            to: DVRoutes.periodictable,
            tooltip: 'All 118 elements',
          ),
        ],
      );
    }
    final ChemicalElement? previous = elementByNumber(element.number - 1);
    final ChemicalElement? next = elementByNumber(element.number + 1);
    final List<(String, String)> facts = <(String, String)>[
      ('Atomic number', '${element.number}'),
      (
        'Atomic mass',
        element.atomicMass == null
            ? 'unknown'
            : '${trimNumber(element.atomicMass!)} u',
      ),
      ('Family', familyOf(element)),
      ('Group and period', 'Group ${element.group}, period ${element.period}'),
      ('Block', element.block == null ? 'unknown' : '${element.block}-block'),
      (
        'Electron configuration',
        element.electronConfiguration?.replaceFirst('*', '') ?? 'unknown',
      ),
      ('Electrons per shell', element.shells.join(', ')),
      ('State at room temperature', element.phase ?? 'unknown'),
      ('Melting point', kelvinToCelsius(element.meltKelvin)),
      ('Boiling point', kelvinToCelsius(element.boilKelvin)),
      (
        'Density',
        element.density == null
            ? 'unknown'
            : '${trimNumber(element.density!)} ${element.phase == 'Gas' ? 'g/L' : 'g/cm³'}',
      ),
      (
        'Electronegativity (Pauling)',
        element.electronegativity == null
            ? 'unknown'
            : trimNumber(element.electronegativity!),
      ),
      ('Discovered by', element.discoveredBy ?? 'unknown'),
      if (element.namedBy != null) ('Named by', element.namedBy!),
    ];
    return PageColumn(
      children: <Widget>[
        RouteLink(
          '← Periodic table',
          to: DVRoutes.periodictable,
          tooltip: 'All 118 elements',
          size: 15,
        ),
        const SizedBox(height: Space.md),
        Wrap(
          spacing: Space.xl,
          runSpacing: Space.lg,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              width: 132,
              height: 132,
              padding: const EdgeInsets.all(Space.md),
              decoration: BoxDecoration(
                color: familyColour(context, familyOf(element)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${element.number}',
                      style: textStyle(
                        context,
                        size: 16,
                        weight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          element.symbol,
                          style: displayStyle(context, size: 52),
                        ),
                      ),
                    ),
                    Text(
                      element.atomicMass == null
                          ? ''
                          : trimNumber(element.atomicMass!, digits: 3),
                      style: textStyle(context, size: 13),
                    ),
                  ],
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: PageTitle(
                element.name,
                lead: '${familyOf(element)}, atomic number ${element.number}.',
              ),
            ),
          ],
        ),
        if ((element.summary ?? '').isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(element.summary!, style: textStyle(context, size: 17)),
          ),
        const SectionTitle('Facts'),
        Panel(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.xl,
            vertical: Space.md,
          ),
          child: Column(
            children: <Widget>[
              for (final (String label, String value) in facts)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: Space.md),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: palette.rule)),
                  ),
                  child: MediaQuery.sizeOf(context).width < 600
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              label,
                              style: textStyle(
                                context,
                                size: 15,
                                color: palette.muted,
                              ),
                            ),
                            const SizedBox(height: Space.xs),
                            Text(
                              value,
                              style: textStyle(
                                context,
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 260,
                              child: Text(
                                label,
                                style: textStyle(
                                  context,
                                  size: 15,
                                  color: palette.muted,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                value,
                                style: textStyle(
                                  context,
                                  size: 16,
                                  weight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
        const SizedBox(height: Space.xl),
        Wrap(
          spacing: Space.xl,
          children: <Widget>[
            if (previous != null)
              RouteLink(
                '← ${previous.name}',
                to: DVRoutes.periodictableSymbol(
                  symbol: previous.symbol.toLowerCase(),
                ),
                tooltip: 'Element ${previous.number}',
              ),
            if (next != null)
              RouteLink(
                '${next.name} →',
                to: DVRoutes.periodictableSymbol(
                  symbol: next.symbol.toLowerCase(),
                ),
                tooltip: 'Element ${next.number}',
              ),
          ],
        ),
        if (element.source != null) ...<Widget>[
          const SizedBox(height: Space.lg),
          Tooltip(
            message: 'Read more on Wikipedia',
            excludeFromSemantics: true,
            child: DVNavLink.external(
              element.source!,
              semanticLabel: 'Read about ${element.name} on Wikipedia',
              padding: const EdgeInsets.symmetric(vertical: Space.md),
              child: Text(
                'Source: Wikipedia (CC BY-SA 3.0)',
                style: textStyle(
                  context,
                  size: 14,
                  color: palette.muted,
                ).copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

String trimNumber(double value, {int digits = 4}) {
  final String fixed = value.toStringAsFixed(digits);
  return fixed.contains('.')
      ? fixed.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
      : fixed;
}
