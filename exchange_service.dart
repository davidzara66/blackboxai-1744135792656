import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeService {
  static Future<double?> getDollarRate() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedRate = prefs.getDouble('cachedRate');
    final lastUpdated = prefs.getInt('lastUpdated') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Use cache if less than 1 hour old
    if (cachedRate != null && now - lastUpdated < 3600000) {
      return cachedRate;
    }

    try {
      final response = await http.get(
        Uri.parse('https://bcv-api.vercel.app/api/exchange'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = double.tryParse(data['usd']?.toString() ?? '');
        if (rate != null) {
          await prefs.setDouble('cachedRate', rate);
          await prefs.setInt('lastUpdated', now);
        }
        return rate;
      }
    } catch (e) {
      print('Error fetching exchange rate: $e');
    }
    return cachedRate; // Fallback to cached rate if available
  }
}