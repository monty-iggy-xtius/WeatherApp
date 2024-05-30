// ignore_for_file: prefer_typing_uninitialized_variables

class WeatherModel {
  // this class contains all data values that we get back from the api
  var cityName;
  var condition;
  var temperature;
  var windSpeed;
  var humidity;
  var visibility;
  var gust;
  var is_day;
  var img;
  var code;
  List? forecast;

  // create a constructor for the class
  WeatherModel(
      {this.cityName,
      this.condition,
      this.temperature,
      this.windSpeed,
      this.humidity,
      this.visibility,
      this.gust,
      this.is_day,
      this.img,
      this.code,
      this.forecast});

  // create a model that maps json values from the api
  // into the desired class variables
  WeatherModel.fromJson(Map<String, dynamic> jsonResult) {
    // class name with the fromJson added to it
    // jsonResult is the value we parse
    cityName = jsonResult['location']['name'];
    condition = jsonResult['current']['condition']['text'];
    temperature = jsonResult['current']['temp_c'];
    humidity = jsonResult['current']['humidity'];
    visibility = jsonResult['current']['vis_km'];
    windSpeed = jsonResult['current']['wind_kph'];
    gust = jsonResult['current']['gust_kph'];
    is_day = jsonResult['current']['is_day'];
    img = jsonResult['current']['condition']['icon'];
    forecast = jsonResult['forecast']['forecastday'];
    code = 200;
  }
}
