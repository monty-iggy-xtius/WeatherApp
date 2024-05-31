import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/provider/theme_provider.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  // create an empty list of data to be received
  Map retrivedWeatherData = {};

  @override
  Widget build(BuildContext context) {
    // get the theme provider
    final provider = Provider.of<ToggleThemeProvider>(context);

    // get width and height of screen
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    // retrivedWeatherData = ModalRoute.of(context)!.settings.arguments;

    handleClick(int item, context) async {
      switch (item) {
        case 0:
          dynamic result = await Navigator.pushNamed(context, "/search");

          setState(() {
            retrivedWeatherData = {
              "cityName": result['weatherData'].cityName,
              "condition": result['weatherData'].condition,
              "temperature": result['weatherData'].temperature,
              "windSpeed": result['weatherData'].windSpeed,
              "humidity": result['weatherData'].humidity,
              "visibility": result['weatherData'].visibility,
              "gust": result['weatherData'].gust,
              "is_day": result['weatherData'].is_day,
              "forecast": result['weatherData'].forecast,
              "img": result['weatherData'].img.split("/")
            };
          });

        case 1:
          provider.toggleCurrentTheme();
      }
    }

    getDay(String dateValue) {
      // this function converts a date str into a readable weekday
      final dateParsed = DateTime.parse(dateValue);
      int weekday = dateParsed.weekday;

      switch (weekday) {
        case 1:
          return "Monday";
        case 2:
          return "Tuesday";
        case 3:
          return "Wednesday";
        case 4:
          return "Thursday";
        case 5:
          return "Friday";
        case 6:
          return "Saturday";
        case 7:
          return "Sunday";
        default:
          return "Monday";
      }
    }

    // initially the bottom scroll widget is an empty list
    var bottomScrollWidgets = [];

    retrivedWeatherData.isNotEmpty
        ? bottomScrollWidgets = [
            additionalConditions(
                Colors.teal.shade400,
                retrivedWeatherData['forecast'][1]['day']['avgtemp_c'] != null
                    ? retrivedWeatherData['forecast'][1]['day']['avgtemp_c']
                        .toString()
                    : "----",
                getDay(retrivedWeatherData['forecast'][1]['date']),
                retrivedWeatherData['forecast'][1]['day']['condition']['text']),
            additionalConditions(
                Colors.teal.shade400,
                retrivedWeatherData['forecast'][2]['day']['avgtemp_c'] != null
                    ? retrivedWeatherData['forecast'][2]['day']['avgtemp_c']
                        .toString()
                    : "----",
                getDay(retrivedWeatherData['forecast'][2]['date']),
                retrivedWeatherData['forecast'][2]['day']['condition']['text']),
            additionalConditions(
                Colors.teal.shade400,
                retrivedWeatherData['forecast'][3]['day']['avgtemp_c'] != null
                    ? retrivedWeatherData['forecast'][3]['day']['avgtemp_c']
                        .toString()
                    : "----",
                getDay(retrivedWeatherData['forecast'][3]['date']),
                retrivedWeatherData['forecast'][3]['day']['condition']['text']),
          ]
        : bottomScrollWidgets = [
            additionalConditions(
                Colors.teal.shade400, "No data", "----", "----")
          ];

    return Scaffold(
      // extend body height behind app bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: PopupMenuButton<int>(
          color: Colors.teal[400],
          onSelected: (item) => handleClick(item, context),
          itemBuilder: (context) => [
            const PopupMenuItem<int>(
                value: 0,
                child: Text(
                  'Search',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Rale",
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                )),
            const PopupMenuItem<int>(
                value: 1,
                child: Text(
                  'Toggle Theme',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Rale",
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                )),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: _height * 0.048),

            Text(
              retrivedWeatherData.isNotEmpty
                  ? retrivedWeatherData['cityName']
                  : "Find a place",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: "Rale"),
            ),
            Text(DateFormat.yMMMd().format(DateTime.now()),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: "Rale")),

            SizedBox(height: _height * 0.03),

            // create an image for the weather icon
            Container(
              width: _width * 0.3,
              height: _width * 0.3,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  // borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                      image: AssetImage(retrivedWeatherData.isNotEmpty
                          ? retrivedWeatherData['is_day'] == 1
                              ? "images/day/${retrivedWeatherData["img"].last}"
                              : "images/night/${retrivedWeatherData["img"].last}"
                          : "images/day/185.png"),
                      // image: AssetImage(image),
                      fit: BoxFit.contain,
                      scale: 1)),
            ),

            // SizedBox(height: _height * 0.03),

            // create short description of the consitions
            Text(
              retrivedWeatherData.isNotEmpty
                  ? retrivedWeatherData['condition']
                  : "Pretty Chilly",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  fontFamily: "Rale"),
            ),
            // Actual current temperature
            Padding(
              padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: retrivedWeatherData.isNotEmpty
                                ? retrivedWeatherData['temperature']
                                    .toStringAsFixed(1)
                                : "0",
                            style: const TextStyle(
                                fontSize: 74,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Rale")),
                        const TextSpan(
                            text: " °C",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: "Rale"))
                      ])),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              retrivedWeatherData.isNotEmpty
                                  ? "Wind Speed: ${retrivedWeatherData['windSpeed']} kph"
                                  : "Wind Speed: 0",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "Genos"),
                            ),
                            Text(
                              retrivedWeatherData.isNotEmpty
                                  ? "Visibility: ${retrivedWeatherData['visibility']} km"
                                  : "Visibility: 0",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "Genos"),
                            ),
                            Text(
                              retrivedWeatherData.isNotEmpty
                                  ? "Humidity: ${retrivedWeatherData['humidity']}"
                                  : "Humidity: 0",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "Genos"),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),

            SizedBox(height: _height * 0.01),

            // output the optional items in a mapped list
            CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  height: 155,
                  // space items in the carousel differently depending on  screen size
                  viewportFraction: 0.36,

                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  // enlargeFactor: 0.32,
                  autoPlayCurve: Curves.easeInCubic,
                ),
                items: bottomScrollWidgets
                    .map((item) =>
                        Padding(padding: const EdgeInsets.all(0), child: item))
                    .toList())

            // create a slider to hold the sliding data
          ],
        ),
      ),
    );
  }
}

Widget additionalConditions(
        Color containerColor, String temp, String day, String condition) =>
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      width: 135,
      height: 135,
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: const BorderRadius.all(Radius.circular(23.0))),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(day,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25.5,
                      fontFamily: 'Genos',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0)),
              Text("$temp °C",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.5,
                      fontFamily: 'Genos',
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0)),
              Text(condition,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontFamily: 'Genos',
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0))
            ],
          ),
        ),
      ),
    );
