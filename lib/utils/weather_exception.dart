class WeatherException implements Exception {
  String message;
  WeatherException([this.message = 'Error']) {
    message = 'Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
