import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/accessibility/accessibility_provider.dart';
import 'core/widgets/adaptive_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FlexxxApp()));
}

class FlexxxApp extends ConsumerWidget {
  const FlexxxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accessibility = ref.watch(accessibilityProvider);

    return MaterialApp(
      title: 'FLEXXX — Shopping Redesigned',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(accessibility.textScaleFactor),
          ),
          child: child ?? const SizedBox(),
        );
      },
      home: const AdaptiveNavShell(),
    );
  }
}
