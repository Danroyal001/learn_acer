import 'package:flutter/widgets.dart';

import '../components/site_chrome.dart';
import '../components/ui.dart';
import '../dartvel_client/dartvel_client.dart';

/// Every page sits between the header and the footer and scrolls as one
/// document, on paper with a red margin line (yellow chalk in the dark).
class const Layout({super.key, required super.child}) extends DartvelLayout {
  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette.of(context);
    final bool narrow = MediaQuery.sizeOf(context).width < 600;
    return DVBox.list(<Widget>[
      const SiteHeader(),
      DVBox(
        child,
        DVModifier().minHeight(MediaQuery.sizeOf(context).height * 0.7).border(Border(left: BorderSide(color: palette.margin.withValues(alpha: 0.55), width: narrow ? 3 : 4))),
      ),
      const SiteFooter(),
    ], spacing: 0, modifier: DVModifier().backgroundColor(palette.page)).scrollable();
  }
}
