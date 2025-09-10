import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? controller;
  CameraPosition? initialPosition;
  Set<Marker> markers = {};
  dynamic styleJson = [
    {
      "elementType": "geometry",
      "stylers": [
        {"color": "#212121"}
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#757575"}
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {"color": "#212121"}
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {"color": "#757575"}
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#9e9e9e"}
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#bdbdbd"}
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#757575"}
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {"color": "#181818"}
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#616161"}
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [
        {"color": "#1b1b1b"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [
        {"color": "#2c2c2c"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#8a8a8a"}
      ]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [
        {"color": "#373737"}
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {"color": "#3c3c3c"}
      ]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [
        {"color": "#4e4e4e"}
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#616161"}
      ]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#757575"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {"color": "#000000"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#3d3d3d"}
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
    _addCustomMarker();
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final location = await Geolocator.getCurrentPosition();
      setState(() {
        initialPosition = CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 15,
        );
      });
    } else {
      // Fallback: New Delhi
      setState(() {
        initialPosition = const CameraPosition(
          target: LatLng(28.6139, 77.2090),
          zoom: 10,
        );
      });
    }
  }

  Future<void> _addCustomMarker() async {
    final customIcon = await const CustomMarkerWidget().toBitmapDescriptor(
      logicalSize: const Size(150, 150),
      imageSize: const Size(150, 150),
    );

    final marker = Marker(
      markerId: const MarkerId("1"),
      position: const LatLng(18.996, 72.828),
      draggable: true,
      alpha: 0.9,
      infoWindow: const InfoWindow(
        title: "Hello Vikrant",
        snippet: "Hey Whatsapp",
      ),
      icon: customIcon,
    );

    setState(() {
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialPosition != null
          ? GoogleMap(
              initialCameraPosition: initialPosition!,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              // markers: markers,
              style: jsonEncode(styleJson),
              zoomControlsEnabled: false,
              heatmaps: {
                Heatmap(
                  heatmapId: HeatmapId("1"),
                  data: [
                    WeightedLatLng(LatLng(18.0, 72.0), weight: 1),
                    WeightedLatLng(LatLng(18.0, 72.0), weight: 5),
                    WeightedLatLng(LatLng(18.0, 72.0), weight: 15),
                    WeightedLatLng(LatLng(18.0, 72.0), weight: 20),
                    WeightedLatLng(LatLng(18.0, 72.0), weight: 10),
                  ],
                  radius: HeatmapRadius.fromPixels(75),
                  gradient: HeatmapGradient(
                    [
                      HeatmapGradientColor(Colors.green, 0.2),
                      HeatmapGradientColor(Colors.red, 1),
                    ],
                  ),
                ),
                Heatmap(
                  heatmapId: HeatmapId("2"),
                  data: [
                    WeightedLatLng(LatLng(19, 73), weight: 1),
                    WeightedLatLng(LatLng(19, 73), weight: 5),
                    WeightedLatLng(LatLng(19, 73), weight: 10),
                    WeightedLatLng(LatLng(19, 73), weight: 15),
                    WeightedLatLng(LatLng(19, 73), weight: 20),
                  ],
                  radius: HeatmapRadius.fromPixels(75),
                  gradient: HeatmapGradient(
                    [
                      HeatmapGradientColor(Colors.green, 0.2),
                      HeatmapGradientColor(Colors.red, 1),
                    ],
                  ),
                ),
                Heatmap(
                  heatmapId: HeatmapId("3"),
                  data: [
                    WeightedLatLng(LatLng(18.996, 72.828), weight: 1),
                    WeightedLatLng(LatLng(18.996, 72.828), weight: 5),
                    WeightedLatLng(LatLng(18.996, 72.828), weight: 10),
                    WeightedLatLng(LatLng(18.996, 72.828), weight: 15),
                    WeightedLatLng(LatLng(18.996, 72.828), weight: 20),
                  ],
                  radius: HeatmapRadius.fromPixels(75),
                  gradient: HeatmapGradient(
                    [
                      HeatmapGradientColor(Colors.green, 0.2),
                      HeatmapGradientColor(Colors.red, 1),
                    ],
                  ),
                ),
                Heatmap(
                  heatmapId: HeatmapId("4"),
                  data: [
                    WeightedLatLng(LatLng(17, 72.828), weight: 1),
                    WeightedLatLng(LatLng(17, 72.828), weight: 5),
                    WeightedLatLng(LatLng(17, 72.828), weight: 10),
                    WeightedLatLng(LatLng(17, 72.828), weight: 15),
                    WeightedLatLng(LatLng(17, 72.828), weight: 20),
                  ],
                  radius: HeatmapRadius.fromPixels(75),
                  gradient: HeatmapGradient(
                    [
                      HeatmapGradientColor(Colors.green, 0.2),
                      HeatmapGradientColor(Colors.red, 1),
                    ],
                  ),
                ),
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class CustomMarkerWidget extends StatelessWidget {
  const CustomMarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        color: Colors.blue,
      ),
      child: Center(child: Image.asset("assets/marker_pin_avatar.png", width: 150, height: 150)
          // child: Icon(
          //   Icons.person,
          //   color: Colors.white,
          //   size: 50,
          // ),
          ),
    );
  }
}
