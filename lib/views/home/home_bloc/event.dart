abstract class HomeEvents {}

class GetCurrentWeatherEvent extends HomeEvents {
  String? city;
  GetCurrentWeatherEvent({this.city});
}
