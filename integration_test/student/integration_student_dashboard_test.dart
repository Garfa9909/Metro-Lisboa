import 'package:integration_test/integration_test.dart';

import '../../test/student/dashboard_tests.dart';

void main()
{
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  runDashboardTests();
}