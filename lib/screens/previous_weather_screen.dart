import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menk_weather/blocs/weather_bloc.dart';
import 'package:menk_weather/widgets/weather_card.dart';

class PreviousWeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Weather'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            return ListView.builder(
              itemCount: state.weather.length,
              itemBuilder: (context, index) {
                return WeatherCard(weather: state.weather[index]);
              },
            );
          } else if (state is WeatherError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No previous weather data'));
          }
        },
      ),
    );
  }
}
