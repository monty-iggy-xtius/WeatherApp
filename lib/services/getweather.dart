import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weathermodel.dart';

// this class queries the weather api for the current weather data
class GetWeatherService {
  Future<WeatherModel> queryWeatherApi(String query) async {
    final queryParam = {
      'key': 'b059190bf20a4737ad0132751241707',
      'q': query,
      'days': '4',
      'aqi': 'no',
      'alerts': 'no'
    };
    // create a Uri to the api
    final getData =
        Uri.http("api.weatherapi.com", "/v1/forecast.json?", queryParam);

    try {
      var result = await http.get(getData);

      // parse the body of the response
      var resultParsed = jsonDecode(result.body);

      if (resultParsed.containsKey('error')) {
        final weatherDataToModel = WeatherModel(
            cityName: null,
            condition: null,
            temperature: null,
            windSpeed: null,
            humidity: null,
            visibility: null,
            gust: 0,
            is_day: 0,
            code: 404);

        return weatherDataToModel;
      } else {
        final weatherDataToModel = WeatherModel.fromJson(resultParsed);

        return weatherDataToModel;
      }

      // map the result returned to a custom weather model
      // return resultParsed.map((e) => WeatherModel.fromJson(e));
      // return weatherDataToModel;
    } catch (e) {
      rethrow;
    }
  }
}
