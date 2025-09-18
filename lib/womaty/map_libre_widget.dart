import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:http/http.dart' as http;

class MapLibreWidget extends StatefulWidget {
  const MapLibreWidget({super.key});

  @override
  State<MapLibreWidget> createState() => _MapLibreWidgetState();
}

class _MapLibreWidgetState extends State<MapLibreWidget> {
  MapLibreMapController? mapController;

  final String apiKey = dotenv.get('MAPKEY'); // from .env
  final String mapName = "WomatyMap"; // AWS Location Map Name

  // Location for the marker (Mumbai)
  final LatLng markerLatLng = const LatLng(18.9582, 72.8321);

  void _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;

    controller.symbolManager = SymbolManager(controller);

    // Load custom marker icon from assets
    final ByteData bytes = await rootBundle.load("assets/marker_pin_avatar.png");
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage("customMarker", list);
  }

  Future<void> _addMarker() async {
    print(mapController!.symbols);
    if (mapController == null) return;

    // Move camera to the marker position
    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(markerLatLng, 15),
    );

    // Add the symbol
    final sym = await mapController!.addSymbol(
      SymbolOptions(
        geometry: markerLatLng,
        iconImage: "customMarker", // the one we added in _onMapCreated
        iconSize: 100,
        textField: "Mumbai",
        textOffset: const Offset(0, 0),
      ),
    );

    debugPrint("Symbol added: ${sym.toGeoJson()}");
  }

  Future<void> addImageFromUrl(String name, Uri uri) async {
    final response = await http.get(uri);
    return mapController!.addImage(name, response.bodyBytes);
  }

  void _add(String iconImage) {
    final availableNumbers = Iterable<int>.generate(12).toList();
    for (final s in mapController!.symbols) {
      availableNumbers.removeWhere((i) => i == s.data!['count']);
    }
    if (availableNumbers.isNotEmpty) {
      mapController!.addSymbol(
          _getSymbolOptions(iconImage, availableNumbers.first),
          {'count': availableNumbers.first});
      setState(() {
        // _symbolCount += 1;
      });
    }
  }

  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount) {
    final geometry = LatLng(
      markerLatLng.latitude + sin(symbolCount * pi / 6.0) / 20.0,
      markerLatLng.longitude + cos(symbolCount * pi / 6.0) / 20.0,
    );
    return iconImage == 'customFont'
        ? SymbolOptions(
      geometry: geometry,
      iconImage: 'custom-marker',
      //'airport-15',
      fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
      textField: 'Airport',
      textSize: 12.5,
      textOffset: const Offset(0, 0.8),
      textAnchor: 'top',
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    )
        : SymbolOptions(
      geometry: geometry,
      textField: 'Airport',
      textOffset: const Offset(0, 0.8),
      iconImage: iconImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        styleString:
        "https://maps.geo.ap-southeast-2.amazonaws.com/maps/v0/maps/$mapName/style-descriptor?key=$apiKey",
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.9952463, 72.8245883), // initial position
          zoom: 12,
        ),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        compassEnabled: true,
        compassViewPosition: CompassViewPosition.bottomLeft,
        compassViewMargins: const Point(15, 15),
        onMapClick: (point, coordinates) {
          print(coordinates);
          _add("networkImage");
        },
        myLocationRenderMode: MyLocationRenderMode.normal,
        myLocationTrackingMode: MyLocationTrackingMode.tracking,
        onStyleLoadedCallback: () {
          print("style loaded");
          addImageFromUrl("networkImage", Uri.parse("https://dummyimage.com/50x50"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarker,
        child: const Icon(Icons.location_pin),
      ),
    );
  }

}
