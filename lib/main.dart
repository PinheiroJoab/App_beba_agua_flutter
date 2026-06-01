import 'package:beba_agua/services/notification_service.dart';
import 'package:beba_agua/tela_inicial.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja pronto para inicializar plugins
  await NotificationService.inicializar(); // Inicializa o serviço de notificações
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainNavigationHub(),
    );
  }
}
