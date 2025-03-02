class ApiResponse {
  final Location location;
  final Current current;

  ApiResponse({required this.location, required this.current});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      location: Location.fromJson(json['location'] ?? {}),
      current: Current.fromJson(json['current'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'current': current.toJson(),
    };
  }
}

class Location {
  final String name;
  final String country;
  final String localtime;

  const Location({
    required this.name,
    required this.country,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? 'Unknown',
      country: json['country'] ?? 'Unknown',
      localtime: json['localtime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'localtime': localtime,
    };
  }
}

class Current {
  final double tempC;
  final int isDay;
  final Condition condition;
  final double windKph;
  final double precipMm;
  final int humidity;
  final double uv;

  const Current({
    required this.tempC,
    required this.isDay,
    required this.condition,
    required this.windKph,
    required this.precipMm,
    required this.humidity,
    required this.uv,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: (json['temp_c'] ?? 0.0).toDouble(),
      isDay: json['is_day'] ?? 0,
      condition: Condition.fromJson(json['condition'] ?? {}),
      windKph: (json['wind_kph'] ?? 0.0).toDouble(),
      precipMm: (json['precip_mm'] ?? 0.0).toDouble(),
      humidity: json['humidity'] ?? 0,
      uv: (json['uv'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': tempC,
      'is_day': isDay,
      'condition': condition.toJson(),
      'wind_kph': windKph,
      'precip_mm': precipMm,
      'humidity': humidity,
      'uv': uv,
    };
  }

  /// Returns a properly formatted weather icon URL
  String get iconUrl {
    return "https:${condition.icon}".replaceAll("64x64", "128x128");
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  const Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'] ?? 'Unknown',
      icon: json['icon'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'icon': icon,
      'code': code,
    };
  }
}
