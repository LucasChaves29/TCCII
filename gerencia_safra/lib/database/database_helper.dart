import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,
        'app_database_v7.db'); // Incrementando a versão para 6
    return await openDatabase(
      path,
      version: 7, // Atualizando a versão do banco de dados
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        senha TEXT
    )''');

    // Tabela de Terras (atualizada para incluir pH e Drenagem)
    await db.execute('''CREATE TABLE terras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        area REAL,
        tipo_solo TEXT,
        localizacao TEXT,
        data_cadastro TEXT,
        observacoes TEXT,
        ph REAL DEFAULT 6.0, -- Valor padrão
        drenagem TEXT DEFAULT "Boa" -- Valor padrão
      )''');

    // Tabela de Safras
    await db.execute('''CREATE TABLE safras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idTerra INTEGER,
        nome_safra TEXT,
        data_plantio TEXT,
        data_colheita TEXT,
        area_plantada REAL,
        quantidade_esperada REAL,
        insumos_utilizados TEXT,
        observacoes TEXT,
        condicoes_climaticas TEXT,
        custo_safra REAL,
        FOREIGN KEY (idTerra) REFERENCES terras (id)
      )''');

    // Tabela de Controle Financeiro
    await db.execute('''CREATE TABLE controle_financeiro (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idSafra INTEGER,
        gasto REAL,
        receita REAL,
        FOREIGN KEY (idSafra) REFERENCES safras (id)
      )''');

    // Tabela de Produtos do Estoque
    await db.execute('''CREATE TABLE produtos_estoque (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_produto TEXT,
        descricao TEXT,
        unidade_medida TEXT,
        local_armazenamento TEXT,
        data_cadastro TEXT
      )''');

    // Tabela de Movimentações do Estoque
    await db.execute('''CREATE TABLE movimentacoes_estoque (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_produto INTEGER,
        tipo_movimentacao TEXT,
        data_movimentacao TEXT,
        quantidade REAL,
        safra_relacionada TEXT,
        origem TEXT,
        destino TEXT,
        motivo TEXT,
        FOREIGN KEY (id_produto) REFERENCES produtos_estoque (id)
      )''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 6) {
      // Adiciona colunas ph e drenagem à tabela terras, se ainda não existirem
      await db.execute('ALTER TABLE terras ADD COLUMN ph REAL DEFAULT 6.0');
      await db
          .execute('ALTER TABLE terras ADD COLUMN drenagem TEXT DEFAULT "Boa"');
    }
  }

  // Funções de Usuário
  Future<int> addUser(String nome, String email, String senha) async {
    final db = await database;
    return await db.insert('usuarios', {
      'nome': nome,
      'email': email,
      'senha': senha,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String senha) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> addMovimentacaoEstoque(Map<String, dynamic> movimentacao) async {
    final db = await database;
    return await db.insert('movimentacoes_estoque', movimentacao);
  }

  Future<List<Map<String, dynamic>>> getMovimentacoesEstoque(
      int idProduto) async {
    final db = await database;
    return await db.query('movimentacoes_estoque',
        where: 'id_produto = ?', whereArgs: [idProduto]);
  }

  Future<double> getSaldoProduto(int idProduto) async {
    final db = await database;

    // Consulta para obter a soma das entradas
    final entradas = await db.rawQuery(
        'SELECT SUM(quantidade) as total FROM movimentacoes_estoque WHERE id_produto = ? AND tipo_movimentacao = "entrada"',
        [idProduto]);
    // Consulta para obter a soma das saídas
    final saidas = await db.rawQuery(
        'SELECT SUM(quantidade) as total FROM movimentacoes_estoque WHERE id_produto = ? AND tipo_movimentacao = "saida"',
        [idProduto]);

    // Verifica se o valor é nulo e faz a conversão para double com '?? 0.0' para evitar valores nulos
    double totalEntradas = (entradas.first['total'] as double?) ?? 0.0;
    double totalSaidas = (saidas.first['total'] as double?) ?? 0.0;

    // Retorna o saldo (entradas - saídas)
    return totalEntradas - totalSaidas;
  }

  // Funções para Terras
  Future<int> addTerra(
      String nome,
      double area,
      String tipoSolo,
      String localizacao,
      String dataCadastro,
      String observacoes,
      double ph,
      String drenagem) async {
    final db = await database;
    return await db.insert('terras', {
      'nome': nome,
      'area': area,
      'tipo_solo': tipoSolo,
      'localizacao': localizacao,
      'data_cadastro': dataCadastro,
      'observacoes': observacoes,
      'ph': ph,
      'drenagem': drenagem,
    });
  }

  Future<List<Map<String, dynamic>>> getTerras() async {
    final db = await database;
    return await db.query('terras');
  }

  Future<int> updateTerra(Map<String, dynamic> terra, int id) async {
    final db = await database;
    return await db.update(
      'terras',
      terra,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTerra(int id) async {
    final db = await database;
    return await db.delete('terras', where: 'id = ?', whereArgs: [id]);
  }

  // Funções para Safras
  Future<int> addSafra(Map<String, dynamic> safra) async {
    final db = await database;
    return await db.insert('safras', safra);
  }

  Future<List<Map<String, dynamic>>> getSafras() async {
    final db = await database;
    return await db.query('safras');
  }

  Future<int> updateSafra(Map<String, dynamic> safra, int id) async {
    final db = await database;
    return await db.update(
      'safras',
      safra,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSafra(int id) async {
    final db = await database;
    return await db.delete('safras', where: 'id = ?', whereArgs: [id]);
  }

  // Funções para Estoque
  Future<int> addProdutoEstoque(Map<String, dynamic> produto) async {
    final db = await database;
    return await db.insert('produtos_estoque', produto);
  }

  Future<List<Map<String, dynamic>>> getProdutosEstoque() async {
    final db = await database;
    return await db.query('produtos_estoque');
  }

  Future<int> updateProduto(Map<String, dynamic> produto, int id) async {
    final db = await database;
    return await db.update(
      'produtos_estoque',
      produto,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduto(int id) async {
    final db = await database;
    return await db
        .delete('produtos_estoque', where: 'id = ?', whereArgs: [id]);
  }

  // Funções para Análise de Desempenho das Safras
  Future<List<Map<String, dynamic>>> getSafraDesempenho() async {
    final db = await database;
    final desempenho = await db.rawQuery('''
      SELECT s.id, s.nome_safra, s.data_plantio, s.data_colheita, s.quantidade_esperada, s.custo_safra,
             (s.quantidade_esperada / s.area_plantada) AS produtividade,
             (s.custo_safra / s.quantidade_esperada) AS custo_por_tonelada
      FROM safras s
      LEFT JOIN controle_financeiro cf ON s.id = cf.idSafra
      GROUP BY s.id
    ''');
    return desempenho;
  }
}
