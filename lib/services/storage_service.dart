import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Salva os dados do usuário, incluindo o sexo
  static Future<void> salvarUsuario(
    String nome,
    int metaDiaria,
    String sexo,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_nome', nome);
    await prefs.setInt('meta_diaria', metaDiaria);
    await prefs.setString('usuario_sexo', sexo); // Novo método 💡
    await prefs.setBool('cadastro_completo', true);
  }

  // Verifica se o usuário já tem o cadastro salvo
  static Future<bool> isCadastroCompleto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('cadastro_completo') ?? false;
  }

  // Recupera o nome salvo
  static Future<String> getNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_nome') ?? "Usuário";
  }

  // Recupera a meta salva
  static Future<int> getMeta() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('meta_diaria') ?? 2000;
  }

  // Recupera o sexo salvo (retorna vazio se não achar) 💡
  static Future<String> getSexo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_sexo') ?? "";
  }

  // Método para limpar dados
  static Future<void> limparDados() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
