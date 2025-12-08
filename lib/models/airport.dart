class Airport {
  final String iataCode;
  final String name;
  final String municipality;
  final String isoCountry;

  Airport({
    required this.iataCode,
    required this.name,
    required this.municipality,
    required this.isoCountry,
  });

  // construct airport from airports.json
  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      iataCode: json['iata_code'] ?? '',
      name: json['name'] ?? '',
      municipality: json['municipality'] ?? '',
      isoCountry: json['iso_country'] ?? '',
    );
  }

  // getters for city and country needed for the hotel screen
  String get city {
    return municipality.isNotEmpty ? municipality : name;
  }

  String get country {
    return _getCountryName(isoCountry);
  }

  String get countryCode => isoCountry;

  static String _getCountryName(String code) {
    const countryMap = {
      'US': 'United States',
      'CA': 'Canada',
      'GB': 'United Kingdom',
      'FR': 'France',
      'DE': 'Germany',
      'IT': 'Italy',
      'ES': 'Spain',
      'JP': 'Japan',
      'CN': 'China',
      'AU': 'Australia',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'IN': 'India',
      'RU': 'Russia',
      'KR': 'South Korea',
      'NL': 'Netherlands',
      'CH': 'Switzerland',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'FI': 'Finland',
      'PL': 'Poland',
      'BE': 'Belgium',
      'AT': 'Austria',
      'GR': 'Greece',
      'PT': 'Portugal',
      'IE': 'Ireland',
      'NZ': 'New Zealand',
      'SG': 'Singapore',
      'HK': 'Hong Kong',
      'TH': 'Thailand',
      'MY': 'Malaysia',
      'ID': 'Indonesia',
      'PH': 'Philippines',
      'VN': 'Vietnam',
      'AE': 'United Arab Emirates',
      'SA': 'Saudi Arabia',
      'IL': 'Israel',
      'TR': 'Turkey',
      'ZA': 'South Africa',
      'EG': 'Egypt',
      'AR': 'Argentina',
      'CL': 'Chile',
      'CO': 'Colombia',
      'PE': 'Peru',
      'CZ': 'Czech Republic',
      'HU': 'Hungary',
      'RO': 'Romania',
      'UA': 'Ukraine',
      'IS': 'Iceland',
      'HR': 'Croatia',
    };
    return countryMap[code] ?? code;
  }

  // format display name
  String get displayName => '$municipality ($iataCode) - ${_getCountryName(isoCountry)}';

  // search text for filtering airports
  String get searchText =>
      '${iataCode.toLowerCase()} ${municipality.toLowerCase()} ${name.toLowerCase()} ${isoCountry.toLowerCase()}';

  @override
  String toString() => displayName;

  // compare airports by matching IATA code
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Airport &&
          runtimeType == other.runtimeType &&
          iataCode == other.iataCode;
  // hash code based on IATA code
  @override
  int get hashCode => iataCode.hashCode;
}
