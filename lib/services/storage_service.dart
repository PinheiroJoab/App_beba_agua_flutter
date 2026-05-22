import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> salvarUsuario({
    required String nome,
    required String sobrenome,
    required String sexo,
    required int idade,
    required double peso,
    required int metaDiaria,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_nome', nome);
    await prefs.setString('usuario_sobrenome', sobrenome);
    await prefs.setString('usuario_sexo', sexo);
    await prefs.setInt('usuario_idade', idade);
    await prefs.setDouble('usuario_peso', peso);
    await prefs.setInt('meta_diaria', metaDiaria);
    await prefs.setBool('cadastro_completo', true);
  }

  static Future<bool> isCadastroCompleto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('cadastro_completo') ?? false;
  }

  static Future<String> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_nome') ?? "Usuário";
  }

  static Future<String> getSobrenome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_sobrenome') ?? "";
  }

  static Future<String> getSexo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_sexo') ?? "";
  }

  static Future<int> getIdade() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_idade') ?? 0;
  }

  static Future<double> getPeso() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('usuario_peso') ?? 0.0;
  }

  static Future<int> getMeta() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('meta_diaria') ?? 2000;
  }

  static Future<void> limparDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> salvarConsumoAtual(int ml) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('consumo_atual', ml);
  }

  static Future<int> getConsumoAtual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('consumo_atual') ?? 0;
  }

  static Future<void> salvarUltimaData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultima_data_registro', data);
  }

  static Future<String> getUltimaData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ultima_data_registro') ?? "";
  }

  // 🎯 Salva o texto do último registro (Ex: "22:45 - 200ml")
  static Future<void> salvarTextoUltimoRegistro(String texto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimo_registro_texto', texto);
  }

  // 🎯 Recupera o texto do último registro (Retorna "--:-- - 0ml" se for o primeiro acesso)
  static Future<String> getTextoUltimoRegistro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ultimo_registro_texto') ?? "--:-- - 0ml";
  }
}
