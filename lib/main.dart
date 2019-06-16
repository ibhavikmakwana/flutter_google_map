import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Google Map",
      home: MyMap(),
    );
  }
}

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  GoogleMapController _mapController;
  MapType _type = MapType.normal;
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  static final _options = CameraPosition(
    target: LatLng(23.0225, 72.5714),
    zoom: 11,
  );

  bool _nightMode = false;

  @override
  void dispose() {
    super.dispose();
  }

  ///
  void _select(MapTypes types) {
    // Causes the app to rebuild with the selected choice.
    setState(() {
      if (types.title == "Normal") {
        _type = MapType.normal;
      } else if (types.title == "Hybrid") {
        _type = MapType.hybrid;
      } else if (types.title == "Satellite") {
        _type = MapType.satellite;
      } else if (types.title == "Terrain") {
        _type = MapType.terrain;
      }
    });
  }

  ///
  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: mapDrawer(),
      ),
      appBar: AppBar(
        title: const Text('Google Maps demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              _nightMode ? Icons.brightness_3 : Icons.brightness_5,
            ),
            onPressed: () {
              _nightModeToggle();
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
            initialCameraPosition: _options,
            onMapCreated: onMapCreated,
            mapType: _type,
            circles:  Set<Circle>.of(circles.values),
            myLocationEnabled: true,
          ),
//          InfoView(isMoving: _isMoving, position: _position),
        ],
      ),
    );
  }

  void _nightModeToggle() {
    if (_nightMode) {
      setState(() {
        _nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData('asset/night_mode.json').then((style) {
        setState(() {
          _nightMode = true;
          _mapController.setMapStyle(style);
        });
      });
    }
  }

  mapDrawer() {
    return ListView(
      children: <Widget>[
        _createDrawerListTile("Add Marker", addMarker),
        _createDrawerListTile("Add Circle", addCircle),
        _createDrawerListTile("Add Polyline", addPolyline),
      ],
    );
  }

  _createDrawerListTile(String listTitle, VoidCallback callback) {
    return ListTile(
      title: Text(listTitle),
      onTap: callback,
    );
  }

  void addMarker() {
//    _mapController.clearMarkers();
//    _mapController.addMarker(
//      MarkerOptions(
//        position: LatLng(23.0225, 72.5714),
//        draggable: false,
//        infoWindowText: InfoWindowText("Ahmedabad,", "India"),
//        consumeTapEvents: true,
//        icon: BitmapDescriptor.defaultMarker,
//      ),
//    );
  }

  void addCircle() {
    final Circle circle = Circle(
      circleId: CircleId("1"),
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      fillColor: Colors.green,
      strokeWidth: 5,
      radius: 50000,
      onTap: () {},
    );

    setState(() {
      circles[CircleId("1")] = circle;
    });
  }

  void addPolyline() {}

  ///Drop marker at the Ahmedabad
//  void dropMarker() {
//    mapController.clearMarkers();
//    mapController.addMarker(
//      MarkerOptions(
//        position: LatLng(23.0225, 72.5714),
//        draggable: false,
//        infoWindowText: InfoWindowText("Ahmedabad,", "India"),
//        consumeTapEvents: true,
//        icon: BitmapDescriptor.defaultMarker,
//      ),
//    );
//  }
}

//class InfoView extends StatelessWidget {
//  const InfoView({
//    Key key,
//    @required bool isMoving,
//    @required CameraPosition position,
//  })  : _isMoving = isMoving,
//        _position = position,
//        super(key: key);
//
//  final bool _isMoving;
//  final CameraPosition _position;
//
//  @override
//  Widget build(BuildContext context) {
//    return Align(
//      alignment: Alignment.bottomRight,
//      child: Container(
//        width: double.infinity,
//        margin: EdgeInsets.all(8.0),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(8.0),
//          color: Colors.white,
//        ),
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                _isMoving ? "Map is moving" : "Map is Idle",
//                style: TextStyle(fontSize: 24.0),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(
//                _position != null ? _position.target.toString() : "",
//                style: TextStyle(fontSize: 24.0),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
