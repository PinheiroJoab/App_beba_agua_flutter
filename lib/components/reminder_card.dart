import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String ultimoRegistroHora;
  final int ultimoRegistroML;
  final String proximoLembreteHora;
  final int minutosRestantes;

  const ReminderCard({
    super.key,
    required this.ultimoRegistroHora,
    required this.ultimoRegistroML,
    required this.proximoLembreteHora,
    required this.minutosRestantes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // 1. Linha do Último Registro
          Text(
            "Último registro: $ultimoRegistroHora",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Card do Próximo Lembrete
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Próximo Lembrete",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0288D1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Te avisarei às $proximoLembreteHora",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
