import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_profile_management/page/Widget_inside_appbar_backarrow.dart';
import 'package:user_profile_management/page/Theme.dart';
import 'package:user_profile_management/back-end/firebase_RouteService.dart';

const DESTINATION = LatLng(1.55934, 103.627364);

class LocationMapPage extends StatefulWidget {
  const LocationMapPage({Key? key}) : super(key: key);

  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  final Location _location = Location();
  final MapController _mapController = MapController();
  LocationData? _currentLocation;
  bool _isLoading = false;
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = false;
  bool _showRoute = false;  // New flag to control route visibility

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });

      _location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _currentLocation = currentLocation;
        });
        if (_showRoute) {
          _updateRoute();  // Only update route if it's visible
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _updateRoute() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoadingRoute = true;
    });

    final currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
    final points = await RouteService.getRoute(currentLatLng, DESTINATION);
    
    setState(() {
      _routePoints = points;
      _isLoadingRoute = false;
    });
  }

  Future<void> _toggleRoute() async {
    setState(() {
      _showRoute = !_showRoute;
    });
    
    if (_showRoute) {
      await _updateRoute();
    } else {
      setState(() {
        _routePoints = [];
      });
    }
  }

  Future<void> _sendDistressSignal() async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('distress_signals').add({
        'latitude': _currentLocation!.latitude,
        'longitude': _currentLocation!.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Distress signal sent successfully')),
      );
    } catch (e) {
      print('Error sending distress signal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending distress signal: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBarAndBackArrow(title: ' Location Map'),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      _currentLocation!.latitude!,
                      _currentLocation!.longitude!,
                    ),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (_showRoute && _routePoints.isNotEmpty)  // Only show route if _showRoute is true
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 4.0,
                            color: Colors.blue.withOpacity(0.8),
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
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
                        const Marker(
                          point: DESTINATION,
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Show Route button
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton.extended(
                      onPressed: _isLoadingRoute ? null : _toggleRoute,
                      backgroundColor: _showRoute ? Colors.red : Colors.blue,
                      label: _isLoadingRoute
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : Text(_showRoute ? 'Hide Route' : 'Show Route'),
                      icon: Icon(_showRoute ? Icons.hide_source : Icons.route),
                    ),
                  ),
                ),
                // Distress Signal button
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: _isLoading ? null : _sendDistressSignal,
                    backgroundColor: Colors.red,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.warning),
                  ),
                ),
              ],
            ),
    );
  }
}
