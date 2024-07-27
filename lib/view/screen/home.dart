import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:gst_task/cubits/weather/weather_cubit.dart';
import 'package:gst_task/model/models/weatherinfo.dart';
import 'package:gst_task/view/screen/search.dart';
import 'package:gst_task/view/widgets/error_dialog.dart';
import 'package:gst_task/view/widgets/forecastWid.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   late ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String? _city;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectionStatus = ConnectivityResult.none;
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    context.read<WeatherCubit>().fetchWeather('cairo');
  }

Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('By:tarek'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));
                if (_city != null) {
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              },
              icon: const Icon(Icons.search)),
          
        ],
      ),
      body:(_connectionStatus==ConnectivityResult.none)?_nointernet() : _content(),
    );
  }

  Widget _nointernet()
  {
    return const Center(child: Text(
              "No Internet",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),),);
  }

  String showTemp(double temperature) {
    return '${temperature.toStringAsFixed(2)}℃';
  }

  Widget showIcon(String state) {
    String img="Clear";
    switch(state)
    {
      case "Clear":
        img="Clear";
        break;
      case "Clouds":
        img="Clouds";
        break;
      case "Rain":
        img="Rain";
        break;
      default:
        img="Clear";
        break;
    }
    return LottieBuilder.asset('assets/$img.json',height: 150,width: 150,);
  }

  Widget descText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _content() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Coould not find location',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
            showIcon(state.weather.main),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: descText(state.weather.description),
                ),
                const Spacer(),
              ],
            ),

            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemp(state.weather.temp),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20.0),
               
              ],
            ),
            const SizedBox(height: 40.0),
            
            SizedBox(
              width: double.infinity,
              height: 200,
              child: ListView.builder(

                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Weather weth=state.foreCasts[index];
                  return Card(
                    elevation: 20,
                    color: const Color.fromARGB(255, 207, 207, 207),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ForecastWid('Day ${index+1}',weth.temp.toString(),weth.description,weth.icon),
                    ));} ,),
            )
          ],
        );
      },
    );
  }
}
