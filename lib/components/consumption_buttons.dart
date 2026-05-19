import 'package:flutter/material.dart';

class ConsumptionButtons extends StatelessWidget {
  final Function(int) onAddWater;

  const ConsumptionButtons({super.key, required this.onAddWater});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text(
            "Registrar Consumo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBtn(
                Icons.local_drink,
                "Copo\n200ml",
                () => onAddWater(200),
              ),
              _buildBtn(
                Icons.local_drink,
                "Copo\n300ml",
                () => onAddWater(300),
              ),
              _buildBtn(Icons.water, "Garrafa\n500ml", () => onAddWater(500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(IconData icone, String label, VoidCallback onTap) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF03A9F4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF03A9F4).withValues(alpha: 0.2),
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(icone, color: const Color(0xFF0288D1), size: 28),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: -6,
                  right: -2,
                  child: Icon(
                    Icons.add_circle,
                    color: Color(0xFF01579B),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
