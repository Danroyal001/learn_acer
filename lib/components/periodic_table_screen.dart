import 'package:flutter/widgets.dart';

import 'element_colours.dart';
import 'ui.dart';
import '../content/element.dart';
import '../content/elements.g.dart';
import '../dartvel_client/dartvel_client.dart';

/// The periodic table: the real 18-column table where it fits, a searchable
/// list on a phone. Each element opens its own page.

@DVFunctionalWidget()
Widget _periodicTableScreen(BuildContext context) {
  final DVSignal<String> query = context.signal('');
  final bool grid = MediaQuery.sizeOf(context).width >= 900;
  final List<ChemicalElement> found = searchElements(query.value);
  return PageColumn(
    maxWidth: 1240,
    children: <Widget>[
      const PageTitle(title: 'Periodic table', lead: 'All 118 elements. Search by name, symbol or atomic number, or open any element for its details.'),
      DVBox(
        Field(label: 'Find an element', value: query.value, hint: 'Iron, Fe or 26', onChanged: (String typed) => query.value = typed),
        const DVModifier().maxWidth(420),
      ),
      if (query.value.trim().isNotEmpty) ...<Widget>[
        if (found.isEmpty) BodyText(text: 'No element matches "${query.value.trim()}".', muted: true),
        for (final ChemicalElement element in found.take(8)) ElementRow(symbol: element.symbol),
        DVBox(null, const DVModifier().height(Space.xl)),
      ],
      const FamilyLegend(),
      DVBox(null, const DVModifier().height(Space.lg)),
      if (grid) const ElementGrid() else DVBox.list(<Widget>[for (final ChemicalElement element in elements) ElementRow(symbol: element.symbol)], spacing: Space.xs),
    ],
  );
}

@DVFunctionalWidget()
Widget _familyLegend(BuildContext context) => DVBox.wrapLine(<Widget>[
      for (final String family in elementFamilies)
        DVBox.row(<Widget>[
          DVBox(null, DVModifier().width(14).height(14).backgroundColor(familyColour(context, family)).rounded(3)),
          BodyText(text: family, size: 13, muted: true),
        ], spacing: Space.xs),
    ], spacing: Space.md);

/// The 18-column table: rows 1 to 7, a small gap, then the lanthanides and
/// actinides. Empty cells are empty boxes, so every element sits in its column.
@DVFunctionalWidget()
Widget _elementGrid(BuildContext context) {
  final Map<String, ChemicalElement> byCell = <String, ChemicalElement>{for (final ChemicalElement element in elements) '${element.row},${element.column}': element};
  Widget row(int number) => DVBox.grid(
        <Widget>[
          for (int column = 1; column <= 18; column++)
            if (byCell['$number,$column'] case final ChemicalElement element) ElementCell(symbol: element.symbol) else DVBox(null, const DVModifier().minHeight(1)),
        ],
        columns: 18,
        spacing: 4,
        responsive: false,
      );
  return DVBox.list(<Widget>[
    for (int number = 1; number <= 7; number++) row(number),
    DVBox(null, const DVModifier().height(Space.lg)),
    row(9),
    row(10),
  ], spacing: 4);
}

@DVFunctionalWidget()
Widget _elementCell(BuildContext context, {required String symbol}) {
  final ChemicalElement element = elementBySymbol(symbol)!;
  final Palette palette = Palette.of(context);
  return DVNavLink(
    to: DVRoutes.periodictableSymbol(symbol: element.symbol.toLowerCase()),
    preview: DVLinkPreview.none,
    semanticLabel: '${element.name}, symbol ${element.symbol}, atomic number ${element.number}',
    child: DVBox(
      DVBox.list(<Widget>[
        DVText('${element.number}').modifier(DVModifier().fontFamily(textFont).fontSize(10).lineHeight(1).color(palette.ink)),
        DVText(element.symbol).modifier(DVModifier().fontFamily(textFont).fontSize(17).fontWeight(FontWeight.w700).lineHeight(1).color(palette.ink)),
      ], spacing: 2, crossAlign: DVCrossAlign.start),
      DVModifier().backgroundColor(familyColour(context, familyOf(element))).rounded(6).padding(4).minHeight(54).tooltip('${element.name}, ${element.number}'),
    ),
  );
}

@DVFunctionalWidget()
Widget _elementRow(BuildContext context, {required String symbol}) {
  final ChemicalElement element = elementBySymbol(symbol)!;
  return DVNavLink(
    to: DVRoutes.periodictableSymbol(symbol: element.symbol.toLowerCase()),
    preview: DVLinkPreview.none,
    semanticLabel: '${element.name}, symbol ${element.symbol}, atomic number ${element.number}',
    padding: const EdgeInsets.symmetric(vertical: Space.xs),
    child: DVBox.row(<Widget>[
      DVText(element.symbol).modifier(
        DVModifier().fontFamily(textFont).fontSize(18).fontWeight(FontWeight.w700).color(Palette.of(context).ink).backgroundColor(familyColour(context, familyOf(element))).rounded(8).width(48).height(48).centered(),
      ),
      DVBox.list(<Widget>[
        BodyText(text: element.name, bold: true),
        BodyText(text: '${element.number} · ${familyOf(element)}', size: 14, muted: true),
      ], spacing: 0),
    ], spacing: Space.md).modifier(DVModifier().tooltip('Open ${element.name}')),
  );
}
