import 'package:flutter/material.dart';

class HomePageHeader extends StatelessWidget {
  final String nomeUsuario;
  const HomePageHeader({
    super.key,
    required this.nomeUsuario,
    required sexoUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  child: Text(
                    "Olá $nomeUsuario, Bom Dia!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 165, 77, 45),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                height: 150,
                width: 150,

                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset('assets/man.png', fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Mantenha o foco e hidrate-se!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
