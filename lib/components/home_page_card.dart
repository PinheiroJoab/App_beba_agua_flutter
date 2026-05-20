import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterCard extends StatefulWidget {
  final int consumoAtual;
  final int metaDiaria;
  final double porcentagem;

  const WaterCard({
    super.key,
    required this.consumoAtual,
    required this.metaDiaria,
    required this.porcentagem,
  });

  @override
  State<WaterCard> createState() => _WaterCardState();
}

class _WaterCardState extends State<WaterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 77, 173, 252),
            Color.fromARGB(230, 183, 218, 243),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB3E5FC),
                      width: 8,
                    ),
                  ),
                ),
                ClipOval(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget? child) {
                      return CustomPaint(
                        size: const Size(200, 200),
                        painter: WavePainter(
                          waveAnimation: _animationController.value,
                          porcentagemPreencimento: widget.porcentagem,
                        ),
                      );
                    },
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(widget.porcentagem * 100).toInt()}%",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.consumoAtual}ml",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Meta de hoje:\n${widget.metaDiaria}ml",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            widget.consumoAtual >= widget.metaDiaria
                ? "Parabéns! Meta batida! 🎉"
                : "Faltam ${widget.metaDiaria - widget.consumoAtual}ml para bater a meta!",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF37474F),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveAnimation;
  final double porcentagemPreencimento;

  WavePainter({
    required this.waveAnimation,
    required this.porcentagemPreencimento,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF03A9F4).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    final path = Path();

    final nivelDaAgua = size.height * (1.0 - porcentagemPreencimento);

    const amplitudeOnda = 8.0;
    const comprimentoOnda = 2 * math.pi;

    path.moveTo(0, nivelDaAgua);

    for (double x = 0; x <= size.width; x++) {
      final y =
          nivelDaAgua +
          amplitudeOnda *
              math.sin(
                (x / size.width * comprimentoOnda) +
                    (waveAnimation * 2 * math.pi),
              );
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.waveAnimation != waveAnimation ||
        oldDelegate.porcentagemPreencimento != porcentagemPreencimento;
  }
}
