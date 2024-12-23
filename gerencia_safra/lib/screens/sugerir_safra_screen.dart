import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/api_service.dart';
import 'recommendation_screen.dart';

class SugerirSafrasScreen extends StatefulWidget {
  const SugerirSafrasScreen({super.key});

  @override
  _SugerirSafrasScreenState createState() => _SugerirSafrasScreenState();
}

class _SugerirSafrasScreenState extends State<SugerirSafrasScreen> {
  List<Map<String, dynamic>> _terras = [];

  @override
  void initState() {
    super.initState();
    _loadTerras();
  }

  void _loadTerras() async {
    final terras = await DatabaseHelper().getTerras();
    setState(() {
      _terras = terras;
    });
  }

  void _showRecommendation(Map<String, dynamic> terra) async {
    try {
      final apiService = ApiService();

      // Chamar a API para obter recomendação
      final result = await apiService.getRecommendedCulture(
        tipoSolo: terra['tipo_solo'],
        ph: terra['ph'],
        drenagem: terra['drenagem'],
      );

      // Navegar para a tela de recomendação com a resposta
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationScreen(
            recommendedCulture: result['recommended_culture'],
            insumosRecomendados: result['insumos_recomendados'],
            quantidadeInsumos: result['quantidade_insumos'],
            produtividadeEstimada: result['produtividade_estimada'],
            comentariosAdicionais: result['comentarios_adicionais'],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter recomendação: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terras Cadastradas'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: _terras.length,
        itemBuilder: (context, index) {
          final terra = _terras[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Exibição das informações da terra
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          terra['nome'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal[900],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Área: ${terra['area'].toString()} hectares'),
                        SizedBox(height: 4),
                        Text('Tipo de Solo: ${terra['tipo_solo']}'),
                      ],
                    ),
                  ),
                  // Ícones de visualização, edição, exclusão e recomendação
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility_outlined,
                            color: Colors.purple),
                        onPressed: () => _showRecommendation(
                            terra), // Exibe recomendação de plantio
                        tooltip: 'Ver Recomendação',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
