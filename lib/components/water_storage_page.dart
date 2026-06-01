import 'package:beba_agua/components/consumption_buttons.dart';
import 'package:beba_agua/components/home_page_card.dart';
import 'package:beba_agua/components/home_page_header.dart';
import 'package:beba_agua/components/reminder_card.dart';
import 'package:beba_agua/services/counter_down.dart';

import 'package:beba_agua/services/storage_service.dart';
import 'package:flutter/material.dart';

class WaterStorePage extends StatefulWidget {
  final String nomeUsuario;
  final int metaDiaria;
  final String sexoUsuario;
  final int consumoInicial;
  final String ultimoRegistroInicial;

  const WaterStorePage({
    super.key,
    required this.nomeUsuario,
    required this.metaDiaria,
    required this.sexoUsuario,
    required this.consumoInicial,
    required this.ultimoRegistroInicial,
  });

  @override
  State<WaterStorePage> createState() => _WaterStorePageState();
}

class _WaterStorePageState extends State<WaterStorePage> {
  int _consumoAtual = 0;
  double _porcentagem = 0.0;

  String _ultimoRegistroHora = "--:--";
  int _ultimoRegistroML = 0;
  String _proximoLembreteHora = "";
  int _minutosRestantes = 0;
  ContadorController? _contadorController;

  String nomeUsuario = "Usuário";
  int metaDiaria = 0;
  String sexoUsuario = "";

  @override
  void initState() {
    super.initState();
    _consumoAtual = widget.consumoInicial;
    _porcentagem = _consumoAtual / widget.metaDiaria;
    _ultimoRegistroHora = widget.ultimoRegistroInicial;
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
  }

  @override
  void didUpdateWidget(covariant WaterStorePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.metaDiaria != oldWidget.metaDiaria) {
      setState(() {
        _porcentagem = _consumoAtual / widget.metaDiaria;
      });
    }
  }

  void _registrarConsumo(int quantidadeML) async {
    final agora = DateTime.now();
    final hora = agora.hour.toString().padLeft(2, '0');
    final minuto = agora.minute.toString().padLeft(2, '0');
    final novoTextoRegistro = "$hora:$minuto - ${quantidadeML}ml";

    setState(() {
      _consumoAtual += quantidadeML;
      if (_consumoAtual > widget.metaDiaria) {
        _porcentagem = 1.0;
      } else {
        _porcentagem = _consumoAtual / widget.metaDiaria;
      }
      _ultimoRegistroHora = novoTextoRegistro;
      _proximoLembreteHora =
          "${agora.add(const Duration(minutes: 60)).hour.toString().padLeft(2, '0')}:${agora.add(const Duration(minutes: 60)).minute.toString().padLeft(2, '0')}";
      _minutosRestantes = 60;

      // Lógica para o contador regressivo, será implementado futuramente

      /*if (_minutosRestantes > 0) {
        _minutosRestantes -= 1;
      } else {
        _minutosRestantes = 0;
      }*/
    });
    await StorageService.salvarConsumoAtual(_consumoAtual);
    await StorageService.salvarTextoUltimoRegistro(novoTextoRegistro);

    _contadorController?.parar();
    _contadorController?.dispose();
    _contadorController = ContadorController(tempoInicial: 60);
    await _contadorController!.iniciar();
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
                ),

                WaterCard(
                  consumoAtual: _consumoAtual,
                  metaDiaria: widget.metaDiaria,
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

  @override
  void dispose() {
    _contadorController?.parar();
    _contadorController?.dispose();
    super.dispose();
  }
}
