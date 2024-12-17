import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RouteModel {
  final LatLng startPoint;
  final LatLng endPoint;
  final List<LatLng> coordinates;

  RouteModel({
    required this.startPoint, 
    required this.endPoint, 
    required this.coordinates
  });
}

class RouteService {
  static Future<RouteModel> getRoute(LatLng destination) async {
    // Check and request location permissions
    await _checkLocationPermission();

    // Get current user location
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    LatLng userLocation = LatLng(
      currentPosition.latitude, 
      currentPosition.longitude
    );

    // Note: This is a simplified route calculation
    // In a real-world scenario, you would use a routing API 
    // like Google Directions, OpenRouteService, or MapBox
    return RouteModel(
      startPoint: userLocation,
      endPoint: destination,
      coordinates: [userLocation, destination]
    );
  }

  static Future<LocationPermission> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied. Please enable in app settings.');
    }

    if (permission != LocationPermission.always && 
        permission != LocationPermission.whileInUse) {
      throw Exception('Location permissions not granted.');
    }

    return permission;
  }
}
