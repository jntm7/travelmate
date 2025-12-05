// format ISO 8601 duration to readable format
String formatDuration(String isoDuration) {
  // Remove PT prefix
  String duration = isoDuration.replaceFirst('PT', '');

  int hours = 0;
  int minutes = 0;

  // Extract hours
  if (duration.contains('H')) {
    final hoursPart = duration.split('H')[0];
    hours = int.tryParse(hoursPart) ?? 0;
    duration = duration.split('H')[1];
  }

  // Extract minutes
  if (duration.contains('M')) {
    final minutesPart = duration.split('M')[0];
    minutes = int.tryParse(minutesPart) ?? 0;
  }

  if (hours > 0 && minutes > 0) {
    return '${hours}h ${minutes}m';
  } else if (hours > 0) {
    return '${hours}h';
  } else {
    return '${minutes}m';
  }
}

// format time from DateTime
String formatTime(DateTime dateTime) {
  final hour = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

  return '$displayHour:$minute $period';
}

// airline code to name mapping
Map<String, String> airlineNames = {
  'AA': 'American Airlines',
  'DL': 'Delta Air Lines',
  'UA': 'United Airlines',
  'WN': 'Southwest Airlines',
  'AS': 'Alaska Airlines',
  'B6': 'JetBlue Airways',
  'NK': 'Spirit Airlines',
  'F9': 'Frontier Airlines',
  'G4': 'Allegiant Air',
  'SY': 'Sun Country Airlines',
  'BA': 'British Airways',
  'LH': 'Lufthansa',
  'AF': 'Air France',
  'KL': 'KLM',
  'IB': 'Iberia',
  'AZ': 'ITA Airways',
  'LX': 'Swiss International',
  'OS': 'Austrian Airlines',
  'SN': 'Brussels Airlines',
  'TP': 'TAP Air Portugal',
  'EI': 'Aer Lingus',
  'SK': 'SAS Scandinavian',
  'AY': 'Finnair',
  'AC': 'Air Canada',
  'EK': 'Emirates',
  'QR': 'Qatar Airways',
  'EY': 'Etihad Airways',
  'SQ': 'Singapore Airlines',
  'TG': 'Thai Airways',
  'CX': 'Cathay Pacific',
  'NH': 'ANA',
  'JL': 'Japan Airlines',
  'KE': 'Korean Air',
  'OZ': 'Asiana Airlines',
  'BR': 'EVA Air',
  'CI': 'China Airlines',
  'CA': 'Air China',
  'CZ': 'China Southern',
  'MU': 'China Eastern',
  'QF': 'Qantas',
  'NZ': 'Air New Zealand',
  'LA': 'LATAM Airlines',
  'AM': 'Aeromexico',
  'CM': 'Copa Airlines',
  'AV': 'Avianca',
  'AR': 'Aerolineas Argentinas',
};

String getAirlineName(String code) {
  return airlineNames[code] ?? code;
}
