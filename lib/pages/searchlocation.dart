import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weatherapp/components/custom_snackbar.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/services/getweather.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    super.initState();
  }

  // values to use on the current page
  final _searchPageKey = GlobalKey<FormState>();
  String _placeToSearch = '';

  @override
  Widget build(BuildContext context) {
    // get width and height of screen
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      // extend body height behind app bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                color: Colors.teal.shade400,
                height: _height * 0.28,
                width: _width),
            Container(
              height: _height * 0.72,
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Form(
                        key: _searchPageKey,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.teal[400],
                          showCursor: true,
                          style:
                              const TextStyle(color: Colors.teal, fontSize: 17),
                          decoration: InputDecoration(
                              hintText: "Type a location E.g Helsinki",
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
                          validator: (value) => value!.isEmpty
                              ? "Please type in a location"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _placeToSearch = value.trim();
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: _width * .09),

                  // use a gesture detector to detect pressed events in the conatiner
                  GestureDetector(
                      onTap: () async {
                        processWeatherData(context);
                      },
                      child:
                          // use a container to define a button effect
                          Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                            width: 190,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 17),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text("Get Weather",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17.3)),
                            )),
                      )),
                ],
              ),
            ),
          ],
        ),
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
