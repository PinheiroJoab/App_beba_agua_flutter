import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSetupComplete;

  const WelcomePage({super.key, required this.onSetupComplete});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  String? _sexoSelecionado;
  int _previsaoMeta = 0;

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _finalizarCadastro() {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text.replaceAll(',', '.'));

      // Cálculo inteligente da meta: 35ml por kg
      final metaCalculada = (peso * 35).round();

      // Envia os dados coletados de volta para o app principal
      // Dentro de welcome_page.dart, mude o widget.onSetupComplete para enviar o mapa completo:
      widget.onSetupComplete({
        'nome': _nomeController.text.trim(),
        'sobrenome': _sobrenomeController.text.trim(),
        'sexo': _sexoSelecionado,
        'idade': int.parse(_idadeController.text),
        'peso': peso,
        'metaDiaria': metaCalculada,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Ícone ou Logo de gota d'água do app
                const Icon(
                  Icons.water_drop,
                  color: Color(0xFF0288D1),
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Bem-vindo ao Beba Água!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Para começarmos, precisamos de alguns dados para calcular sua meta ideal de hidratação.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 32),

                _construirCampo(
                  controller: _nomeController,
                  label: "Nome",
                  icon: Icons.person,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Insira seu nome" : null,
                ),
                const SizedBox(height: 16),

                _construirCampo(
                  controller: _sobrenomeController,
                  label: "Sobrenome",
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Insira seu sobrenome" : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: _sexoSelecionado,
                  hint: const Text("Selecione o sexo"),
                  decoration: InputDecoration(
                    labelText: "Sexo",
                    prefixIcon: const Icon(Icons.wc, color: Color(0xFF0288D1)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Masculino",
                      child: Text("Masculino"),
                    ),
                    DropdownMenuItem(
                      value: "Feminino",
                      child: Text("Feminino"),
                    ),
                  ],
                  onChanged: (v) => setState(() => _sexoSelecionado = v),
                  validator: (v) => v == null ? "Selecione o sexo" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _construirCampo(
                        controller: _idadeController,
                        label: "Idade",
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Obrigatório" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _construirCampo(
                        controller: _pesoController,
                        label: "Peso (kg)",
                        icon: Icons.scale,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "Obrigatório" : null,
                        onChanged: (valor) {
                          if (valor!.isNotEmpty) {
                            final peso = double.tryParse(
                              valor.replaceAll(',', '.'),
                            );
                            if (peso != null) {
                              setState(() {
                                _previsaoMeta = (peso * 35).round();
                              });
                              return;
                            }
                          }
                          setState(() {
                            _previsaoMeta = 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (_previsaoMeta > 0) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0288D1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.opacity, color: Color(0xFF0288D1)),
                        const SizedBox(width: 12),
                        Text(
                          "Sua meta diária: $_previsaoMeta ml",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 40),

                ElevatedButton(
                  onPressed: _finalizarCadastro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Começar a Usar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _construirCampo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
    ValueChanged<String?>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0288D1)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
