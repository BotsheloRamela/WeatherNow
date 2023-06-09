import 'package:flutter/material.dart';
import 'package:planetary_forecast/models/weather.dart';
import '../services/api_services.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController cityController = TextEditingController();
  static String cityName = '';
  static String temp = '';
  static String main = '';
  String searchText = 'Johannesburg';
  late String bgImageUrl = '';
  String img =
      'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';

  @override
  void initState() {
    super.initState();
    bgImageUrl = ApiService.fetchBackgroundImage(cityName).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WeatherNow"),
        ),
        body: FutureBuilder<String>(
            future: backgroundImageUrl(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  // color: Colors.black87,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(snapshot.data.toString()),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.darken))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            searchBar(),
                            //Location

                            const SizedBox(
                              height: 50,
                            ),
                            Text(
                              "$temp\u2103",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 80),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              cityName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  main,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot != null) {
                            Weather? weather = snapshot.data;
                            if (weather == null) {
                              return const Text("Error getting weather");
                            } else {
                              return weatherData(weather);
                            }
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                        future: ApiService.fetchWeather(searchText),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  Widget weatherData(Weather weather) {
    cityName = weather.cityName;
    temp = weather.temperature.toInt().toString();
    main = weather.main;
    return Container(
      height: 200,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Weather Today",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text("Humidity"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${weather.humidity.toString()}%",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("Wind Speed"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "${weather.windSpeed.toString()} km/h",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        enableSuggestions: true,
        autocorrect: true,
        controller: cityController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          iconColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.white),
          hintText: "Search for a city...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
        onSubmitted: (String value) async {
          final newSearchText = cityController.text;
          final weather = await ApiService.fetchWeather(newSearchText);
          setState(() {
            if (newSearchText.isNotEmpty) {
              setState(() {
                searchText = newSearchText;
                cityName = weather.cityName;
                temp = weather.temperature.toInt().toString();
                main = weather.main;
              });
            }
            backgroundImageUrl();
          });
          cityController.clear();
        },
      ),
    );
  }

  Future<String> backgroundImageUrl() async {
    String url = '';

    url = await ApiService.fetchBackgroundImage("$main weather");
    return url;
  }
}
