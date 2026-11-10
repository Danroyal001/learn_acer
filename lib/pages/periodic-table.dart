import 'package:flutter/material.dart';

import '../components/element_colours.dart';
import '../components/ui.dart';
import '../content/element.dart';
import '../content/elements.g.dart';
import '../dartvel_client/dartvel_client.dart';

/// The periodic table: the real 18-column table where it fits, a searchable
/// list on a phone. Each element opens its own page.
@DVPage(
  title: 'Periodic table: all 118 elements – Learn Acer',
  description: 'A free periodic table of all 118 elements with atomic mass, electron configuration, melting and boiling points and a short summary of each.',
)
Widget _periodicTablePage(BuildContext context) => const PeriodicTableScreen();

class PeriodicTableScreen extends StatefulWidget {
  const PeriodicTableScreen();

  @override
  State<PeriodicTableScreen> createState() => PeriodicTableScreenState();
}

class PeriodicTableScreenState extends State<PeriodicTableScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool grid = width >= 900;
    final List<ChemicalElement> found = searchElements(_search.text);
    return PageColumn(
      maxWidth: 1240,
      children: <Widget>[
        const PageTitle('Periodic table', lead: 'All 118 elements. Search by name, symbol or atomic number, or open any element for its details.'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: LabelledField(label: 'Find an element', controller: _search, hint: 'Iron, Fe or 26'),
        ),
        if (_search.text.trim().isNotEmpty) ...<Widget>[
          if (found.isEmpty) Text('No element matches "${_search.text.trim()}".', style: textStyle(context, color: Palette.of(context).muted)),
          for (final ChemicalElement element in found.take(8)) _ElementRow(element),
          const SizedBox(height: Space.xl),
        ],
        const _Legend(),
        const SizedBox(height: Space.lg),
        if (grid) const _Grid() else ...<Widget>[for (final ChemicalElement element in elements) _ElementRow(element)],
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: Space.md,
        runSpacing: Space.sm,
        children: <Widget>[
          for (final String family in elementFamilies)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(width: 14, height: 14, decoration: BoxDecoration(color: familyColour(context, family), borderRadius: BorderRadius.circular(3))),
                const SizedBox(width: Space.xs),
                Text(family, style: textStyle(context, size: 13, color: Palette.of(context).muted)),
              ],
            ),
        ],
      );
}

/// The 18 x 10 table, rows 9 and 10 holding the lanthanides and actinides.
class _Grid extends StatelessWidget {
  const _Grid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double cell = (constraints.maxWidth - 17 * 4) / 18;
          return SizedBox(
            height: cell * 9 + 8 * 4 + Space.lg,
            child: Stack(
              children: <Widget>[
                for (final ChemicalElement element in elements)
                  Positioned(
                    left: (element.column - 1) * (cell + 4),
                    top: (element.row >= 9 ? element.row - 2 : element.row - 1) * (cell + 4) + (element.row >= 9 ? Space.lg : 0),
                    width: cell,
                    height: cell,
                    child: _Cell(element, size: cell),
                  ),
              ],
            ),
          );
        },
      );
}

class _Cell extends StatelessWidget {
  const _Cell(this.element, {required this.size});

  final ChemicalElement element;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final Color colour = familyColour(context, familyOf(element));
    return Tooltip(
      message: '${element.name}, ${element.number}',
      excludeFromSemantics: true,
      child: DVNavLink(
        to: DVRoutes.periodictableSymbol(symbol: element.symbol.toLowerCase()),
        preview: DVLinkPreview.none,
        semanticLabel: '${element.name}, symbol ${element.symbol}, atomic number ${element.number}',
        child: Container(
          decoration: BoxDecoration(color: colour, borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${element.number}', style: textStyle(context, size: size * 0.18, color: palette.ink, height: 1)),
              Expanded(child: Center(child: Text(element.symbol, style: textStyle(context, size: size * 0.36, weight: FontWeight.w700, color: palette.ink, height: 1)))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElementRow extends StatelessWidget {
  const _ElementRow(this.element);

  final ChemicalElement element;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Tooltip(
      message: 'Open ${element.name}',
      excludeFromSemantics: true,
      child: DVNavLink(
        to: DVRoutes.periodictableSymbol(symbol: element.symbol.toLowerCase()),
        preview: DVLinkPreview.none,
        semanticLabel: '${element.name}, symbol ${element.symbol}, atomic number ${element.number}',
        padding: const EdgeInsets.symmetric(vertical: Space.xs),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: familyColour(context, familyOf(element)), borderRadius: BorderRadius.circular(8)),
              child: Text(element.symbol, style: textStyle(context, size: 18, weight: FontWeight.w700)),
            ),
            const SizedBox(width: Space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(element.name, style: textStyle(context, weight: FontWeight.w600)),
                  Text('${element.number} · ${familyOf(element)}', style: textStyle(context, size: 14, color: palette.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
