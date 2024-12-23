import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.0.108:5000/'; // URL da API Flask

  Future<Map<String, dynamic>> getRecommendedCulture({
    required String tipoSolo,
    required Float
        ph, // 'ph' é do tipo 'double', não precisa verificar se é nulo
    required String drenagem,
  }) async {
    // Verificar se algum parâmetro é vazio
    if (tipoSolo.isEmpty || drenagem.isEmpty) {
      throw Exception('Valores inválidos ou nulos fornecidos.');
    }

    final url = Uri.parse('$baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'Tipo_Solo': tipoSolo,
        'pH': ph, // Convertendo o valor de pH para String
        'Drenagem': drenagem,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Erro na API: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
