import 'package:location/location.dart';
import 'location_module.dart';

class LiveLocationModule extends LocationModule
{
  final Location _location = Location();

  @override
  Stream<LocationData> onLocationChanged()
  {
    return _location.onLocationChanged;
  }
}