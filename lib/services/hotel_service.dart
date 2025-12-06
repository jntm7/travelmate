import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel.dart';

class HotelService {
  final String apiKey;
  static const String baseUrl = 'https://api.liteapi.travel/v3.0';

  HotelService({required this.apiKey});

  // Search hotels by city
  Future<List<HotelOffer>> searchHotels({
    required String cityName,
    required String countryCode,
    required DateTime checkin,
    required DateTime checkout,
    required int adults,
    required int rooms,
    int children = 0,
  }) async {
    try {
      //print('Searching for hotels in: "$cityName", "$countryCode"'); // Debug

      // Step 1: Get hotels by city name and country code directly
      final hotelIds = await _searchHotelsByCity(cityName, countryCode);
      if (hotelIds.isEmpty) {
        //print('No hotels found in $cityName, $countryCode');
        return [];
      }

      // Step 2: Get hotel rates
      final hotels = await _getHotelRates(
        hotelIds: hotelIds,
        checkin: checkin,
        checkout: checkout,
        adults: adults,
        rooms: rooms,
        children: children,
      );

      return hotels;
    } catch (e) {
      //print('Hotel search error: $e');
      return [];
    }
  }

  // Get city ID from city name
  Future<String?> _getCityId(String cityName, String countryCode) async {
    try {
      //print('Searching for city: "$cityName" in country: "$countryCode"'); // Debug
      final url = Uri.parse('$baseUrl/data/city?countryCode=$countryCode');
      //print('City request: GET $url'); // Debug

      final response = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
      );

      //print('City response status: ${response.statusCode}'); // Debug
      //print('City response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'] is List) {
        final cities = data['data'] as List;
        //print('Found ${cities.length} cities');

        String normalize(String s) {
          return s.toLowerCase().trim();
        }

        final userCity = normalize(cityName);

        for (var city in cities) {
          final apiCity = normalize(city['city'] ?? '');

          if (apiCity == userCity ||
              apiCity.contains(userCity) ||
              apiCity.startsWith(userCity)) {
            //print('Matched city ID: ${city['id']}');
            return city['id'].toString();
          }
        }
      }
    }
    } catch (e) {
      //print('Error getting city ID: $e');
      return null;
    }
  }

  // Search hotels by city name and country code
  Future<List<String>> _searchHotelsByCity(String cityName, String countryCode) async {
    try {
      final url = Uri.parse('$baseUrl/data/hotels?countryCode=$countryCode&cityName=$cityName');
      //print('Hotels search request: GET $url'); // Debug

      final response = await http.get(
        url,
        headers: {
          'X-API-Key': apiKey,
        },
      );

      //print('Hotels search response status: ${response.statusCode}'); // Debug
      //print('Hotels search response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final hotels = data['data'] as List;
          //print('Found ${hotels.length} hotels in $cityName'); // Debug
          final hotelIds = hotels
              .take(10) // Limit to 10 hotels
              .map((hotel) => hotel['id']?.toString() ?? '')
              .where((id) => id.isNotEmpty)
              .toList();
          //print('Selected ${hotelIds.length} hotel IDs: $hotelIds'); // Debug
          return hotelIds;
        }
      } else {
        //print('Error response: ${response.statusCode} - ${response.body}');
      }
      return [];
    } catch (e) {
      //print('Error searching hotels: $e');
      return [];
    }
  }

  // Get hotel rates for multiple hotels
  Future<List<HotelOffer>> _getHotelRates({
    required List<String> hotelIds,
    required DateTime checkin,
    required DateTime checkout,
    required int adults,
    required int rooms,
    int children = 0,
  }) async {
    try {
      final checkinStr = _formatDate(checkin);
      final checkoutStr = _formatDate(checkout);

      final url = Uri.parse('$baseUrl/hotels/rates');

      // Build occupancies array - one object per room
      final occupancies = List.generate(rooms, (index) => {
        'adults': adults,
        'children': children > 0 ? [children] : [],
      });

      final requestBody = {
        'hotelIds': hotelIds,
        'checkin': checkinStr,
        'checkout': checkoutStr,
        'occupancies': occupancies,
        'currency': 'USD',
        'guestNationality': 'US',
      };

      //print('Hotel rates request: ${json.encode(requestBody)}'); // Debug

      final response = await http.post(
        url,
        headers: {
          'X-API-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      //print('Hotel rates response status: ${response.statusCode}'); // Debug
      //print('Hotel rates response body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          final hotelsData = data['data'] as List;
          return hotelsData
              .map((hotelData) => _parseHotelOffer(hotelData))
              .where((hotel) => hotel != null)
              .cast<HotelOffer>()
              .toList();
        }
      }
      return [];
    } catch (e) {
      //print('Error getting hotel rates: $e');
      return [];
    }
  }

  // Parse hotel offer from API response
  HotelOffer? _parseHotelOffer(Map<String, dynamic> data) {
  try {
    // Extract minimum price
    double minPrice = double.infinity;

    if (data['rooms'] != null && data['rooms'] is List) {
      for (var room in data['rooms']) {
        final price = double.tryParse(room['price']?['total']?.toString() ?? '0') ?? 0;
        if (price > 0 && price < minPrice) {
          minPrice = price;
        }
      }
    }

    if (minPrice == double.infinity) minPrice = 0;

    return HotelOffer(
      id: data['hotelId']?.toString() ?? '',
      name: data['hotelName'] ?? 'Unknown Hotel',
      address: data['address'] ?? '',
      city: data['cityName'] ?? '',
      country: data['countryCode'] ?? '',
      price: minPrice.toStringAsFixed(2),
      currency: 'USD',
      rating: (data['rating'] ?? 0.0).toDouble(),
      stars: data['stars'] ?? 0,
      amenities: [],
      imageUrl: data['image'] ?? '',
    );
  } catch (e) {
    //print('Error parsing hotel offer: $e');
    return null;
  }
}

  // Format date for API (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
