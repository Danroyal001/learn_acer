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

TextStyle textStyle(BuildContext context, {double size = 16, FontWeight weight = FontWeight.w400, Color? color, double height = 1.45}) =>
    TextStyle(fontFamily: textFont, fontSize: size, fontWeight: weight, color: color ?? Palette.of(context).ink, height: height);

TextStyle displayStyle(BuildContext context, {double size = 32, Color? color}) =>
    TextStyle(fontFamily: displayFont, fontSize: size, color: color ?? Palette.of(context).ink, height: 1.15, letterSpacing: -0.3);

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
class PageColumn extends StatelessWidget {
  const PageColumn({super.key, required this.children, this.maxWidth = 920});

  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width < 600 ? Space.lg : Space.x2, vertical: Space.x2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ),
      ),
    );
  }
}

/// The page's one level-1 heading, with an optional line under it.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key, this.lead});

  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Space.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Semantics(headingLevel: 1, child: Text(title, style: displayStyle(context, size: MediaQuery.sizeOf(context).width < 600 ? 30 : 40))),
            if (lead != null) ...<Widget>[
              const SizedBox(height: Space.sm),
              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 640), child: Text(lead!, style: textStyle(context, size: 17, color: Palette.of(context).muted))),
            ],
          ],
        ),
      );
}

/// A level-2 heading inside a page.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Space.xl, bottom: Space.md),
        child: Semantics(headingLevel: 2, child: Text(title, style: displayStyle(context, size: 22))),
      );
}

/// A white page of the exercise book, or a patch of board, holding a group.
class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(Space.xl)});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(color: palette.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: palette.rule)),
      child: child,
    );
  }
}

/// The screen's one main action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.label, {super.key, required this.onPressed, required this.tooltip, this.busy = false, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool busy;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Tooltip(
      message: tooltip,
      excludeFromSemantics: true,
      child: FilledButton.icon(
        onPressed: busy ? null : onPressed,
        icon: busy
            ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: palette.onAccent))
            : (icon == null ? const SizedBox.shrink() : Icon(icon, size: 20)),
        label: Text(label, style: textStyle(context, size: 16, weight: FontWeight.w700, color: palette.onAccent)),
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: Space.xl, vertical: Space.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

/// A quieter action next to the main one.
class QuietButton extends StatelessWidget {
  const QuietButton(this.label, {super.key, required this.onPressed, required this.tooltip, this.color});

  final String label;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(minimumSize: const Size(48, 48), padding: const EdgeInsets.symmetric(horizontal: Space.lg)),
          child: Text(label, style: textStyle(context, size: 16, weight: FontWeight.w600, color: color ?? Palette.of(context).accent)),
        ),
      );
}

/// A link to another page of the app, drawn as underlined text.
class RouteLink extends StatelessWidget {
  const RouteLink(this.label, {super.key, required this.to, required this.tooltip, this.size = 16});

  final String label;
  final DVRouteTarget to;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        excludeFromSemantics: true,
        child: DVNavLink(
          to: to,
          preview: DVLinkPreview.none,
          semanticLabel: '$label: $tooltip',
          padding: const EdgeInsets.symmetric(vertical: Space.md),
          child: Text(
            label,
            style: textStyle(context, size: size, weight: FontWeight.w600, color: Palette.of(context).accent).copyWith(decoration: TextDecoration.underline),
          ),
        ),
      );
}

/// A labelled text field: the label is always visible, never only a placeholder.
class LabelledField extends StatelessWidget {
  const LabelledField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.maxLines = 1,
    this.onSubmitted,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: Space.lg),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          minLines: maxLines > 1 ? 3 : 1,
          onSubmitted: onSubmitted,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: textStyle(context),
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: textStyle(context, size: 16, weight: FontWeight.w600),
            hintText: hint,
            errorText: error,
            errorMaxLines: 3,
          ),
        ),
      );
}

/// A message under a form: what went wrong, or that it worked.
class Notice extends StatelessWidget {
  const Notice(this.text, {super.key, this.good = false});

  final String text;
  final bool good;

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(top: Space.md),
        child: Text(text, style: textStyle(context, size: 15, weight: FontWeight.w600, color: good ? palette.success : palette.danger)),
      ),
    );
  }
}

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
