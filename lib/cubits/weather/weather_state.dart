part of 'weather_cubit.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final List<Weather>foreCasts;
  final WeatherStatus status;
  final Weather weather;
  final CustomError error;
  WeatherState({
    required this.status,
    required this.weather,
    required this.foreCasts,
    required this.error,
  });

  factory WeatherState.initial() {
    return WeatherState(
      status: WeatherStatus.initial,
      weather: Weather.initial(),
      foreCasts: [],
      error: const CustomError(),
    );
  }

  @override
  List<Object> get props => [status, weather, error];

  @override
  String toString() =>
      'WeatherState(status: $status, weather: $weather, error: $error)';

  WeatherState copyWith({
    WeatherStatus? status,
    Weather? weather,
    List<Weather>? foreCasts,
    CustomError? error,
  }) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      foreCasts:foreCasts??this.foreCasts ,
      error: error ?? this.error,
    );
  }
}
