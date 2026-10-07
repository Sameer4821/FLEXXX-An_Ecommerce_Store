import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex/main.dart';

void main() {
  testWidgets('FlexxxApp renders successfully without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FlexxxApp(),
      ),
    );
    expect(find.byType(FlexxxApp), findsOneWidget);
  });
}
