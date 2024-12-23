import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'listar_terras_screen.dart';

class CadastroTerraScreen extends StatefulWidget {
  final Map<String, dynamic>? terra; // Terra opcional para edição

  const CadastroTerraScreen({super.key, this.terra});

  @override
  _CadastroTerraScreenState createState() => _CadastroTerraScreenState();
}

class _CadastroTerraScreenState extends State<CadastroTerraScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  String? _tipoSolo;
  final TextEditingController _localizacaoController = TextEditingController();
  String? _dataCadastro;
  final TextEditingController _observacoesController = TextEditingController();
  String? _phSelecionado; // Usar o pH selecionado
  String _drenagem = "Boa"; // Valor padrão para drenagem

  final List<String> _tiposSolo = [
    'Arenoso',
    'Argiloso',
    'Pedregoso',
    'Calcário',
    'Siltoso',
    'Aluvial',
    'Latossolo',
    'Outros'
  ];

  // Mapeia os tipos de solo para os valores de pH correspondentes
  final Map<String, List<double>> tiposDeSoloPH = {
    'Arenoso': [4.5, 5.0, 5.5, 6.0],
    'Argiloso': [5.5, 6.0, 6.5],
    'Pedregoso': [6.5, 7.0, 7.5],
    'Calcário': [6.0, 6.5, 7.0],
    'Siltoso': [5.5, 6.0, 6.5],
    'Aluvial': [5.5, 6.0, 6.5, 7.0],
    'Latossolo': [6.0, 6.5, 6.8, 7.0],
  };

  @override
  void initState() {
    super.initState();
    if (widget.terra != null) {
      _nomeController.text = widget.terra!['nome'] ?? '';
      _areaController.text = widget.terra!['area'].toString();
      _tipoSolo = widget.terra!['tipo_solo'] ?? '';
      _localizacaoController.text = widget.terra!['localizacao'] ?? '';
      _dataCadastro = widget.terra!['data_cadastro'] ?? '';
      _observacoesController.text = widget.terra!['observacoes'] ?? '';
      _phSelecionado = widget.terra!['ph'].toString(); // Set pH from terra
      _drenagem = widget.terra!['drenagem'] ?? "Boa";
    }
  }

  void _salvarTerra() async {
    String nome = _nomeController.text;
    double area = double.tryParse(_areaController.text) ?? 0.0;
    String tipoSolo = _tipoSolo ?? '';
    String localizacao = _localizacaoController.text;
    String dataCadastro = _dataCadastro ?? '';
    String observacoes = _observacoesController.text;
    double ph =
        double.tryParse(_phSelecionado ?? '6.0') ?? 6.0; // Convert pH to double

    if (nome.isNotEmpty &&
        area > 0 &&
        tipoSolo.isNotEmpty &&
        localizacao.isNotEmpty &&
        dataCadastro.isNotEmpty) {
      try {
        if (widget.terra == null) {
          // Cadastrar nova terra
          await _dbHelper.addTerra(
            nome,
            area,
            tipoSolo,
            localizacao,
            dataCadastro,
            observacoes,
            ph,
            _drenagem,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terra cadastrada com sucesso!')),
          );
        } else {
          // Atualizar terra existente
          await _dbHelper.updateTerra({
            'nome': nome,
            'area': area,
            'tipo_solo': tipoSolo,
            'localizacao': localizacao,
            'data_cadastro': dataCadastro,
            'observacoes': observacoes,
            'ph': ph,
            'drenagem': _drenagem,
          }, widget.terra!['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Terra atualizada com sucesso!')),
          );
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListarTerrasScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar a terra. Tente novamente.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
    }
  }

  Future<void> _selecionarDataCadastro(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataCadastro =
            "${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}";
      });
    }
  }

  // Dropdown para selecionar o tipo de pH conforme o tipo de solo
  Widget _buildPhDropdown() {
    return DropdownButtonFormField<String>(
      value: _phSelecionado,
      hint: Text('Selecione o pH do Solo'),
      items: _tipoSolo != null
          ? tiposDeSoloPH[_tipoSolo]!.map((double ph) {
              return DropdownMenuItem<String>(
                value: ph.toString(),
                child: Text(ph.toString()),
              );
            }).toList()
          : [],
      onChanged: (String? newValue) {
        setState(() {
          _phSelecionado = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'pH do Solo',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.terra == null ? 'Cadastro de Terra' : 'Editar Terra'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                  _nomeController, 'Nome da Terra', Icons.landscape),
              SizedBox(height: 16),
              _buildTextField(_areaController, 'Tamanho em Hectares', Icons.map,
                  keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildDropdown(),
              SizedBox(height: 16),
              _buildTextField(
                  _localizacaoController, 'Localização', Icons.location_on),
              SizedBox(height: 16),
              _buildDateField(context),
              SizedBox(height: 16),
              _buildPhDropdown(), // Adiciona o campo de pH dinâmico
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _drenagem,
                items: ['Boa', 'Moderada', 'Baixa'].map((d) {
                  return DropdownMenuItem<String>(
                    value: d,
                    child: Text(d),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _drenagem = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Drenagem do Solo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(
                  _observacoesController, 'Observações', Icons.notes,
                  maxLines: 3),
              SizedBox(height: 20),
              _buildElevatedButton(
                  widget.terra == null ? 'Cadastrar' : 'Salvar Alterações',
                  _salvarTerra),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _tipoSolo,
      hint: Text('Selecione o Tipo de Solo'),
      items: _tiposSolo.map((String tipo) {
        return DropdownMenuItem<String>(
          value: tipo,
          child: Text(tipo),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _tipoSolo = newValue;
          _phSelecionado = null; // Resetar o pH ao mudar o tipo de solo
        });
      },
      decoration: InputDecoration(
        labelText: 'Tipo de Solo',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selecionarDataCadastro(context),
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
              text: _dataCadastro ?? 'Clique para selecionar'),
          decoration: InputDecoration(
            labelText: 'Data de Cadastro',
            prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
