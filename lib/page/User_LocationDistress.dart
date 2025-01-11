import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_profile_management/page/Widget_inside_appbar_backarrow.dart';
import 'package:user_profile_management/page/Theme.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request permission
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

      // Get location
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });

      // Listen to location changes
      _location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _currentLocation = currentLocation;
        });
      });
    } catch (e) {
      print('Error getting location: $e');
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
        child: AppBarAndBackArrow(title: 'Appointment'),
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
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            _currentLocation!.latitude!,
                            _currentLocation!.longitude!,
                          ),
                          child: const Icon(
                            Icons.location_pin,
                            color: fourthcolour,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    onPressed: _isLoading ? null : _sendDistressSignal,
                    backgroundColor: fourthcolour,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: fivethcolour)
                        : const Icon(Icons.warning),
                  ),
                ),
              ],
            ),
    );
  }
}
