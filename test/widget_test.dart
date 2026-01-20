import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habits_flow/injection.dart';
import 'package:habits_flow/main.dart';
import 'package:habits_flow/ui/widgets/test_dashboard/test_dashboard_provider.dart';

void main() {
  setUpAll(() => configureDependencies());
  testWidgets('Main screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Main Screen'), findsOneWidget);
    expect(find.byType(TestDashboardProvider), findsOneWidget);
  });
}
