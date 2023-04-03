import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_and_google_maps/my_location_provider.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MyLocationProvider myLocationProvider = MyLocationProvider();
  GoogleMapController? mapController = null;
  CameraPosition initialPosition = CameraPosition(
    target: LatLng(30.5856385, 31.4821114),
    zoom: 15,
    // tilt: //يمين وشمال وفوق وتحت تحريك الزاوية تقريبا
  );
  static const String initialMarkerId = 'initialMarkerId';
  Set<Marker> markers = {
    Marker(
      markerId: MarkerId(initialMarkerId),
      position: LatLng(30.5856385, 31.4821114),
    )
  };
  @override
  void initState() {
    super.initState();
    trackUserLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialPosition,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              myLocationEnabled: true,
              compassEnabled: true,
              // onTap: handleTap,
              markers: markers,
            ),
          ),
        ],
      ),
    );
  }
  StreamSubscription<LocationData>? locationListener = null;
  static const String userMarkerId = 'markerId';
  void trackUserLocation() async {
    // var locationData = await myLocationProvider.getLocation();
    // print(locationData?.latitude);
    // print(locationData?.longitude);
    // ///fake location or not ///tracking locations
    // print(locationData?.isMock);
    // setState(() {});
    myLocationProvider.locationManager.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 3000,
      distanceFilter:10
    );
     locationListener = myLocationProvider.trackUserLocation().listen((newLocation) {
      print(newLocation.latitude);
      print(newLocation.longitude);
      Marker userMarker = Marker(
          markerId: const MarkerId(userMarkerId),
          position:
              LatLng(newLocation.longitude ?? 0, newLocation.latitude ?? 0));
      markers.add(userMarker);
      mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(newLocation.latitude??0, newLocation.longitude??0), 15));
      setState(() {});
    });
  }
  @override
  void dispose() {
    super.dispose();
    locationListener?.cancel();
  }
  // handleTap(LatLng point) {
  //   setState(() {
  //     markers.add(Marker(
  //       markerId: MarkerId(point.toString()),
  //       position: point,
  //       infoWindow: InfoWindow(
  //         title: 'I am a marker',
  //       ),
  //       icon:
  //       BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
  //     ));
  //   });
  // }
}

/*sample of google maps
* class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}*/
