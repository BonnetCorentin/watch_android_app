import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'localisation_model.dart';

class MapApp extends StatefulWidget {
  const MapApp({
    Key? key,
    required this.localisation,
    required this.wantedLocalisation,
  }) : super(key: key);

  final Localisation localisation;
  final Localisation wantedLocalisation;

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  late PolylinePoints polylinePoints;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      markers: markers,
      polylines: Set<Polyline>.of(polylines.values),
      initialCameraPosition: CameraPosition(
        target: LatLng(
            widget.localisation.latitude!, widget.localisation.longitude!),
        zoom: 15,
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      markers.add(Marker(
        position: LatLng(
            widget.localisation.latitude!, widget.localisation.longitude!),
        markerId: const MarkerId("test"),
      ));
      // destination pin
      markers.add(Marker(
        markerId: const MarkerId("test2"),
        position: LatLng(widget.wantedLocalisation.latitude!,
            widget.wantedLocalisation.longitude!),
      ));
    });
  }

  setPolylines() async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyA64VjV9UgbD8bSuR9giTp8UkwFaLxaUU8",
        PointLatLng(
            widget.localisation.latitude!, widget.localisation.longitude!),
        PointLatLng(widget.wantedLocalisation.latitude!,
            widget.wantedLocalisation.longitude!),
        travelMode: TravelMode.walking);

    setState(() {
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      PolylineId id = const PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );

      polylines[id] = polyline;
    });
  }
}
