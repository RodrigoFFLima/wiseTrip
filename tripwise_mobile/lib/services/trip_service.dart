import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/trip_model.dart';

class TripService {
  final String baseUrl = 'http://localhost:5222';

  Future<TripModel> getEstimate(double distance) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/trip/estimate?distance=$distance'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar estimativa');
    }

    final json = jsonDecode(response.body);
    return TripModel.fromJson(json);
  }
}
