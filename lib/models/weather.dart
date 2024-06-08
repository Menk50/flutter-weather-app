class Weather {
  final Coord coord;
  final List<WeatherInfo> weather;
  final Main main;
  final Wind wind;
  final Clouds clouds;
  final Sys sys;
  final String name;
  final int timezone;
  final int dt;

  Weather({
    required this.coord,
    required this.weather,
    required this.main,
    required this.wind,
    required this.clouds,
    required this.sys,
    required this.name,
    required this.timezone,
    required this.dt,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      coord: Coord.fromJson(json['coord']),
      weather: (json['weather'] as List)
          .map((i) => WeatherInfo.fromJson(i))
          .toList(),
      main: Main.fromJson(json['main']),
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      sys: Sys.fromJson(json['sys']),
      name: json['name'],
      timezone: json['timezone'],
      dt: json['dt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coord': coord.toJson(),
      'weather': weather.map((w) => w.toJson()).toList(),
      'main': main.toJson(),
      'wind': wind.toJson(),
      'clouds': clouds.toJson(),
      'sys': sys.toJson(),
      'name': name,
      'timezone': timezone,
      'dt': dt,
    };
  }
}

class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'].toDouble(),
      lat: json['lat'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }
}

class WeatherInfo {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherInfo({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': temp,
      'feels_like': feelsLike,
      'temp_min': tempMin,
      'temp_max': tempMax,
      'pressure': pressure,
      'humidity': humidity,
    };
  }
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': deg,
    };
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all': all,
    };
  }
}

class Sys {
  final int type;
  final int id;
  final String country;
  final int sunrise;
  final int sunset;

  Sys({
    required this.type,
    required this.id,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      type: json['type'],
      id: json['id'],
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'country': country,
      'sunrise': sunrise,
      'sunset': sunset,
    };
  }
}
