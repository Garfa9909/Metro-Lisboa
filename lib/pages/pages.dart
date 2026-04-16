import 'package:cmproject/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'list_page.dart';
import 'map_page.dart';

final pages = [
  (title: 'Dashboard', icon:Icons.dashboard, builder:(onChangeTab) => DashboardPage(onChangeTab: onChangeTab), key: "dashboard"),
  (title: 'Stations', icon:Icons.list, builder:(onChangeTab) => ListPage(), key: "list"),
  (title: 'Map', icon:Icons.map, builder:(onChangeTab) => MapPage(), key: "map"),
  (title: 'Incidents Report', icon:Icons.warning, builder:(onChangeTab) => ReportPage(), key: "incidents-report"),
];