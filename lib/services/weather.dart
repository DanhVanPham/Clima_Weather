import 'package:clima_app/services/location.dart';

import 'networking.dart';
import 'package:clima_app/utilities/constants.dart';

String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  dynamic getLocationWeather(Location location) async {
    NetWorkingHelper netWorkingHelper = NetWorkingHelper(
        '$baseUrl?lat=${location.getLatitude()}&lon=${location.getLongitude()}&appid=$apiWeatherKey&units=metric');
    return await netWorkingHelper.getData();
  }

  dynamic getWeatherByCityName({required String cityName}) async {
    try {
      NetWorkingHelper netWorkingHelper = NetWorkingHelper(
          '$baseUrl?q=$cityName&appid=$apiWeatherKey&units=metric');
      return await netWorkingHelper.getData();
    } catch (e) {
      print(e);
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
