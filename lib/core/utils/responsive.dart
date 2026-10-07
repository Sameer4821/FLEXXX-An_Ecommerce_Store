import 'package:flutter/material.dart';
import '../constants/app_tokens.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppBreakpoints.mobileMax;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppBreakpoints.mobileMax &&
      MediaQuery.of(context).size.width <= AppBreakpoints.tabletMax;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > AppBreakpoints.tabletMax;

  static int getGridCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 480) return 2;
    if (width < 768) return 3;
    if (width < 1100) return 4;
    if (width < 1400) return 5;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > AppBreakpoints.tabletMax) {
          return desktop;
        }
        if (constraints.maxWidth >= AppBreakpoints.mobileMax) {
          return tablet ?? desktop;
        }
        return mobile;
      },
    );
  }
}
