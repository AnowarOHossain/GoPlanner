// Import Flutter widgets
import 'package:flutter/material.dart';
// Import Riverpod for state management
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Google Maps import (uncomment when API key is configured)
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// Import Geolocator for getting user's current location
import 'package:geolocator/geolocator.dart' as geo;
// Import location provider
import '../providers/location_provider.dart';

// Widget to display Google Maps with markers
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
  // Map controller (uncomment when API key is configured)
  // GoogleMapController? _controller;
  geo.Position? _currentPosition; // User's current location
  // Map markers (uncomment when API key is configured)
  // Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Get user's location when widget is created
    if (widget.showCurrentLocation) {
      _getCurrentLocation();
    }
  }

  // Get user's current GPS location
  Future<void> _getCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final position = await locationService.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show placeholder until Google Maps API key is configured
    return _buildMapPlaceholder();
    
    /* Uncomment below when Google Maps API key is configured:
    final initialPosition = CameraPosition(
      target: LatLng(
        widget.initialLat ?? _currentPosition?.latitude ?? 23.8103, // Dhaka, Bangladesh
        widget.initialLng ?? _currentPosition?.longitude ?? 90.4125,
      ),
      zoom: widget.initialZoom,
    );

    return GoogleMap(
      initialCameraPosition: initialPosition,
      onMapCreated: _onMapCreated,
      onTap: (LatLng position) {
        widget.onMapTap?.call(position.latitude, position.longitude);
      },
      markers: _markers,
      myLocationEnabled: widget.showCurrentLocation,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: true,
      compassEnabled: true,
      trafficEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: true,
      liteModeEnabled: false,
      mapType: MapType.normal,
    );
    */
  }

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[100]!,
            Colors.green[100]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: MapGridPainter(),
            ),
          ),
          
          // Markers simulation
          ...widget.markers.map((marker) => Positioned(
            left: marker.position.dx,
            top: marker.position.dy,
            child: GestureDetector(
              onTap: () => marker.onTap?.call(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: marker.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  marker.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          )),
          
          // Current location indicator
          if (widget.showCurrentLocation && _currentPosition != null)
            Positioned(
              left: 150,
              top: 200,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          
          // Info overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF2E7D5A),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Map simulation - Ready for Google Maps API',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D5A),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _showSetupInstructions,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text(
                      'Setup',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSetupInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Google Maps Setup'),
        content: const SingleChildScrollView(
          child: Text(
            'To enable Google Maps:\n\n'
            '1. Get Google Maps API key\n'
            '2. Add to app_constants.dart\n'
            '3. Configure Android/iOS\n'
            '4. Uncomment GoogleMap widget\n\n'
            'See docs/google_maps_setup.md for detailed instructions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

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