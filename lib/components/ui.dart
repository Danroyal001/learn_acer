// Learn Acer's look: an exercise book by day (paper, ink blue, a red margin
// line) and a chalkboard by night. Shared pieces every page uses.
import 'package:flutter/material.dart';

import '../dartvel_client/dartvel_client.dart';

const String displayFont = 'YoungSerif';
const String textFont = 'WorkSans';

class Palette {
  const Palette._(this.dark);

  factory Palette.of(BuildContext context) => Palette._(Theme.of(context).brightness == Brightness.dark);

  final bool dark;

  Color get page => dark ? const Color(0xFF17221D) : const Color(0xFFFBFAF5);
  Color get surface => dark ? const Color(0xFF1F2D27) : const Color(0xFFFFFFFF);
  Color get ink => dark ? const Color(0xFFF1F0E8) : const Color(0xFF14213D);
  Color get muted => dark ? const Color(0xFFB8C2BC) : const Color(0xFF4B5670);
  Color get rule => dark ? const Color(0xFF33443C) : const Color(0xFFDCE3EF);
  Color get accent => dark ? const Color(0xFF8EC5FF) : const Color(0xFF1D4ED8);
  Color get onAccent => dark ? const Color(0xFF0B1A2C) : const Color(0xFFFFFFFF);
  Color get accentSoft => dark ? const Color(0xFF203247) : const Color(0xFFE8EEFC);

  /// The exercise book's margin line; on the board, yellow chalk.
  Color get margin => dark ? const Color(0xFFF5D76E) : const Color(0xFFD9485F);
  Color get success => dark ? const Color(0xFF7FD8A2) : const Color(0xFF15803D);
  Color get danger => dark ? const Color(0xFFFF9C8F) : const Color(0xFFB42318);
}

/// Spacing, from the design guide's one scale.
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double x2 = 32;
  static const double x3 = 48;
  static const double x4 = 64;
}

ThemeData learnAcerTheme(Brightness brightness) {
  final Palette palette = Palette._(brightness == Brightness.dark);
  return ThemeData(
    brightness: brightness,
    fontFamily: textFont,
    scaffoldBackgroundColor: palette.page,
    colorScheme: ColorScheme.fromSeed(seedColor: palette.accent, brightness: brightness, primary: palette.accent, onPrimary: palette.onAccent, surface: palette.surface, error: palette.danger),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: palette.muted)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: palette.muted)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: palette.accent, width: 2)),
    ),
  );
}

/// A page's width-bounded column with the design guide's margins.
@DVFunctionalWidget()
Widget _pageColumn(BuildContext context, {required List<Widget> children, double maxWidth = 920}) {
  final bool narrow = MediaQuery.sizeOf(context).width < 600;
  return DVBox(
    DVBox.list(
      children,
      spacing: 0,
      modifier: DVModifier().maxWidth(maxWidth).paddingSymmetric(horizontal: narrow ? Space.lg : Space.x2, vertical: Space.x2),
    ),
    const DVModifier().centered(),
  );
}

/// The page's one level-1 heading, with an optional line under it.
@DVFunctionalWidget()
Widget _pageTitle(BuildContext context, {required String title, String lead = ''}) {
  final Palette palette = Palette.of(context);
  final bool narrow = MediaQuery.sizeOf(context).width < 600;
  return DVBox.list(<Widget>[
    DVText(title).modifier(DVModifier().semanticHeading(1).fontFamily(displayFont).fontSize(narrow ? 30 : 40).lineHeight(1.15).color(palette.ink)),
    if (lead.isNotEmpty) DVText(lead).modifier(DVModifier().maxWidth(640).fontFamily(textFont).fontSize(17).lineHeight(1.45).color(palette.muted)),
  ], spacing: Space.sm, modifier: const DVModifier().paddingOnly(bottom: Space.xl));
}

/// A level-2 heading inside a page.
@DVFunctionalWidget()
Widget _sectionTitle(BuildContext context, {required String title, int level = 2, double size = 22}) => DVText(title).modifier(
      DVModifier().semanticHeading(level).fontFamily(displayFont).fontSize(size).lineHeight(1.2).color(Palette.of(context).ink).paddingOnly(top: level == 2 ? Space.xl : 0, bottom: Space.md),
    );

/// Running text in the text face.
@DVFunctionalWidget()
Widget _bodyText(BuildContext context, {required String text, double size = 16, bool muted = false, bool bold = false, Color? color}) => DVText(text).modifier(
      DVModifier()
          .fontFamily(textFont)
          .fontSize(size)
          .lineHeight(1.45)
          .fontWeight(bold ? FontWeight.w700 : FontWeight.w400)
          .color(color ?? (muted ? Palette.of(context).muted : Palette.of(context).ink)),
    );

/// A white page of the exercise book, or a patch of board, holding a group.
@DVFunctionalWidget()
Widget _panel(BuildContext context, {required List<Widget> children, double padding = Space.xl, double spacing = Space.md}) {
  final Palette palette = Palette.of(context);
  return DVBox.list(
    children,
    spacing: spacing,
    modifier: DVModifier().backgroundColor(palette.surface).rounded(12).border(Border.all(color: palette.rule)).padding(padding),
  );
}

