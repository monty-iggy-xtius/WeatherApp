import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/components/custom_snackbar.dart';
import 'package:weatherapp/models/weathermodel.dart';
import 'package:weatherapp/services/getweather.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  // this variable will tell the widget tree if any data is loading on the page 
  // the idea is, when the get weather button is pressed and the form is valid, set this value to true 
  // which in turns shows a spinner 
  // when the data arrives set it back to false indicating no loading 
  bool isLoading = false;


  // values to use on the current page
  final _searchPageKey = GlobalKey<FormState>();
  String _placeToSearch = '';

  @override
  Widget build(BuildContext context) {
    // get width and height of screen
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: isLoading ? Center(
        child: SpinKitDualRing(
          color: Colors.teal.shade400,
          size: 60,
        )
      ,)
      :
      SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // container with the image in it 
            Container(
                height: _height * 0.29,
                width: _width,
                // some padding to push the image a bit into the container 
                padding: const EdgeInsets.only(top: 50, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.teal.shade400,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ],
                  // curve the bottoms a little 
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13))
                ),
                child: const Image(
                  image: AssetImage("images/day/122.png"),
                  isAntiAlias: true,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  ),
                ),
            Container(
              height: _height * 0.71,
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // space between the two containers 
                  SizedBox(height: _height * 0.09),

                  Form(
                    key: _searchPageKey,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.teal[400],
                      textCapitalization: TextCapitalization.words,
                      maxLength: 18,
                      showCursor: true,
                      style:
                          TextStyle(color: Colors.teal.shade400, fontSize: 17),
                      decoration: InputDecoration(
                          hintText: "Type a location E.g Helsinki",
                          filled: true,
                          fillColor: Colors.grey[300]?.withOpacity(.45),
                          // default border style
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          // border style when the text field is focused
                          // should be a white border all round the input field with a radius of 23
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(
                                color: Colors.teal.shade400,
                              )),
                          // border style when the app runs in default
                          // should be a white border all round the input field
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
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

                  const SizedBox(height: 30),

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
                            width: 175,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3.0, vertical: 13),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text("Get Weather",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.7)),
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

      // set loading to true while fetching data
      setState(() {
      isLoading = true;
      });

      // retrieve data from the service 'module'
      var weatherResult =
          await GetWeatherService().queryWeatherApi(_placeToSearch);
          
      // when the result is back, it means the app is no longer loading 
      setState(() {
      isLoading = false;
      });

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
