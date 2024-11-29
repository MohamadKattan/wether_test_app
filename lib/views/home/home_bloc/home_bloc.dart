import 'package:bloc/bloc.dart';
import 'package:weather_test_app/http_srv/http_srv.dart';
import 'package:weather_test_app/models/result_model.dart';
import 'package:weather_test_app/models/weather_model.dart';
import 'package:weather_test_app/views/home/home_bloc/event.dart';
import 'package:weather_test_app/views/home/home_bloc/state.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc() : super(Inite()) {
    on<GetCurrentWeatherEvent>(_getCurrentWeather);
  }

  Future<void> _getCurrentWeather(
      GetCurrentWeatherEvent event, Emitter<HomeState> emit) async {
    try {
      emit(LoudingState());
      // String newCity = ''
      // if(event.city!=null){

      // }
      final result = await HttpSrv().getData(city:event.city);
      if (result.status == ResultsLevel.fail) {
        return emit(
            ErrorState(msg: result.data['error']['message'] ?? 'error**'));
      }
      final weatherModel = WeatherModel.fromjson(result.data);
      emit(Success(
          weatherModel: weatherModel,
          msg: 'Результат погоды'));
    } catch (e) {
      return emit(ErrorState(msg: e.toString()));
    }
  }
}
