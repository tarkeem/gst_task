import '../../utils/weather_exception.dart';
import '../models/custom_error.dart';
import '../models/geocoding.dart';
import '../models/weatherinfo.dart';
import '../../services/api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      //print('directGeocoding: $directGeocoding');
      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);


      final Weather weather = tempWeather.copyWith(
        name: directGeocoding.name,
        country: directGeocoding.country,
      );
      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
  Future<List<Weather>> fetchForeCast(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      //print('directGeocoding: $directGeocoding');
      final List<Weather> forecast =
          await weatherApiServices.getForeCast(directGeocoding);
          

      return forecast;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}