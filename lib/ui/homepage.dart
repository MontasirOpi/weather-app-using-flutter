import 'package:flutter/material.dart';
import 'package:weather/auth/api.dart';
import 'package:weather/ui/weathermodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for a location to get the weather data.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(
          child: Text("Weather App", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueAccent.shade200, Colors.blueGrey.shade900],
            ),
          ),
          child: Column(
            children: [
              _buildSearchWidget(),
              const SizedBox(height: 20),
              if (inProgress)
                const CircularProgressIndicator()
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildWeatherWidget(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search any location...",
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationHeader(),
          const SizedBox(height: 10),
          _buildTemperatureDetails(),
          _buildWeatherIcon(),
          _buildWeatherInfoCard(),
        ],
      );
    }
  }

  Widget _buildLocationHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Icon(Icons.location_on, size: 44, color: Colors.redAccent),
        Text(
          response?.location?.name ?? "",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          response?.location?.country ?? "",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildTemperatureDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${response?.current?.tempC.toString() ?? ""}°C",
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Text(
          response?.current?.condition?.text.toString() ?? "",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon() {
    return Center(
      child: SizedBox(
        height: 200,
        child: Image.network(
          "https:${response?.current?.condition?.icon}".replaceAll("64x64", "128x128"),
          scale: 0.7,
        ),
      ),
    );
  }

  Widget _buildWeatherInfoCard() {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow("Humidity", response?.current?.humidity?.toString() ?? "", "Wind Speed",
                "${response?.current?.windKph?.toString() ?? ""} Kp/h"),
            _buildInfoRow("UV Index", response?.current?.uv?.toString() ?? "", "Precipitation",
                "${response?.current?.precipMm?.toString() ?? ""} mm"),
            _buildInfoRow("Local Time", response?.location?.localtime?.split(" ").last ?? "", "Local Date",
                response?.location?.localtime?.split(" ").first ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title1, String data1, String title2, String data2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoTile(title1, data1),
        _infoTile(title2, data2),
      ],
    );
  }

  Widget _infoTile(String title, String data) {
    return Column(
      children: [
        Text(
          data,
          style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
        ),
      ],
    );
  }

  _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      setState(() {
        message = "Failed to get weather data.";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
