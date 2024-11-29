import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_test_app/models/weather_model.dart';
import 'package:weather_test_app/views/home/home_bloc/event.dart';
import 'package:weather_test_app/views/home/home_bloc/home_bloc.dart';
import 'package:weather_test_app/views/home/home_bloc/state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController nameCity;
  late Timer _timer;
  @override
  void initState() {
    nameCity = TextEditingController();
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      context.read<HomeBloc>().add(GetCurrentWeatherEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    nameCity.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, state) {
            if (state is Inite) {
              context.read<HomeBloc>().add(GetCurrentWeatherEvent());
            }
            if (state is LoudingState) {
              nameCity.clear();
              return _louding();
            }
            if (state is ErrorState) {
              return _errorMsg(state.msg);
            }
            if (state is Success) {
              return _displayResult(state.weatherModel, state.msg);
            }
            return const Text('end');
          },
        ),
      ),
    );
  }

  Widget _louding() {
    return const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator(), Text('Louding ...')],
      ),
    );
  }

  Widget _errorMsg(String? msg) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Error : \n $msg!',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
        _btn('Обновить', color: Colors.blue, () {
          context.read<HomeBloc>().add(GetCurrentWeatherEvent());
        }),
      ],
    ));
  }

  Widget _displayResult(WeatherModel weatherModel, [String? msg]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  msg ?? 'okay',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Расположение :',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              textAlign: TextAlign.center,
              "страна : ${weatherModel.country}- город : ${weatherModel.name} - область : ${weatherModel.region}",
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'текущая погода : ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "темп : ${weatherModel.temp}- статус : ${weatherModel.text} - последнее_обновление : ${weatherModel.lastUpdated}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Следующее автоматическое обновление через час",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blue, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 2,
              thickness: 3.0,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'поиск города английскими буквами',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                controller: nameCity,
                decoration: const InputDecoration(
                    hintText: 'Поиск', icon: Icon(Icons.search)),
              ),
            ),
            _btn('Поиск', () {
              if (nameCity.text.isEmpty) return;
              context
                  .read<HomeBloc>()
                  .add(GetCurrentWeatherEvent(city: nameCity.text));
            }),
            _btn('Обновить', color: Colors.blue, () {
              context.read<HomeBloc>().add(GetCurrentWeatherEvent());
            }),
          ],
        ),
      ),
    );
  }

  Widget _btn(String lable, Function() onTap, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.black,
          disabledBackgroundColor: color ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Center(
              child: Text(
            lable,
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
