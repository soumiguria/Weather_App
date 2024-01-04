import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error has occured';
      }

      return data;
      // temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Text(
                              '200 K',
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Icon(
                              Icons.cloud,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Rain',
                              style: TextStyle(fontSize: 20),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                //weather forecast cards
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HourlyForecastItem(
                        time: '00.00',
                        icon: Icons.cloud,
                        temperature: '300°F',
                      ),
                      HourlyForecastItem(
                        time: '00.00',
                        icon: Icons.sunny,
                        temperature: '300°F',
                      ),
                      HourlyForecastItem(
                        time: '00.00',
                        icon: Icons.cloud,
                        temperature: '300°F',
                      ),
                      HourlyForecastItem(
                        time: '00.00',
                        icon: Icons.sunny,
                        temperature: '300°F',
                      ),
                      HourlyForecastItem(
                        time: '00.00',
                        icon: Icons.cloud,
                        temperature: '300°F',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //additional information
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                          icon: Icons.water_drop_rounded,
                          label: 'Humidity',
                          value: '94'),
                      AdditionalInfoItem(
                          icon: Icons.air, label: 'Wind Speed', value: '7.5'),
                      AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: 'Pressure',
                          value: '1000'),
                    ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
