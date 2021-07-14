import 'package:clima_app/services/location.dart';
import 'package:flutter/material.dart';
import 'package:clima_app/utilities/constants.dart';
import 'package:clima_app/services/weather.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'city_screen.dart';
import 'map_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weatherData});
  final weatherData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  late int temperature;
  late int condition;
  late String cityName, icon, message;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      print(weatherData);
      if (weatherData == '' || weatherData == null) {
        temperature = 0;
        condition = 0;
        cityName = "";
        icon = 'Error';
        message = "Unable to get weather data";
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      condition = weatherData['weather'][0]['id'];
      cityName = weatherData['sys']['country'];
      icon = weatherModel.getWeatherIcon(temperature);
      message = weatherModel.getMessage(condition);
      print(cityName);
    });
  }

  void updateLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    var weatherData = await weatherModel.getLocationWeather(location);
    updateUI(weatherData);
  }

  void getWeatherByCity(String valueInput) async {
    WeatherModel weatherModel = WeatherModel();
    var weatherData =
        await weatherModel.getWeatherByCityName(cityName: valueInput);
    updateUI(weatherData);
  }

  void getCurrentPosition() async {
    Location location = Location();
    await location.getCurrentLocation();
    LatLng pos =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MapScreen(
        location: location,
      );
    }));
    print(pos);
    getLocationByLatLng(pos);
  }

  void getLocationByLatLng(LatLng pos) async {
    Location location = Location();
    location.setLatitude(pos.latitude);
    location.setLongitude(pos.longitude);
    WeatherModel weatherModel = WeatherModel();
    var weatherData = await weatherModel.getLocationWeather(location);
    print(weatherData);
    updateUI(weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      updateLocation();
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      getCurrentPosition();
                    },
                    child: Icon(
                      Icons.map_outlined,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var valueInput = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      if (valueInput != null && valueInput != '') {
                        getWeatherByCity(valueInput);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature',
                      style: kTempTextStyle,
                    ),
                    Text(
                      icon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$message in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
