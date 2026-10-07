import 'package:flutter/material.dart';

/// Spacing System
class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius System
class AppRadius {
  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double circular = 999.0;
}

/// Responsive Layout Breakpoints
class AppBreakpoints {
  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;
  static const double desktopMin = 1025.0;
}

/// Centralized Elevation & Box Shadows
class AppShadows {
  static List<BoxShadow> soft(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: 0.4)
          : const Color(0x0F1E272E),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> glow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.35),
      blurRadius: 20,
      spreadRadius: 1,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> floating(bool isDark) => [
    BoxShadow(
      color: isDark
          ? Colors.black.withValues(alpha: 0.6)
          : const Color(0x1F6C5CE7),
      blurRadius: 24,
      spreadRadius: 2,
      offset: const Offset(0, 10),
    ),
  ];
}

/// Centralized Premium Gradients
class AppGradients {
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF1F2430), Color(0xFF151922)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient flashDealGradient = LinearGradient(
    colors: [Color(0xFFFF4757), Color(0xFFFF7675)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFDCB6E), Color(0xFFE17055)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassOverlayDark = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x05FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassOverlayLight = LinearGradient(
    colors: [Color(0x88FFFFFF), Color(0x22FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
