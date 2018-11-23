import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTypes {
  const MapTypes({this.title});

  final String title;
}

const List<MapTypes> types = const <MapTypes>[
  const MapTypes(title: 'Normal'),
  const MapTypes(title: 'Hybrid'),
  const MapTypes(title: 'Satellite'),
  const MapTypes(title: 'Terrain'),
];

void main() {
  runApp(MyMapApp());
}

class MyMapApp extends StatefulWidget {
  @override
  _MyMapAppState createState() => new _MyMapAppState();
}

class _MyMapAppState extends State<MyMapApp> {
  GoogleMapController mapController;
  CameraPosition _position;

  GoogleMapOptions _options = GoogleMapOptions(
    cameraPosition: const CameraPosition(
      target: LatLng(23.0225, 72.5714),
      zoom: 11.0,
    ),
    trackCameraPosition: true,
    compassEnabled: true,
  );
  bool _isMoving = false;

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  ///
  void _select(MapTypes types) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      if (types.title == "Normal") {
        _mapOptions(MapType.normal);
      } else if (types.title == "Hybrid") {
        _mapOptions(MapType.hybrid);
      } else if (types.title == "Satellite") {
        _mapOptions(MapType.satellite);
      } else if (types.title == "Terrain") {
        _mapOptions(MapType.terrain);
      }
    });
  }

  ///
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _mapInfo();
    setState(() {});
  }

  ///
  void _onMapChanged() {
    setState(() {
      _mapInfo();
    });
  }

  ///
  void _mapInfo() {
    _options = mapController.options;
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps demo'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.pin_drop),
              onPressed: () {
                dropMarker();
              },
            ),
            PopupMenuButton<MapTypes>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return types.map((MapTypes types) {
                  return PopupMenuItem<MapTypes>(
                    value: types,
                    child: Text(types.title),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: onMapCreated,
              options: _options,
            ),
            InfoView(isMoving: _isMoving, position: _position),
          ],
        ),
      ),
    );
  }

  ///
  void _mapOptions(MapType type) {
    mapController.updateMapOptions(
      GoogleMapOptions(
        compassEnabled: true,
        trackCameraPosition: true,
        mapType: type,
        cameraPosition: const CameraPosition(
          target: LatLng(23.0225, 72.5714),
          zoom: 11.0,
        ),
      ),
    );
  }

  ///Drop marker at the Ahmedabad
  void dropMarker() {
    mapController.clearMarkers();
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(23.0225, 72.5714),
        draggable: false,
        infoWindowText: InfoWindowText("Ahmedabad,", "India"),
        consumeTapEvents: true,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }
}

class InfoView extends StatelessWidget {
  const InfoView({
    Key key,
    @required bool isMoving,
    @required CameraPosition position,
  })  : _isMoving = isMoving,
        _position = position,
        super(key: key);

  final bool _isMoving;
  final CameraPosition _position;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _isMoving ? "Map is moving" : "Map is Idle",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _position != null ? _position.target.toString() : "",
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
