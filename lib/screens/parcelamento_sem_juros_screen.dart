import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resultado_parcelamento_sem_juros.dart';

class ParcelamentoSemJurosScreen extends StatefulWidget {
  const ParcelamentoSemJurosScreen({super.key});

  @override
  State<ParcelamentoSemJurosScreen> createState() =>
      _ParcelamentoSemJurosScreenState();
}

class _ParcelamentoSemJurosScreenState
    extends State<ParcelamentoSemJurosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalController = TextEditingController();
  final _parcelasController = TextEditingController();
  final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  ResultadoParcelamentoSemJuros? _resultado;

  @override
  void dispose() {
    _totalController.dispose();
    _parcelasController.dispose();
    super.dispose();
  }

  String? _validarTotal(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Preencha este campo';
    }
    final numero = double.tryParse(texto.trim().replaceAll(',', '.'));
    if (numero == null) {
      return 'Digite um número válido';
    }
    if (numero <= 0) {
      return 'O valor deve ser maior que zero';
    }
    return null;
  }

  String? _validarParcelas(String? texto) {
    if (texto == null || texto.trim().isEmpty) {
      return 'Preencha este campo';
    }
    final numero = int.tryParse(texto.trim());
    if (numero == null) {
      return 'Digite um número inteiro válido';
    }
    if (numero < 1) {
      return 'Informe pelo menos 1 parcela';
    }
    return null;
  }

  void _calcularParcelamento() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _resultado = null);
      return;
    }

    final total = double.parse(_totalController.text.trim().replaceAll(',', '.'));
    final parcelas = int.parse(_parcelasController.text.trim());

    setState(() {
      _resultado = ResultadoParcelamentoSemJuros(
        valorTotal: total,
        numeroParcelas: parcelas,
        valorParcela: total / parcelas,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Parcelamento sem Juros')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _totalController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor total da compra (R\$)',
                ),
                validator: _validarTotal,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _parcelasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de parcelas',
                ),
                validator: _validarParcelas,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcularParcelamento,
                child: const Text('Calcular'),
              ),
              if (_resultado != null) ...[
                const SizedBox(height: 32),
                Text(
                  '${_resultado!.numeroParcelas}x de',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _moeda.format(_resultado!.valorParcela),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${_moeda.format(_resultado!.valorTotal)} (sem juros)',
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}