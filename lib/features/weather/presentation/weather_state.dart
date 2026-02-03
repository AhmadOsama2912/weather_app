import 'package:equatable/equatable.dart';
import '../domain/weather_bundle.dart';

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
  final WeatherBundle data;
  const WeatherSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class WeatherError extends WeatherState {
  final String message;
  final bool canOpenSettings;

  const WeatherError({
    required this.message,
    this.canOpenSettings = false,
  });

  @override
  List<Object?> get props => [message, canOpenSettings];
}
