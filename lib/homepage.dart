import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:weather/api.dart';
import 'package:weather/weathermodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool inProgress=false;
  String message="Search for the location to get the weather data.";
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child:  Column(
          children: [
            _buildSearchWidget(),
            const SizedBox(height: 20),
            if (inProgress)
             const CircularProgressIndicator()
             else
              Expanded(
                child: SingleChildScrollView(child: _buildWeatherWidget(),
                ),
                ),
          ],
        ),
      ),
    ),
    );
  }
  Widget _buildSearchWidget(){
    return  SearchBar(
      hintText: "Search Any Location",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
    
  }

  Widget _buildWeatherWidget(){
    if(response==null) {
      return  Text(message);
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.location_on,
              size: 50,
              ),
              Text(response?.location?.name ?? "",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
              ),
              ),
              Text(response?.location?.country ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
              ),
            ],
          ),
           const SizedBox(height: 10),
           Row(crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${response?.current?.tempC.toString() ?? ""}°c",
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
                ),
            ),
              Text(
              response?.current?.condition?.text.toString() ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              ),
          ],
          ),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}".replaceAll("64x64", "128x128"),
                scale: 0.7,
                ),
            ),
          ),
          Card(
            elevation: 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    _dateAndTitleWidget("Humidity",
                    response?.current?.humidity?.toString() ?? ""),
                    _dateAndTitleWidget("Wind Speed",
                    "${response?.current?.windKph?.toString() ?? ""} Kp/h"),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    _dateAndTitleWidget("UV",
                    response?.current?.uv?.toString() ?? ""),
                    _dateAndTitleWidget("Percipitation",
                    "${response?.current?.precipMm?.toString() ?? ""} mm"),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    _dateAndTitleWidget("Local Time",
                    response?.location?.localtime?.split("").last ?? ""),
                    _dateAndTitleWidget("Local Date",
                    response?.location?.localtime?.split("").first ?? ""),

                  ],
                )
            ],),

          ),
        ],

      );
    }
  }


Widget _dateAndTitleWidget(String title, String data){
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      children: [
        Text(data,
        style: const TextStyle(
          fontSize: 27,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        ),
        Text(title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
        ),
      ],
    ),
  );

}

  _getWeatherData(String location) async{
    setState(() {
      inProgress = true;
    });

    try {
       response= await WeatherApi().getCurrentWeather(location);

    } catch (e){
      setState(() {
        message="Failed to get weather ";
        response= null;
      });


    }finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}