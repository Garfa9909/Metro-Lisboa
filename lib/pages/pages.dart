import 'package:cmproject/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'list_page.dart';
import 'map_page.dart';

final pages = [
  (title: 'Dashboard', icon:Icons.dashboard, widget:DashboardPage(), key: "dashboard"),
  (title: 'Stations', icon:Icons.list, widget:ListPage(), key: "list"),
  (title: 'Map', icon:Icons.map, widget:MapPage(), key: "map"),
  (title: 'Incidents Report', icon:Icons.warning, widget:ReportPage(), key: "incidents-report"),
];