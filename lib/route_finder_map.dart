import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'route_service.dart';

class RouteFinderMap extends StatefulWidget {
  const RouteFinderMap({super.key});

  @override
  State<RouteFinderMap> createState() => _RouteFinderMapState();
}

class _RouteFinderMapState extends State<RouteFinderMap> {
  // UTM Health Center Coordinates
  final LatLng _utmHealthCenter = const LatLng(1.55934, 103.627364);
  
  final MapController _mapController = MapController();
  List<LatLng> _polylineCoordinates = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _calculateShortestRoute() async {
    setState(() {
      _isLoading = true;
      _polylineCoordinates.clear();
      _errorMessage = '';
    });

    try {
      // Get route using the route service
      final route = await RouteService.getRoute(_utmHealthCenter);
      
      setState(() {
        _polylineCoordinates = route.coordinates;
        _isLoading = false;
      });

      // Center and zoom the map to show the entire route
      _mapController.move(
        LatLng(
          (route.startPoint.latitude + route.endPoint.latitude) / 2,
          (route.startPoint.longitude + route.endPoint.longitude) / 2
        ), 
        12.0
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding route: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTM Route Finder'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _utmHealthCenter,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _utmHealthCenter,
                    child: const Icon(
                      Icons.local_hospital,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
              // Polyline for route
              if (_polylineCoordinates.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _polylineCoordinates,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
            ],
          ),
          if (_errorMessage.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red.withOpacity(0.7),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _calculateShortestRoute,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Text('Find Route to UTM Health Center'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
