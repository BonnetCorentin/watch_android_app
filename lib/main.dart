import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:watch_android_app/repository.dart';

import 'distance_model.dart';
import 'localisation_model.dart';
import 'dart:math';

import 'map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final longitudeFinal = 4.868577;
  final latitudeFinal = 45.779595;
  final LocalisationRepository localisationRepository =
      LocalisationRepository();
  final DistanceRepository distanceRepository = DistanceRepository();

  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Localisation localisation;
  late String _currentAddress;
  late Distance distance;
  late Timer? timer;

  bool map = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 3), (Timer t) => _incrementCounter());
  }

  void mapBool() {
    setState(() {
      map = true;
    });
  }

  void _incrementCounter() {
    setState(() {
      getDistance();
      getPosition();
    });
  }

  void getDistance() async {
    distance = await widget.distanceRepository.getDistance();
    print(distance.distance);
  }

  void computeDistance() {
    double finalLatitudeRad = (widget.latitudeFinal * 0.01746031);
    double finalLongitudeRad = (widget.longitudeFinal * 0.01746031);

    double latitudeRad = (localisation.latitude! * 0.01746031);
    double longitudeRad = (localisation.longitude! * 0.01746031);

    double distanceMax = 6378.8 *
        acos((sin(latitudeRad) * sin(finalLatitudeRad)) +
            cos(latitudeRad) *
                cos(finalLatitudeRad) *
                cos(finalLongitudeRad - longitudeRad));

    print(distanceMax);

    if (distanceMax > distance.distance!) {
      mapBool();
    }
  }

  void getPosition() async {
    await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true,
            desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        localisation = Localisation(
            date: date.toString(),
            latitude: position.latitude,
            longitude: position.longitude);

        try {
          widget.localisationRepository.postLocalisation(localisation);
          computeDistance();
        } on Exception catch (e) {
          print(e);
        }
        _getAddressFromLatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print(e);
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        //Pass the lat and long to the function
        _getAddressFromLatLng(position.latitude, position.longitude);
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !map
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Application Distance',
                ),
              ],
            ))
          : MapApp(
              localisation: localisation,
              wantedLocalisation: Localisation(
                  latitude: widget.latitudeFinal,
                  longitude: widget.longitudeFinal),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Get localisation',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