/// The screen's one main action.
@DVFunctionalWidget()
Widget _primaryButton(BuildContext context, {required String label, required String tooltip, required VoidCallback onTap, bool busy = false}) {
  final Palette palette = Palette.of(context);
  return DVText(busy ? 'Working…' : label).modifier(
    DVModifier()
        .fontFamily(textFont)
        .fontSize(16)
        .fontWeight(FontWeight.w700)
        .color(palette.onAccent)
        .backgroundColor(busy ? palette.muted : palette.accent)
        .rounded(8)
        .paddingSymmetric(horizontal: Space.xl, vertical: Space.md)
        .minimumTapTarget()
        .tooltip(tooltip)
        .onTap(busy ? () {} : onTap),
  );
}

/// A quieter action next to the main one.
@DVFunctionalWidget()
Widget _quietButton(BuildContext context, {required String label, required String tooltip, required VoidCallback onTap, Color? color}) => DVText(label).modifier(
      DVModifier()
          .fontFamily(textFont)
          .fontSize(16)
          .fontWeight(FontWeight.w600)
          .color(color ?? Palette.of(context).accent)
          .paddingSymmetric(horizontal: Space.lg, vertical: Space.md)
          .minimumTapTarget()
          .tooltip(tooltip)
          .onTap(onTap),
    );

/// A link to another page of the app, drawn as underlined text.
@DVFunctionalWidget()
Widget _routeLink(BuildContext context, {required String label, required DVRouteTarget to, required String tooltip, double size = 16}) => DVNavLink(
      to: to,
      preview: DVLinkPreview.none,
      semanticLabel: '$label: $tooltip',
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: DVText(label).modifier(
        DVModifier().fontFamily(textFont).fontSize(size).fontWeight(FontWeight.w600).color(Palette.of(context).accent).decoration(TextDecoration.underline).tooltip(tooltip),
      ),
    );

/// A link off the site, drawn as underlined text.
@DVFunctionalWidget()
Widget _outLink(BuildContext context, {required String label, required String url, required String tooltip, double size = 15, bool muted = false}) => DVNavLink.external(
      url,
      semanticLabel: '$label: $tooltip',
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: DVText(label).modifier(
        DVModifier()
            .fontFamily(textFont)
            .fontSize(size)
            .fontWeight(muted ? FontWeight.w400 : FontWeight.w600)
            .color(muted ? Palette.of(context).muted : Palette.of(context).accent)
            .decoration(TextDecoration.underline)
            .tooltip(tooltip),
      ),
    );

/// A labelled text field: the label is always visible, never only a placeholder.
@DVFunctionalWidget()
Widget _field(
  BuildContext context, {
  required String label,
  required String value,
  required ValueChanged<String> onChanged,
  String hint = '',
  String? error,
  bool multiline = false,
  VoidCallback? onSubmitted,
}) =>
    DVText(value).modifier(
      DVModifier()
          .input(label: label, hint: hint.isEmpty ? null : hint, error: error, multiline: multiline, onChanged: onChanged, onSubmitted: onSubmitted)
          .fontFamily(textFont)
          .fontSize(16)
          .paddingOnly(bottom: Space.lg),
    );

/// A message under a form: what went wrong, or that it worked.
@DVFunctionalWidget()
Widget _notice(BuildContext context, {required String text, bool good = false}) {
  final Palette palette = Palette.of(context);
  return DVText(text).modifier(
    DVModifier().fontFamily(textFont).fontSize(15).fontWeight(FontWeight.w600).color(good ? palette.success : palette.danger).paddingOnly(top: Space.md).semanticRole('status'),
  );
}

/// One choice out of a few, as a row of buttons; the chosen one is filled and
/// says so to a screen reader. Stands in for radio buttons and segmented controls.
@DVFunctionalWidget()
Widget _choiceRow(BuildContext context, {required List<(String, String, String)> options, required String selected, required ValueChanged<String> onChanged}) {
  final Palette palette = Palette.of(context);
  return DVBox.wrapLine(<Widget>[
    for (final (String value, String label, String hint) in options)
      DVText(label).modifier(
        DVModifier()
            .fontFamily(textFont)
            .fontSize(15)
            .fontWeight(FontWeight.w600)
            .color(value == selected ? palette.onAccent : palette.ink)
            .backgroundColor(value == selected ? palette.accent : palette.surface)
            .border(Border.all(color: value == selected ? palette.accent : palette.muted))
            .rounded(8)
            .paddingSymmetric(horizontal: Space.lg, vertical: Space.md)
            .minimumTapTarget()
            .semanticLabel('$label${value == selected ? ', chosen' : ''}')
            .tooltip(hint)
            .onTap(() => onChanged(value)),
      ),
  ], spacing: Space.sm, crossAlign: DVCrossAlign.center);
}

/// A short "loading" line while the server answers.
@DVFunctionalWidget()
Widget _loadingLine(BuildContext context) => DVText('Loading…').modifier(DVModifier().fontFamily(textFont).fontSize(15).color(Palette.of(context).muted).semanticRole('status'));

/// What to tell the person when a server call fails: the server's own words
/// for a refusal, a plain line for anything else.
String problemText(Object error) {
  if (error is DVBackendFunctionException && error.message.trim().isNotEmpty) return error.message;
  return 'That did not go through. Check your connection and try again.';
}

/// A short date a person reads at a glance: 10 Nov 2026.
String shortDate(String iso) {
  final DateTime? at = DateTime.tryParse(iso)?.toLocal();
  if (at == null) return '';
  const List<String> months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${at.day} ${months[at.month - 1]} ${at.year}';
}

/// Runs [work] once after the first frame, for loading a page's data.
void onFirstFrame(BuildContext context, DVSignal<bool> started, VoidCallback work) {
  if (started.read()) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted || started.read()) return;
    started.value = true;
    work();
  });
}
