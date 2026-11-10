// One chemical element, and the lookups the periodic table page uses.
import 'elements.g.dart';

/// An element as the periodic table shows it. Data: Wikipedia, CC BY-SA 3.0.
class const ChemicalElement({
  required final int number,
  required final String symbol,
  required final String name,
  final double? atomicMass,
  final String? category,
  required final int group,
  required final int period,

  /// Its cell on the standard 18-column table (lanthanides and actinides in rows 9 and 10).
  required final int column,
  required final int row,
  final String? phase,
  final String? block,
  final String? electronConfiguration,
  final List<int> shells = const <int>[],
  final double? electronegativity,
  final double? meltKelvin,
  final double? boilKelvin,
  final double? density,
  final String? discoveredBy,
  final String? namedBy,
  final String? summary,
  final String? source,
});

ChemicalElement? elementBySymbol(String symbol) {
  for (final ChemicalElement element in elements) {
    if (element.symbol.toLowerCase() == symbol.trim().toLowerCase()) return element;
  }
  return null;
}

ChemicalElement? elementByNumber(int number) => number >= 1 && number <= elements.length ? elements[number - 1] : null;

/// Elements whose number, symbol or name matches [query]; an exact symbol or
/// number first, then names that start with it, then names that contain it.
List<ChemicalElement> searchElements(String query) {
  final String wanted = query.trim().toLowerCase();
  if (wanted.isEmpty) return const <ChemicalElement>[];
  final int? number = int.tryParse(wanted);
  if (number != null) return <ChemicalElement>[?elementByNumber(number)];
  final List<ChemicalElement> exact = <ChemicalElement>[];
  final List<ChemicalElement> starts = <ChemicalElement>[];
  final List<ChemicalElement> contains = <ChemicalElement>[];
  for (final ChemicalElement element in elements) {
    final String name = element.name.toLowerCase();
    if (element.symbol.toLowerCase() == wanted) {
      exact.add(element);
    } else if (name.startsWith(wanted)) {
      starts.add(element);
    } else if (name.contains(wanted)) {
      contains.add(element);
    }
  }
  return <ChemicalElement>[...exact, ...starts, ...contains];
}

/// A Kelvin temperature as Celsius with one decimal, or "unknown".
String kelvinToCelsius(double? kelvin) => kelvin == null ? 'unknown' : '${(kelvin - 273.15).toStringAsFixed(1)} °C';

/// The families the table colours by, in the words a school textbook uses.
String familyOf(ChemicalElement element) {
  final String category = element.category ?? '';
  if (category.contains('noble gas')) return 'Noble gas';
  if (category.contains('alkaline earth')) return 'Alkaline earth metal';
  if (category.contains('alkali')) return 'Alkali metal';
  if (category.contains('lanthanide')) return 'Lanthanide';
  if (category.contains('actinide')) return 'Actinide';
  if (category.contains('transition')) return 'Transition metal';
  if (category.contains('post-transition')) return 'Post-transition metal';
  if (category.contains('metalloid')) return 'Metalloid';
  if (category.contains('nonmetal')) return 'Nonmetal';
  return 'Unknown properties';
}
