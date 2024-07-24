import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> checkAndRequestLocationPermission() async {
    // Check if location services are enabled
    bool servicesEnabled = await Permission.location.serviceStatus.isEnabled;
    if (!servicesEnabled) {
      
      print("LOCATION_SERVICES_DISABLED");
      return false;
    }

    // Check location permission status
    PermissionStatus status = await Permission.location.status;
    print(status);

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isRestricted) {
      // Request the permission
      status = await Permission.location.request();
      if (status.isGranted) {
        return true;
      }
    } else if (status.isPermanentlyDenied) {
      // Handle the case where the user has permanently denied the permission
      openAppSettings();
    }

    return false;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }


}
