import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RecommendationScreen extends StatefulWidget {
  final String recommendedCulture;
  final String insumosRecomendados;
  final double quantidadeInsumos; // Alteração: Mudei para double
  final double produtividadeEstimada; // Alteração: Mudei para double
  final String comentariosAdicionais;

  const RecommendationScreen({
    Key? key,
    required this.recommendedCulture,
    required this.insumosRecomendados,
    required this.quantidadeInsumos, // Alteração: Receber diretamente como double
    required this.produtividadeEstimada, // Alteração: Receber diretamente como double
    required this.comentariosAdicionais,
  }) : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<BarChartGroupData> _comparisonData = [];

  @override
  void initState() {
    super.initState();
    // Preencher com o cenário inicial (quantidade padrão e produtividade inicial)
    _addComparisonScenario(
      label: "Cenário Atual",
      quantidade:
          widget.quantidadeInsumos, // Utilizando o valor direto como double
      produtividade:
          widget.produtividadeEstimada, // Utilizando o valor direto como double
    );
  }

  void _addComparisonScenario({
    required String label,
    required double quantidade,
    required double produtividade,
  }) {
    setState(() {
      _comparisonData.add(
        BarChartGroupData(
          x: _comparisonData.length,
          barRods: [
            BarChartRodData(
              toY: produtividade,
              color: Colors.teal,
              width: 16,
            ),
          ],
          showingTooltipIndicators: [0],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendação de Plantio'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações principais
            _buildSectionTitle('Cultura Recomendada:'),
            _buildContentText(widget.recommendedCulture),
            const SizedBox(height: 16),

            _buildSectionTitle('Insumos Recomendados:'),
            _buildContentText(widget.insumosRecomendados),
            const SizedBox(height: 16),

            _buildSectionTitle('Quantidade de Insumos:'),
            _buildContentText(
                '${widget.quantidadeInsumos} kg/ha'), // Alteração: Mostrando como string com valor de quantidade
            const SizedBox(height: 16),

            _buildSectionTitle('Produtividade Estimada:'),
            _buildContentText(
                '${widget.produtividadeEstimada} ton/ha'), // Alteração: Mostrando como string com valor de produtividade
            const SizedBox(height: 16),

            _buildSectionTitle('Comentários Adicionais:'),
            _buildContentText(widget.comentariosAdicionais),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

  Widget _buildContentText(String content) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}
