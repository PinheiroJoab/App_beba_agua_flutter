import 'package:beba_agua/components/water_storage_page.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'services/storage_service.dart'; // Importe o serviço criado

class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  bool _carregando = true; // Tela de loading enquanto lê o SharedPreferences
  bool _cadastroConcluido = false;
  int _abaSelecionada = 0;

  String _usuarioNome = "";
  int _metaCalculada = 2000;
  String _usuarioSexo = ""; // Novo campo para armazenar o sexo do usuário

  @override
  void initState() {
    super.initState();
    _verificarProgressoUsuario();
  }

  // Busca as informações gravadas no celular
  Future<void> _verificarProgressoUsuario() async {
    final completo = await StorageService.isCadastroCompleto();
    if (completo) {
      final nome = await StorageService.getNome();
      final meta = await StorageService.getMeta();
      final sexo = await StorageService.getSexo(); // Recupera o sexo salvo
      setState(() {
        _usuarioNome = nome;
        _metaCalculada = meta;
        _usuarioSexo = sexo; // Armazena o sexo no estado
        _cadastroConcluido = true;
      });
    }
    setState(() {
      _carregando = false; // Finaliza o estado de carregamento
    });
  }

  // Executado quando o usuário clica no botão da WelcomePage
  Future<void> _configurarUsuarioInicial(Map<String, dynamic> dados) async {
    final nome = dados['nome'];
    final meta = dados['metaDiaria'];
    final sexo = dados['sexo']; // Novo campo de sexo

    // Grava permanentemente no celular usando nosso serviço
    await StorageService.salvarUsuario(nome, meta, sexo);

    setState(() {
      _usuarioNome = nome;
      _metaCalculada = meta;
      _usuarioSexo = sexo; // Armazena o sexo no estado
      _cadastroConcluido = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto o SharedPreferences lê o disco, exibe uma tela de loading para não dar flash em branco
    if (_carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0288D1)),
        ),
      );
    }

    if (!_cadastroConcluido) {
      return WelcomePage(onSetupComplete: _configurarUsuarioInicial);
    }

    final List<Widget> telas = [
      WaterStorePage(
        nomeUsuario: _usuarioNome,
        metaDiaria: _metaCalculada,
        sexoUsuario: _usuarioSexo,
      ), // Passa o sexo para a WaterStorePage
      const Center(child: Text("Histórico")),
      const Center(child: Text("Conquistas")),
      const Center(
        child: Text("Ajustes"),
      ), // Dica: futuramente você pode ler do storage aqui também!
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Beba Água"),
        backgroundColor: const Color.fromARGB(255, 133, 206, 245),
        elevation: 12,
      ),
      body: IndexedStack(index: _abaSelecionada, children: telas),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 133, 206, 245),
        elevation: 12,
        currentIndex: _abaSelecionada,
        onTap: (index) => setState(() => _abaSelecionada = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0288D1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.water_drop),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Conquistas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
