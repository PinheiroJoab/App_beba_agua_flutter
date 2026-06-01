import 'dart:async';
import 'package:beba_agua/services/notification_service.dart';
import 'package:flutter/material.dart';

class ContadorController {
  // Tempo inicial padrão
  final int tempoInicial;

  // ValueNotifier avisa a tela sempre que o valor interno mudar
  final ValueNotifier<int> segundosRestantes;
  final ValueNotifier<bool> estaRodando = ValueNotifier<bool>(false);
  final VoidCallback? aoZerar;

  Timer? _timer;

  ContadorController({required this.tempoInicial, this.aoZerar})
    : segundosRestantes = ValueNotifier<int>(tempoInicial);

  // Inicia a regressão
  Future<void> iniciar() async {
    if (estaRodando.value) return;

    estaRodando.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (segundosRestantes.value > 0) {
        segundosRestantes.value--;
      } else {
        parar();
        if (aoZerar != null) aoZerar!();
        NotificationService.dispararTesteInstantaneo(); // Dispara a notificação quando o tempo chegar a zero
        resetar(); // Reseta o contador para o valor inicial
      }
      //NotificationService.cancelarTodosOsAlarmes();
    });
  }

  // Pausa o cronômetro
  void parar() {
    _timer?.cancel();
    estaRodando.value = false;
  }

  // Reseta para o valor inicial
  void resetar() {
    parar();
    segundosRestantes.value = tempoInicial;
  }

  // Formata o número de segundos para String (Ex: 01:23)
  String get tempoFormatado {
    int minutos = segundosRestantes.value ~/ 60;
    int segundos = segundosRestantes.value % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  // Libera a memória do timer
  void dispose() {
    _timer?.cancel();
    segundosRestantes.dispose();
    estaRodando.dispose();
  }
}
