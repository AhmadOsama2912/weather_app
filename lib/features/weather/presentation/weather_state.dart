import 'package:equatable/equatable.dart';
import '../domain/weather.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherSuccess extends WeatherState {
  final Weather weather;
  const WeatherSuccess(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  final bool canOpenSettings;
  const WeatherError(this.message, {this.canOpenSettings = false});

  @override
  List<Object?> get props => [message, canOpenSettings];
}
