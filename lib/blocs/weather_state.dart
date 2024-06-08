part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<Weather> weather;
  final Weather? currentWeather;

  const WeatherLoaded(this.weather, this.currentWeather);

  @override
  List<Object?> get props => [weather, currentWeather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
