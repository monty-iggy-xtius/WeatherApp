import 'package:flutter/material.dart';
import 'package:weatherapp/components/custom_snackbar.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/services/getweather.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  // values to use on the current page
  final _searchPageKey = GlobalKey<FormState>();
  String _placeToSearch = '';

  @override
  Widget build(BuildContext context) {
    // get width and height of screen
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: _height * 0.35,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("images/banner.png")),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
          ),
          Container(
            height: _height * 0.65,
            padding: const EdgeInsets.all(11),
            decoration: const BoxDecoration(),
            child: SizedBox(
                width: _width,
                child: Column(
                  children: [
                    SizedBox(height: _width * .08),

                    Form(
                      key: _searchPageKey,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.deepOrangeAccent[900],
                        showCursor: true,
                        style:
                            const TextStyle(color: Colors.teal, fontSize: 17),
                        decoration: InputDecoration(
                            hintText: "E.g Mombasa, Helsinki",
                            filled: true,
                            fillColor: Colors.grey[300]?.withOpacity(.45),
                            // default border style
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(23),
                            ),
                            // border style when the text field is focused
                            // should be a white border all round the input field with a radius of 23
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                                borderSide: BorderSide(
                                  color: Colors.teal.shade400,
                                )),
                            // border style when the app runs in default
                            // should be a white border all round the input field
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(23),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ))),
                        validator: (value) =>
                            value!.isEmpty ? "Please type in a location" : null,
                        onChanged: (value) {
                          setState(() {
                            _placeToSearch = value.trim();
                          });
                        },
                      ),
                    ),

                    SizedBox(height: _width * .09),

                    // Add the button

                    TextButton(
                        onPressed: () {
                          processWeatherData(context);
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 27, vertical: 18)),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.teal),
                        ),
                        child: const Text("Get Weather",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)))
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Future<WeatherModel?> processWeatherData(context) async {
    // check if the form is properly validated
    if (_searchPageKey.currentState!.validate()) {
      var weatherResult =
          await GetWeatherService().queryWeatherApi(_placeToSearch);

      // check if the data returned is valid by comparing error codes

      if (weatherResult.code != 404) {
        // if data is correct pass it back to previous screen

        Navigator.pop(context, {"weatherData": weatherResult});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar("Sorry", "Location not found", Colors.red.shade400));
      }
    } else {
      // if the form is not validated show an error
      throw ('Error');
    }

    return null;
  }
}
