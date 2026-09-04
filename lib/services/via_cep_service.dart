import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cep.dart';

class ViaCepService {
  static const _baseUrl = 'https://viacep.com.br/ws';

  Future<Cep?> fetchCep(String cep) async {
    final sanitized = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse('$_baseUrl/$sanitized/json/');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('ViaCEP request failed with status ${response.statusCode}');
    }

    final Map<String, dynamic> data = json.decode(response.body);

    if (data.containsKey('erro') && data['erro'] == true) {
      return null;
    }

    return Cep.fromJson(data);
  }
}
