import 'package:beba_agua/components/consumption_buttons.dart';
import 'package:beba_agua/components/home_page_card.dart';
import 'package:beba_agua/components/home_page_header.dart';
import 'package:beba_agua/components/reminder_card.dart';
import 'package:beba_agua/services/storage_service.dart';
import 'package:flutter/material.dart';

class WaterStorePage extends StatefulWidget {
  final String nomeUsuario;
  final int metaDiaria;
  final String sexoUsuario; // Novo campo para receber o sexo do usuário

  const WaterStorePage({
    super.key,
    required this.nomeUsuario,
    required this.metaDiaria,
    required this.sexoUsuario,
  });

  @override
  State<WaterStorePage> createState() => _WaterStorePageState();
}

class _WaterStorePageState extends State<WaterStorePage> {
  final int _metaDiaria = 2000;
  int _consumoAtual = 0;
  double _porcentagem = 0.0;

  String _ultimoRegistroHora = "--:--";
  int _ultimoRegistroML = 0;
  String _proximoLembreteHora = "11:15"; //Exmplo estático
  int _minutosRestantes = 30; //Exmplo estático

  String nomeUsuario = "Usuário";
  int metaDiaria = 2000;
  String sexoUsuario = ""; // Novo campo para armazenar o sexo do usuário

  @override
  void initState() {
    super.initState();
    // Aqui você pode carregar os dados do usuário usando o StorageService
    // e atualizar o estado com setState. Por exemplo:
    StorageService.getNome().then((nome) {
      setState(() {
        nomeUsuario = nome;
      });
    });
    StorageService.getMeta().then((meta) {
      setState(() {
        metaDiaria = meta;
      });
    });
    // e atualizar o estado com setState para refletir na UI.
  }

  void _registrarConsumo(int quantidadeML) {
    setState(() {
      _consumoAtual += quantidadeML;
      if (_consumoAtual > _metaDiaria) {
        _porcentagem = 1.0;
      } else {
        _porcentagem = _consumoAtual / _metaDiaria;
      }

      final agora = DateTime.now();
      final hora = agora.hour.toString().padLeft(2, '0');
      final minuto = agora.minute.toString().padLeft(2, '0');
      _ultimoRegistroHora = "$hora:$minuto";
      _ultimoRegistroML = quantidadeML;

      // Lógica para calcular o próximo lembrete (exemplo estático)
      final proximoLembrete = agora.add(const Duration(hours: 1));
      _proximoLembreteHora =
          "${proximoLembrete.hour.toString().padLeft(2, '0')}:${proximoLembrete.minute.toString().padLeft(2, '0')}";
      _minutosRestantes = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                HomePageHeader(
                  nomeUsuario: widget.nomeUsuario,
                  sexoUsuario: widget.sexoUsuario,
                ), // Passa o sexo para o HomePageHeader

                WaterCard(
                  consumoAtual: _consumoAtual,
                  metaDiaria: _metaDiaria,
                  porcentagem: _porcentagem,
                ),
                const SizedBox(height: 24),

                ConsumptionButtons(onAddWater: _registrarConsumo),

                ReminderCard(
                  ultimoRegistroHora: _ultimoRegistroHora,
                  ultimoRegistroML: _ultimoRegistroML,
                  proximoLembreteHora: _proximoLembreteHora,
                  minutosRestantes: _minutosRestantes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
