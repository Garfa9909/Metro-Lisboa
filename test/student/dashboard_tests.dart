import 'package:cmproject/connectivity_module.dart';
import 'package:cmproject/data/empty_data_source.dart';
import 'package:cmproject/data/generic_data_source.dart';
import 'package:cmproject/data/http_metro_datasource.dart';
import 'package:cmproject/data/sqflite_metro_datasource.dart';
import 'package:cmproject/live_location_module.dart';
import 'package:cmproject/http/http_client.dart';
import 'package:cmproject/location_module.dart';
import 'package:cmproject/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    GenericDataSource generic = EmptyDataSource();
    HttpMetroDataSource http = HttpMetroDataSource(client: HttpClient());
    SqfliteMetroDataSource sql = SqfliteMetroDataSource();
    LocationModule loc = LiveLocationModule();
    ConnectivityModule con = ConnectivityModule();
    await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<GenericDataSource>.value(value: generic),
        Provider<HttpMetroDataSource>.value(value: http),
        Provider<SqfliteMetroDataSource>.value(value: sql),
        Provider<LocationModule>.value(value: loc),
        Provider<ConnectivityModule>.value(value: con),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle(Duration(milliseconds: 200));
}