import 'package:flutter/material.dart';

class NoGlowScroll extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 🚫 removes glow + stretch
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); //  removes bounce
  }
}
