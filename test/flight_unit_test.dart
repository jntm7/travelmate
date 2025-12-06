import 'package:flutter_test/flutter_test.dart';
import 'package:travelmate/models/airport.dart';

void main() {
  group('Airport searchText filter', () {
    final airports = [
      Airport(iataCode: 'YEG', name: 'Edmonton International Airport', municipality: 'Edmonton', isoCountry: 'CA'),
      Airport(iataCode: 'LAX', name: 'Los Angeles International Airport', municipality: 'Los Angeles', isoCountry: 'US'),
      Airport(iataCode: 'HKG', name: 'Hong Kong International Airport', municipality: 'Hong Kong', isoCountry: 'HK'),
    ];

    // Test for airport match
    test('returns correct airports for search text', () {
      final query = 'edm';
      final results = airports.where((airport) => airport.searchText.contains(query.toLowerCase())).toList();

      expect(results.length, 1);
      expect(results.first.iataCode, 'YEG');
    });

    // Test for case insensitivity
    test('search is case insensitive', () {
      final query = 'EDM';
      final results = airports.where((airport) => airport.searchText.contains(query.toLowerCase())).toList();

      expect(results.length, 1);
      expect(results.first.iataCode, 'YEG');
    });

    // Test for no airport match
      test('returns empty list if no airports match query', () {
      final query = 'xyz';
      final results = airports
          .where((airport) => airport.searchText.contains(query.toLowerCase()))
          .toList();

      expect(results.length, 0);
    });
  });
}
