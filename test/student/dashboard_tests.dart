import 'package:cmproject/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cmproject/data/metro_repository.dart';
import 'package:provider/provider.dart';

import 'test_lib.dart';

void main()
{
  runDashboardTests();
}

void runDashboardTests()
{
  testWidgets('Dashboard list button', checkDependsOn((tester) async
      {
        await _pumpApp(tester);

        final finder = find.byKey(Key('dashboard-stations-button'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        final Finder screenFinder = find.byKey(Key("list-screen"));

        expect(screenFinder, findsOneWidget,
            reason: "List button must forward to list screen");
      }));

  testWidgets('Dashboard map button', checkDependsOn((tester) async
  {
    await _pumpApp(tester);

    final finder = find.byKey(Key('dashboard-map-button'));
    await tester.tap(finder);
    await tester.pumpAndSettle();

    final Finder screenFinder = find.byKey(Key("map-screen"));

    expect(screenFinder, findsOneWidget,
        reason: "Map button must forward to map screen");
  }));

}

Future<void> _pumpApp(WidgetTester tester) async
{
  final repository = MetroRepository();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<MetroRepository>.value(value: repository),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle(Duration(milliseconds: 200));
}