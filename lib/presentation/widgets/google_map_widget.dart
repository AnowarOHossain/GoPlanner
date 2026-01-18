// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// OpenStreetMap plugin
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// Import Geolocator for getting user's current location
// Import location provider
import '../providers/location_provider.dart';
// Import for firstWhereOrNull
import 'package:collection/collection.dart';

// Widget to display OpenStreetMap with markers
class GoogleMapWidget extends ConsumerStatefulWidget {
  final List<MapMarker> markers; // List of markers to show on map
  final Function(double, double)? onMapTap; // Callback when map is tapped
  final bool showCurrentLocation; // Whether to show user's location
  final double? initialLat; // Starting latitude
  final double? initialLng; // Starting longitude
  final double initialZoom; // Starting zoom level

  const GoogleMapWidget({
    super.key,
    this.markers = const [],
    this.onMapTap,
    this.showCurrentLocation = true,
    this.initialLat,
    this.initialLng,
    this.initialZoom = 14.0,
  });

  @override
  ConsumerState<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends ConsumerState<GoogleMapWidget> {
  late MapController _mapController;


  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: widget.initialLat ?? 23.8103,
        longitude: widget.initialLng ?? 90.4125,
      ),
      areaLimit: const BoundingBox.world(),
    );
    // NOTE: Add 'collection' to your pubspec.yaml dependencies for firstWhereOrNull
    if (widget.showCurrentLocation) {
      _getCurrentLocation();
    }
  }

  // Get user's current GPS location
  Future<void> _getCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    await locationService.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: _mapController,
      osmOption: OSMOption(
        userTrackingOption: widget.showCurrentLocation
            ? const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              )
            : const UserTrackingOption(
                enableTracking: false,
                unFollowUser: false,
              ),
        zoomOption: ZoomOption(
          initZoom: widget.initialZoom,
          minZoomLevel: 2,
          maxZoomLevel: 19,
          stepZoom: 1.0,
        ),
        userLocationMarker: widget.showCurrentLocation
            ? UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 48,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(
                    Icons.navigation,
                    color: Colors.blueAccent,
                    size: 48,
                  ),
                ),
              )
            : null,
        roadConfiguration: const RoadOption(
          roadColor: Colors.blue,
        ),
      ),
      onMapIsReady: (isReady) async {
        if (isReady) {
          await _addMarkers();
        }
      },
      onGeoPointClicked: (geoPoint) async {
        final marker = widget.markers.firstWhereOrNull(
          (m) => m.latitude == geoPoint.latitude && m.longitude == geoPoint.longitude,
        );
        marker?.onTap?.call();
      },
    );
  }


  Future<void> _addMarkers() async {
    await _mapController.removeMarkers([]); // Remove all markers
    for (final marker in widget.markers) {
      await _mapController.addMarker(
        GeoPoint(latitude: marker.latitude, longitude: marker.longitude),
        markerIcon: MarkerIcon(
          icon: Icon(
            marker.icon,
            color: marker.color,
            size: 48,
          ),
        ),
      );
    }
  }

// ...existing code...
  // _showSetupInstructions() is unused and removed

  /*
  // Uncomment when Google Maps API key is configured
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _updateMarkers();
  }

  void _updateMarkers() {
    setState(() {
      _markers = widget.markers.map((marker) {
        return Marker(
          markerId: MarkerId(marker.id),
          position: LatLng(marker.latitude, marker.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerHue(marker.color),
          ),
          infoWindow: InfoWindow(
            title: marker.title,
            snippet: marker.subtitle,
          ),
          onTap: marker.onTap,
        );
      }).toSet();
      
      // Add current location marker if enabled
      if (widget.showCurrentLocation && _currentPosition != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(
              title: 'Your Location',
            ),
          ),
        );
      }
    });
  }

  double _getMarkerHue(Color color) {
    if (color == Colors.red) return BitmapDescriptor.hueRed;
    if (color == Colors.blue) return BitmapDescriptor.hueBlue;
    if (color == Colors.green) return BitmapDescriptor.hueGreen;
    if (color == Colors.orange) return BitmapDescriptor.hueOrange;
    if (color == Colors.yellow) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueRed;
  }
  */
}

class MapMarker {
  final String id;
  final String title;
  final String? subtitle;
  final double latitude;
  final double longitude;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;
  final Offset position; // For placeholder simulation

  MapMarker({
    required this.id,
    required this.title,
    this.subtitle,
    required this.latitude,
    required this.longitude,
    required this.color,
    required this.icon,
    this.onTap,
    required this.position,
  });
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid
    const gridSize = 50.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some decorative elements
    // Rivers/roads simulation
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.5,
      size.width * 0.6, size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.1,
      size.width, size.height * 0.4,
    );
    
    final pathPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.1)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}