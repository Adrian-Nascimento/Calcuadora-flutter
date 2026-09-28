import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resultado_meta_de_poupanca.dart';

class MetaDePoupancaScreen extends StatefulWidget {
  const MetaDePoupancaScreen({super.key});

  @override
  State<MetaDePoupancaScreen> createState() => _MetaDePoupancaScreenState();
}

class _MetaDePoupancaScreenState extends State<MetaDePoupancaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _metaController = TextEditingController();
  final _economizadoController = TextEditingController();
  final _mesesController = TextEditingController();
  final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  ResultadoMetaDePoupanca? _resultado;

  @override
  void dispose() {
    _metaController.dispose();
    _economizadoController.dispose();
    _mesesController.dispose();
    super.dispose();
  }

  double? _lerNumero(String? texto) {
    return double.tryParse((texto ?? '').trim().replaceAll(',', '.'));
  }

  String? _validarMeta(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Preencha este campo';
    }
    final numero = _lerNumero(texto);
    if (numero == null) {
      return 'Digite um número válido';
    }
    if (numero <= 0) {
      return 'O valor deve ser maior que zero';
    }
    return null;
  }

  String? _validarEconomizado(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Preencha este campo';
    }
    final numero = _lerNumero(texto);
    if (numero == null) {
      return 'Digite um número válido';
    }
    if (numero < 0) {
      return 'O valor não pode ser negativo';
    }
    return null;
  }

  String? _validarMeses(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Preencha este campo';
    }
    final numero = int.tryParse(texto.trim());
    if (numero == null) {
      return 'Digite um número inteiro válido';
    }
    if (numero < 1) {
      return 'Informe pelo menos 1 mês';
    }
    return null;
  }

  void _calcularMeta() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _resultado = null);
      return;
    }

    final meta = _lerNumero(_metaController.text)!;
    final economizado = _lerNumero(_economizadoController.text)!;
    final meses = int.parse(_mesesController.text.trim());
    final falta = meta - economizado;
    final atingida = falta <= 0;

    setState(() {
      _resultado = ResultadoMetaDePoupanca(
        meta: meta,
        valorEconomizado: economizado,
        mesesRestantes: meses,
        faltaPoupar: atingida ? 0 : falta,
        valorPorMes: atingida ? 0 : falta / meses,
        metaAtingida: atingida,
      );
    });
  }

  Widget _construirResultado(BuildContext context) {
    final resultado = _resultado!;
    final cor = Theme.of(context).colorScheme.primary;

    if (resultado.metaAtingida) {
      return Text(
        'Parabéns! Você já atingiu a meta.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Column(
      children: [
        const Text('Ainda falta poupar', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          _moeda.format(resultado.faltaPoupar),
          style: TextStyle(
            color: cor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        const Text('Guardar por mês', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          _moeda.format(resultado.valorPorMes),
          style: TextStyle(
            color: cor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meta de Poupança')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _metaController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor da meta (R\$)',
                ),
                validator: _validarMeta,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _economizadoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor já economizado (R\$)',
                ),
                validator: _validarEconomizado,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mesesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meses restantes até a meta',
                ),
                validator: _validarMeses,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcularMeta,
                child: const Text('Calcular'),
              ),
              if (_resultado != null) ...[
                const SizedBox(height: 32),
                _construirResultado(context),
              ],
            ],
          ),
        ),
      ),
    );
  }
}