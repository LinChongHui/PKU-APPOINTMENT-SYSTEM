import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class AdminMapPage extends StatefulWidget {
  const AdminMapPage({Key? key}) : super(key: key);

  @override
  _AdminMapPageState createState() => _AdminMapPageState();
}

class _AdminMapPageState extends State<AdminMapPage> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  LocationData? _currentLocation;
  List<Marker> _markers = [];
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadDistressSignals();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _loadDistressSignals() async {
    // Listen to real-time updates from Firestore
    FirebaseFirestore.instance
        .collection('distress_signals')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      List<Marker> markers = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final lat = data['latitude'] as double;
        final lng = data['longitude'] as double;
        final timestamp = (data['timestamp'] as Timestamp).toDate();

        markers.add(
          Marker(
            point: LatLng(lat, lng),
            child: GestureDetector(
              onTap: () => _showDistressDetails(LatLng(lat, lng), timestamp),
              child: const Icon(
                Icons.warning,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        );
      }

      setState(() {
        _markers = markers;
      });
    });
  }

  Future<void> _getRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoadingRoute = true;
      _routePoints = [];
    });

    try {
      String url = 'https://router.project-osrm.org/route/v1/driving/'
          '${_currentLocation!.longitude},${_currentLocation!.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
          _routePoints = coordinates
              .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
              .toList();
          setState(() {});
        }
      }
    } catch (e) {
      print('Route error: $e');
    } finally {
      setState(() {
        _isLoadingRoute = false;
      });
    }
  }

  void _showDistressDetails(LatLng location, DateTime timestamp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Distress Signal Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${timestamp.toString()}'),
            Text('Latitude: ${location.latitude}'),
            Text('Longitude: ${location.longitude}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getRoute(location);
            },
            child: const Text('Show Route'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Distress Signal Monitor'),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                 MarkerLayer(markers: [
                  ..._markers,
                  if (_currentLocation != null)
                    Marker(
                      point: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                ]),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 3.0,
                        color: Colors.blue.withOpacity(0.8),
                      ),
                    ],
                  ),
              ],
            ),
      floatingActionButton: _isLoadingRoute
          ? const FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : null,
    );
  }
}
