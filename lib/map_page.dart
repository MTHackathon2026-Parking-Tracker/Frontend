import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  final String permitColor;

  const MapPage({
    super.key,
    required this.permitColor,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  static const CameraPosition startPosition = CameraPosition(
    target: LatLng(35.8480, -86.3660), // MTSU
    zoom: 15,
  );

  Set<Polygon> polygons = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadLots();
  }

  void loadLots() {

    // FAKE DATA (use backend later)

    if (widget.permitColor == "red") {

      polygons.add(
        Polygon(
          polygonId: const PolygonId("redLot"),
          points: const [
            LatLng(35.8485, -86.3662),
            LatLng(35.8487, -86.3655),
            LatLng(35.8481, -86.3653),
            LatLng(35.8479, -86.3660),
          ],
          fillColor: Colors.red.withOpacity(0.4),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ),
      );

      markers.add(
        const Marker(
          markerId: MarkerId("redMarker"),
          position: LatLng(35.8483, -86.3658),
          infoWindow: InfoWindow(
            title: "Red Lot",
            snippet: "42 spots available",
          ),
        ),
      );
    }

    if (widget.permitColor == "green") {

      polygons.add(
        Polygon(
          polygonId: const PolygonId("greenLot"),
          points: const [
            LatLng(35.8495, -86.3672),
            LatLng(35.8497, -86.3665),
            LatLng(35.8491, -86.3663),
            LatLng(35.8489, -86.3670),
          ],
          fillColor: Colors.green.withOpacity(0.4),
          strokeColor: Colors.green,
          strokeWidth: 2,
        ),
      );

      markers.add(
        const Marker(
          markerId: MarkerId("greenMarker"),
          position: LatLng(35.8493, -86.3668),
          infoWindow: InfoWindow(
            title: "Green Lot",
            snippet: "18 spots available",
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.permitColor.toUpperCase()} Parking"),
      ),
      body: GoogleMap(
        initialCameraPosition: startPosition,
        polygons: polygons,
        markers: markers,
      ),
    );
  }
}