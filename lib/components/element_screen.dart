import 'package:flutter/widgets.dart';

import 'element_colours.dart';
import 'ui.dart';
import '../content/element.dart';
import '../dartvel_client/dartvel_client.dart';

/// One element's page: its card, its numbers and a short summary. The server
/// writes the same facts into the page (lib/backend/page_data/index.dart).

@DVFunctionalWidget()
Widget _elementScreen(BuildContext context, {required String symbol}) {
  final ChemicalElement? element = elementBySymbol(symbol);
  final Palette palette = Palette.of(context);
  if (element == null) {
    return PageColumn(children: <Widget>[
      const PageTitle(title: 'No such element', lead: 'There is no element with that symbol.'),
      RouteLink(label: 'Back to the periodic table', to: DVRoutes.periodictable, tooltip: 'All 118 elements'),
    ]);
  }
  final ChemicalElement? previous = elementByNumber(element.number - 1);
  final ChemicalElement? next = elementByNumber(element.number + 1);
  final bool narrow = MediaQuery.sizeOf(context).width < 600;
  final List<(String, String)> facts = elementFacts(element);
  return PageColumn(
    children: <Widget>[
      RouteLink(label: '← Periodic table', to: DVRoutes.periodictable, tooltip: 'All 118 elements', size: 15),
      DVBox.wrapLine(<Widget>[
        DVBox.list(<Widget>[
          DVText('${element.number}').modifier(DVModifier().fontFamily(textFont).fontSize(16).fontWeight(FontWeight.w600).color(palette.ink)),
          DVText(element.symbol).modifier(DVModifier().fontFamily(displayFont).fontSize(52).color(palette.ink).centered()),
          DVText(element.atomicMass == null ? '' : trimNumber(element.atomicMass!, digits: 3)).modifier(DVModifier().fontFamily(textFont).fontSize(13).color(palette.ink)),
        ], spacing: 0, modifier: DVModifier().width(132).height(132).padding(Space.md).backgroundColor(familyColour(context, familyOf(element))).rounded(12).semanticLabel('${element.name} card')),
        DVBox(PageTitle(title: element.name, lead: '${familyOf(element)}, atomic number ${element.number}.'), const DVModifier().maxWidth(560)),
      ], spacing: Space.xl, crossAlign: DVCrossAlign.center, modifier: const DVModifier().paddingOnly(top: Space.md)),
      if ((element.summary ?? '').isNotEmpty) DVBox(BodyText(text: element.summary!, size: 17), const DVModifier().maxWidth(680)),
      const SectionTitle(title: 'Facts'),
      Panel(
        padding: Space.xl,
        spacing: 0,
        children: <Widget>[
          for (final (String label, String value) in facts)
            (narrow
                    ? DVBox.list(<Widget>[BodyText(text: label, size: 15, muted: true), BodyText(text: value, bold: true)], spacing: Space.xs)
                    : DVBox.row(<Widget>[
                        DVBox(BodyText(text: label, size: 15, muted: true), const DVModifier().width(260)),
                        BodyText(text: value, bold: true),
                      ], spacing: 0, crossAlign: DVCrossAlign.start))
                .modifier(DVModifier().paddingSymmetric(vertical: Space.md).border(Border(bottom: BorderSide(color: palette.rule)))),
        ],
      ),
      DVBox.wrapLine(<Widget>[
        if (previous != null) RouteLink(label: '← ${previous.name}', to: DVRoutes.periodictableSymbol(symbol: previous.symbol.toLowerCase()), tooltip: 'Element ${previous.number}'),
        if (next != null) RouteLink(label: '${next.name} →', to: DVRoutes.periodictableSymbol(symbol: next.symbol.toLowerCase()), tooltip: 'Element ${next.number}'),
      ], spacing: Space.xl, modifier: const DVModifier().paddingOnly(top: Space.xl)),
      if (element.source != null) OutLink(label: 'Source: Wikipedia (CC BY-SA 3.0)', url: element.source!, tooltip: 'Read about ${element.name} on Wikipedia', size: 14, muted: true),
    ],
  );
}
