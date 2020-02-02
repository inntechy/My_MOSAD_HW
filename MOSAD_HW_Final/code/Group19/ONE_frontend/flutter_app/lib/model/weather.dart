import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

//天气数据
//inntechy 2019.12.28

class WeatherData{
  String city;
  String cond;
  String temperature;
  ConnectionState state;

  getWeather()async{
    try{
      this.state = ConnectionState.waiting;
      var response = await Dio().get(
        "https://free-api.heweather.net/s6/weather/now?location=auto_ip&key=3bfbe671ba6c4ae19d4dfc6307d4b389"
      );
      this.city = response.data['HeWeather6'][0]['basic']['location'];
      //print(temp.city);
      this.cond = response.data['HeWeather6'][0]['now']['cond_txt'];
      this.temperature = response.data['HeWeather6'][0]['now']['tmp'];
    }catch(e){
      throw Error();
    }finally{
      this.state = ConnectionState.done;
    }
  }

  Future<String> getWeatherStr() async {
    this.state = ConnectionState.active;
    await getWeather();
    return this.city + '·' + this.cond + ' ' + this.temperature + '℃';
  }
}