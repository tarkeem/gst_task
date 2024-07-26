import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gst_task/cubits/weather/weather_cubit.dart';
import 'package:gst_task/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'view/screen/home.dart';
import 'model/repositories/weather_repository.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiServices(httpClient: http.Client())),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
         
        ],
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
