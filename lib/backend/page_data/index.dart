// What the server writes into an element's page before the app loads: its
// title, description and facts as a document, so each element reads, prints
// and is found with scripting off. Compiled into the server; no Flutter here.
import 'package:dartvel_core/dartvel.dart';

import '../../content/element.dart';

Future<DVPageData?> _elementDocument(DVPageRequest request) async {
  final ChemicalElement? element = elementBySymbol(request.params['symbol'] ?? '');
  if (element == null) return const DVPageData(title: 'No such element – Learn Acer', visibility: DVPageVisibility.hidden);
  final String mass = element.atomicMass == null ? 'unknown' : '${element.atomicMass}';
  return DVPageData(
    title: '${element.name} (${element.symbol}), element ${element.number} – Learn Acer periodic table',
    description: '${element.name}: atomic number ${element.number}, atomic mass $mass, ${familyOf(element).toLowerCase()}, electron configuration ${element.electronConfiguration?.replaceFirst('*', '') ?? 'unknown'}.',
    document: <DVDocumentBlock>[
      DVDocumentBlock.heading(element.name, level: 1),
      DVDocumentBlock.paragraph('${familyOf(element)}, atomic number ${element.number}.'),
      if ((element.summary ?? '').isNotEmpty) DVDocumentBlock.paragraph(element.summary!),
      const DVDocumentBlock.heading('Facts'),
      DVDocumentBlock.paragraph('Symbol ${element.symbol}. Atomic mass $mass u. Group ${element.group}, period ${element.period}. '
          'Electron configuration ${element.electronConfiguration?.replaceFirst('*', '') ?? 'unknown'}. Electrons per shell ${element.shells.join(', ')}. '
          'State at room temperature: ${element.phase ?? 'unknown'}. Melting point ${kelvinToCelsius(element.meltKelvin)}, boiling point ${kelvinToCelsius(element.boilKelvin)}. '
          'Discovered by ${element.discoveredBy ?? 'unknown'}.'),
      const DVDocumentBlock.paragraph('Element data from Wikipedia, CC BY-SA 3.0.'),
    ],
  );
}

/// Route patterns and the functions that resolve them.
final Map<String, DVPageDataResolver> dartvelRoutePageData = <String, DVPageDataResolver>{
  '/periodic-table/:symbol': _elementDocument,
};
