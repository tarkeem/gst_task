import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/models/custom_error.dart';
import '../../model/models/weatherinfo.dart';
import '../../model/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);
       final List<Weather> forecasts = await weatherRepository.fetchForeCast(city);

      

      emit(state.copyWith(
        status: WeatherStatus.loaded,
        foreCasts: forecasts,
        weather: weather,
      ));
      print('state: $state');
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
      print('state: $state');
    }
  }
}
