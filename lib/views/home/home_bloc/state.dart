import 'package:weather_test_app/models/weather_model.dart';

abstract class HomeState {}

class Inite extends HomeState {}

class LoudingState extends HomeState {}

class ErrorState extends HomeState {
  String? msg;
  ErrorState({this.msg});
}

class Success extends HomeState {
  WeatherModel weatherModel;
  String? msg;
  Success({required this.weatherModel, this.msg});
}
