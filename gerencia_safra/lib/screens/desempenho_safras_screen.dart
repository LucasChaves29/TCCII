import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class DesempenhoSafrasScreen extends StatefulWidget {
  @override
  _DesempenhoSafrasScreenState createState() => _DesempenhoSafrasScreenState();
}

class _DesempenhoSafrasScreenState extends State<DesempenhoSafrasScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _desempenhoSafras = [];

  @override
  void initState() {
    super.initState();
    _carregarDesempenhoSafras();
  }

  Future<void> _carregarDesempenhoSafras() async {
    final desempenho = await _dbHelper.getSafraDesempenho();

    print('Desempenho Safras: $desempenho');

    setState(() {
      _desempenhoSafras = desempenho;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Desempenho das Safras'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: _desempenhoSafras.isEmpty
                ? Center(child: Text('Nenhum desempenho disponível'))
                : ListView.builder(
                    itemCount: _desempenhoSafras.length,
                    itemBuilder: (context, index) {
                      final safra = _desempenhoSafras[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                safra['nome_safra'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.teal[900],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Data de Plantio: ${safra['data_plantio']}'),
                              Text(
                                  'Data de Colheita: ${safra['data_colheita']}'),
                              SizedBox(height: 8),
                              Text(
                                  'Quantidade Esperada: ${safra['quantidade_esperada']} toneladas'),
                              Text(
                                  'Custo da Safra: R\$ ${safra['custo_safra']}'),
                              SizedBox(height: 8),
                              Text(
                                  'Produtividade: ${safra['produtividade'].toStringAsFixed(2)} ton/ha'),
                              Text(
                                  'Custo por Tonelada: R\$ ${safra['custo_por_tonelada'].toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
