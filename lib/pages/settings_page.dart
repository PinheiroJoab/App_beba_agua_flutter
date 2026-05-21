import 'package:flutter/material.dart';
import '../services/storage_service.dart'; // Garanta que o import do seu serviço está correto

class SettingsPage extends StatefulWidget {
  final VoidCallback
  onDadosAtualizados; // Callback para notificar a MainNavigationHub sobre as atualizações'
  const SettingsPage({super.key, required this.onDadosAtualizados});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _idadeController = TextEditingController();
  final _pesoController = TextEditingController();
  String? _sexoSelecionado;

  // Variáveis para controlar o estado da tela
  bool _carregando = true;
  int _metaCalculadaPreview = 0;

  @override
  void initState() {
    super.initState();
    _carregandoDadosAtuais();
  }

  // 1. Carrega os dados do SharedPreferences para dentro dos inputs 💡
  Future<void> _carregandoDadosAtuais() async {
    final nome = await StorageService.getNome();
    final sobrenome = await StorageService.getSobrenome();
    final sexo = await StorageService.getSexo();
    final idade = await StorageService.getIdade();
    final peso = await StorageService.getPeso();
    final meta = await StorageService.getMeta();

    setState(() {
      _nomeController.text = nome;
      _sobrenomeController.text = sobrenome;
      _sexoSelecionado = sexo.isNotEmpty ? sexo : null;
      _idadeController.text = idade > 0 ? idade.toString() : "";
      _pesoController.text = peso > 0 ? peso.toString() : "";
      _metaCalculadaPreview = meta;
      _carregando = false;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _idadeController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  // 2. Função de atualização dos dados 🎯
  Future<void> _salvarNovosDados() async {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text.replaceAll(',', '.'));
      final novaMeta = (peso * 35).round();

      // Salva no SharedPreferences as alterações
      await StorageService.salvarUsuario(
        nome: _nomeController.text.trim(),
        sobrenome: _sobrenomeController.text.trim(),
        sexo: _sexoSelecionado ?? "Masculino",
        idade: int.parse(_idadeController.text),
        peso: peso,
        metaDiaria: novaMeta,
      );

      // Chama o callback para notificar a MainNavigationHub sobre as atualizações
      widget.onDadosAtualizados();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ajustes atualizados com sucesso! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0288D1)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FC),
      appBar: AppBar(
        title: const Text(
          "Meus Dados",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF263238),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _construirCampo(
                  controller: _nomeController,
                  label: "Nome",
                  icon: Icons.person,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Insira seu nome" : null,
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
                    DropdownMenuItem<String>(
                      value: "Masculino",
                      child: Text("Masculino"),
                    ),
                    DropdownMenuItem<String>(
                      value: "Feminino",
                      child: Text("Feminino"),
                    ),
                  ],
                  onChanged: (v) => setState(() => _sexoSelecionado = v),
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
                        // Recalcula a meta em tempo real se o usuário mudar o peso nos Ajustes! 💡
                        onChanged: (valor) {
                          if (valor.isNotEmpty) {
                            final peso = double.tryParse(
                              valor.replaceAll(',', '.'),
                            );
                            if (peso != null) {
                              setState(() {
                                _metaCalculadaPreview = (peso * 35).round();
                              });
                              return;
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Mostra a meta recalculada baseada no novo peso digitado
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0288D1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Sua meta atualizada será: $_metaCalculadaPreview ml",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0288D1),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _salvarNovosDados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Salvar Alterações",
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

  // O nosso método auxiliar, agora com onChanged opcional!
  Widget _construirCampo({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
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
