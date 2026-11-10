// The periodic table: all 118 elements, in their real places, nothing invented.
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_acer/content/element.dart';
import 'package:learn_acer/content/elements.g.dart';

void main() {
  test('118 elements, numbered 1 to 118 with no gaps', () {
    expect(elements.length, 118);
    expect([for (final ChemicalElement element in elements) element.number], List<int>.generate(118, (int index) => index + 1));
  });

  test('symbols are unique', () {
    expect({for (final ChemicalElement element in elements) element.symbol}.length, 118);
  });

  test('known values are right', () {
    expect(elementBySymbol('Fe')?.name, 'Iron');
    expect(elementBySymbol('O')?.atomicMass, closeTo(15.999, 0.001));
    expect(elementBySymbol('Au')?.number, 79);
    expect(elementBySymbol('Na')?.group, 1);
    expect(elementBySymbol('Cl')?.period, 3);
  });

  test('no two elements share a cell on the table', () {
    final Set<String> cells = {for (final ChemicalElement element in elements) '${element.row},${element.column}'};
    expect(cells.length, 118);
  });

  test('search finds by name, symbol or number', () {
    expect(searchElements('carb').map((ChemicalElement e) => e.symbol), contains('C'));
    expect(searchElements('Na').first.symbol, 'Na');
    expect(searchElements('26').single.symbol, 'Fe');
    expect(searchElements(''), isEmpty);
  });

  test('temperatures read in Celsius, one decimal', () {
    expect(kelvinToCelsius(273.15), '0.0 °C');
    expect(kelvinToCelsius(null), 'unknown');
  });
}
