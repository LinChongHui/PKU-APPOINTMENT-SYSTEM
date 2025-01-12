// lib/services/route_service.dart
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class RouteService {
  static Future<List<LatLng>> getRoute(LatLng start, LatLng destination) async {
    try {
      String url = 'https://router.project-osrm.org/route/v1/driving/'
          '${start.longitude},${start.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates =
              data['routes'][0]['geometry']['coordinates'] as List;
          return coordinates
              .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Route error: $e');
      return [];
    }
  }
}
