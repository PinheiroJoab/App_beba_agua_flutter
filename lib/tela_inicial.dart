import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tempoRestante = 3600;

  @override
  Widget build(BuildContext context) {
    double progresso = 2000;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          "Olá Usuário, Bom Dia!",
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
              ),
              Text(
                'Manenha o foco e hidrate-se!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Card(
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: BoxBorder.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: CircularProgressIndicator(
                                value: 1,
                                strokeWidth: 8,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: CircularProgressIndicator(
                                value: progresso, // Aqui o círculo diminui
                                strokeWidth: 12,
                                strokeCap:
                                    StrokeCap.round, // Pontas arredondadas
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
