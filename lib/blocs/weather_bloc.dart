import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menk_weather/repositories/weather_repository.dart';
import 'package:menk_weather/models/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  List<Weather> previousWeather = [];

  WeatherBloc(this.weatherRepository) : super(WeatherLoading()) {
    on<FetchWeather>(_onFetchWeather);
    on<LoadSavedWeather>(_onLoadSavedWeather);

    // Uygulama başlatıldığında kaydedilmiş hava durumu verilerini yükle
    add(LoadSavedWeather());
  }

  void _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.fetchWeather(event.city);
      previousWeather.add(weather);
      emit(WeatherLoaded(previousWeather, weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  void _onLoadSavedWeather(
      LoadSavedWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      previousWeather = await weatherRepository.getSavedWeather();

      if (previousWeather.isNotEmpty) {
        final uniquePreviousWeather = <String, Weather>{};
        for (var weather in previousWeather) {
          uniquePreviousWeather[weather.name] = weather;
        }
        previousWeather = uniquePreviousWeather.values.toList();
        emit(WeatherLoaded(previousWeather, previousWeather.last));
      } else {
        emit(WeatherLoaded([], null));
      }
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
