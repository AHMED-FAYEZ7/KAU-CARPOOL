// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kau_carpool/constants.dart';

// use it to call api

class PlacesWebservices {
  late Dio dio;

  PlacesWebservices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }
// send search place call
  Future<List<dynamic>> fetchSuggestions(
    String place,
    String sessionToken,
  ) async {
    try {
      Response response = await dio.get(
        suggestionsBaseUrl,
        queryParameters: {
          'input': place,
          'types': 'address',
          'components': 'country:sa',
          'key': googleAPIKey,
          'sessiontoken': sessionToken
        },
      );
      print(response.data['predictions']);
      print(response.statusCode);
      return response.data['predictions'];
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

// send destination place api call
  Future<dynamic> getPlaceLocation(String placeId, String sessionToken) async {
    try {
      Response response = await dio.get(
        placeLocationBaseUrl,
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry',
          'key': googleAPIKey,
          'sessiontoken': sessionToken
        },
      );
      return response.data;
    } catch (error) {
      return Future.error(
        "Place location error : ",
        StackTrace.fromString(
          ('this is its trace'),
        ),
      );
    }
  }

  // origin equals current location
  // destination equals searched for location
  Future<dynamic> getDirections(LatLng origin, LatLng destination) async {
    try {
      Response response = await dio.get(
        directionsBaseUrl,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': googleAPIKey,
        },
      );
      print("I'm testing directions");
      print(response.data);
      return response.data;
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }

  static Future<String> getAddressFromCoordinates(
    double lat,
    double lng,
  ) async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        addressBaseUrl,
        queryParameters: {
          'latlng': '${lat},${lng}',
          'key': googleAPIKey,
        },
      );
      List<dynamic> address = response.data["results"][0]["address_components"];
      String addressString = "";
      for (int i = 0; i < address.length; i++) {
        addressString += "${address[i]["long_name"]}, ";
      }
      return addressString.substring(0, addressString.length - 2);
    } catch (error) {
      return Future.error("Place location error : ",
          StackTrace.fromString(('this is its trace')));
    }
  }
}
