import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../utils/weather_exception.dart';
import '../model/models/geocoding.dart';
import '../model/models/weatherinfo.dart';
import 'http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;
  WeatherApiServices({
    required this.httpClient,
  });

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: wetherHost,
      path: '/geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': "1",
        'appid': "8951b635560630e9ad96e9cadc184348",
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }

      final responseBody = json.decode(response.body);


      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }

      final directGeocoding = DirectGeocoding.fromJson(responseBody);

      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: wetherHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.lon}',
        'units': kUnit,
        'appid': "8951b635560630e9ad96e9cadc184348",
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final weatherJson = json.decode(response.body);


      print(weatherJson);


      final Weather weather = Weather.fromJson(weatherJson);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Weather>> getForeCast(DirectGeocoding directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: wetherHost,
      path: '/data/2.5/forecast',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.lon}',
        'cnt': "5",
        'units': kUnit,
        'appid': "8951b635560630e9ad96e9cadc184348",
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final weatherJson = json.decode(response.body);

      print('.....................');

      //print(weatherJson);

        print('.....................');


      List<Weather>forecasts=[];
     for(int i=0;i<5;i++)
     {
     
         final Weather weather = Weather.fromJson(weatherJson['list'][i]);
         forecasts.add(weather);
     }
     print('////////////////');
      print(forecasts[1].temp);
     print('////////////////');

      return forecasts;
    } catch (e) {
      rethrow;
    }
  }
}
