import 'package:beba_agua/components/water_storage_page.dart';
import 'package:beba_agua/pages/badges_page.dart';
import 'package:beba_agua/pages/history_page.dart';
import 'package:beba_agua/pages/settings_page.dart';
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
  String _usuarioSexo = "";

  int _consumoDiarioSalvo =
      0; // Novo campo para armazenar o consumo diário salvo

  Future<void> _carregarDadosIniciais() async {
    final nome = await StorageService.getNome();
    final meta = await StorageService.getMeta();
    final sexo = await StorageService.getSexo();

    // 🎯 LÓGICA DO RESET AUTOMÁTICO DO DIA 📅
    final dataAtual = DateTime.now().toString().split(
      ' ',
    )[0]; // Pega apenas "2026-05-20"
    final ultimaDataSalva = await StorageService.getUltimaData();
    int consumoRecuperado = 0;

    if (ultimaDataSalva == dataAtual) {
      // Se ainda estamos no mesmo dia, recupera a água que já bebeu
      consumoRecuperado = await StorageService.getConsumoAtual();
    } else {
      // Se mudou o dia (ou é o primeiro acesso), zera o consumo e atualiza a data no disco
      await StorageService.salvarConsumoAtual(0);
      await StorageService.salvarUltimaData(dataAtual);
      consumoRecuperado = 0;
    }

    setState(() {
      _usuarioNome = nome;
      _metaCalculada = meta;
      _usuarioSexo = sexo;
      _consumoDiarioSalvo = consumoRecuperado; // Guarda o valor correto
      _carregando = false;
    });
  }

  Future<void> recarregarDadosDoStorage() async {
    final nome = await StorageService.getNome();
    final meta = await StorageService.getMeta();
    final sexo = await StorageService.getSexo();

    setState(() {
      _usuarioNome = nome;
      _metaCalculada = meta;
      _usuarioSexo = sexo;
    });
  } // Novo campo para armazenar o sexo do usuário

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  // Busca as informações gravadas no celular
  /*Future<void> _verificarProgressoUsuario() async {
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
  }*/

  // Executado quando o usuário clica no botão da WelcomePage
  Future<void> _configurarUsuarioInicial(Map<String, dynamic> dados) async {
    final nome = dados['nome'];
    final meta = dados['metaDiaria'];
    final sexo = dados['sexo']; // Novo campo de sexo

    // Grava permanentemente no celular usando nosso serviço
    await StorageService.salvarUsuario(
      nome: dados['nome'],
      sobrenome: dados['sobrenome'],
      sexo: dados['sexo'],
      idade: dados['idade'],
      peso: dados['peso'],
      metaDiaria: dados['metaDiaria'],
    );

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
        consumoInicial:
            _consumoDiarioSalvo, // Passa o consumo diário salvo para a WaterStorePage
      ),
      const Center(child: HistoryPage()),
      const Center(child: BadgesPage()),
      SettingsPage(onDadosAtualizados: recarregarDadosDoStorage),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Beba Água",
          style: TextStyle(
            fontSize: 26,
            color: Color.fromARGB(255, 2, 62, 110),
            fontWeight: FontWeight.bold,
          ),
        ),
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
