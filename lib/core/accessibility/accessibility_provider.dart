import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessibilityState {
  final bool reducedMotion;
  final bool highContrast;
  final double textScaleFactor;

  const AccessibilityState({
    this.reducedMotion = false,
    this.highContrast = false,
    this.textScaleFactor = 1.0,
  });

  AccessibilityState copyWith({
    bool? reducedMotion,
    bool? highContrast,
    double? textScaleFactor,
  }) {
    return AccessibilityState(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }
}

class AccessibilityNotifier extends StateNotifier<AccessibilityState> {
  AccessibilityNotifier() : super(const AccessibilityState());

  void toggleReducedMotion() {
    state = state.copyWith(reducedMotion: !state.reducedMotion);
  }

  void toggleHighContrast() {
    state = state.copyWith(highContrast: !state.highContrast);
  }

  void setTextScaleFactor(double scale) {
    state = state.copyWith(textScaleFactor: scale);
  }
}

final accessibilityProvider =
    StateNotifierProvider<AccessibilityNotifier, AccessibilityState>((ref) {
      return AccessibilityNotifier();
    });
