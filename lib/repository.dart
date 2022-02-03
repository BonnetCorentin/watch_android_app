import 'dart:convert';

import 'package:watch_android_app/localisation_model.dart';

import 'distance_model.dart';
import 'http_request.dart';

class LocalisationRepository {
  Future<Localisation> postLocalisation(Localisation localisation) async {
    final String json = jsonEncode(localisation);
    final location =
        await HttpRequest.postRequest("/localisation/post_localisation", json);

    return Localisation.fromJson(location);
  }
}

class DistanceRepository {
  Future<Distance> getDistance() async {
    final distance =
        await HttpRequest.getRequest(endpoint: "localisation/get_distance");

    return Distance.fromJson(distance);
  }
}
