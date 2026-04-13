import 'package:cmproject/pages/report_page.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'list_page.dart';
import 'map_page.dart';

final pages = [
  (title: 'Dashboard', icon:Icons.list, widget:DashboardPage(), key: "dashboard"),
  (title: 'List', icon:Icons.thumb_up, widget:ListPage(), key: "list"),
  (title: 'Map', icon:Icons.thumb_up, widget:MapPage(), key: "map"),
  (title: 'Incidents Report', icon:Icons.thumb_up, widget:ReportPage(), key: "incidents-report"),
];