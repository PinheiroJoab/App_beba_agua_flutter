import 'package:flutter/material.dart';
import 'components/home_page_header.dart';
import 'components/home_page_card.dart';
import 'components/consumption_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _metaDiaria = 2000;
  int _consumoAtual = 900;
  double _porcentagem = 0.45;

  void _registrarConsumo(int quantidadeML) {
    setState(() {
      _consumoAtual += quantidadeML;
      if (_consumoAtual > _metaDiaria) {
        _porcentagem = 1.0;
      } else {
        _porcentagem = _consumoAtual / _metaDiaria;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.water_drop,
          size: 32,
          color: const Color.fromARGB(255, 1, 107, 194),
        ),
        title: Text(
          'Beba Água',
          style: TextStyle(
            color: const Color.fromARGB(255, 1, 107, 194),
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 10,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: Colors.white, fontSize: 12),
        ),
        height: 60,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.water_drop, color: Colors.lightBlue),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.history, color: Colors.lightBlue),
            label: 'Histórico',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events, color: Colors.lightBlue),
            label: 'Desafios',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: Colors.lightBlue),
            label: 'Configurações',
          ),
        ],
        onDestinationSelected: (int index) {},
        selectedIndex: 0,
        backgroundColor: const Color.fromARGB(255, 42, 136, 180),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 245, 252, 255),
              const Color.fromARGB(255, 100, 183, 250),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const HomePageHeader(),

                WaterCard(
                  consumoAtual: _consumoAtual,
                  metaDiaria: _metaDiaria,
                  porcentagem: _porcentagem,
                ),
                ConsumptionButtons(onAddWater: _registrarConsumo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
