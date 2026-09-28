import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/resultado_troco.dart';

class TrocoScreen extends StatefulWidget {
  const TrocoScreen({super.key});

  @override
  State<TrocoScreen> createState() => _TrocoScreenState();
}

class _TrocoScreenState extends State<TrocoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _compraController = TextEditingController();
  final _pagoController = TextEditingController();
  final _moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  ResultadoTroco? _resultado;

  @override
  void dispose() {
    _compraController.dispose();
    _pagoController.dispose();
    super.dispose();
  }

  double? _lerNumero(String? texto) {
    return double.tryParse((texto ?? '').trim().replaceAll(',', '.'));
  }

  String? _validarValor(String? texto) {
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

  void _calcularTroco() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _resultado = null);
      return;
    }

    final compra = _lerNumero(_compraController.text)!;
    final pago = _lerNumero(_pagoController.text)!;
    final troco = pago - compra;

    setState(() {
      _resultado = ResultadoTroco(
        valorCompra: compra,
        valorPago: pago,
        troco: troco < 0 ? 0 : troco,
        pagamentoSuficiente: pago >= compra,
      );
    });
  }

  Widget _construirResultado(BuildContext context) {
    final resultado = _resultado!;
    final cor = Theme.of(context).colorScheme.primary;

    if (!resultado.pagamentoSuficiente) {
      final falta = resultado.valorCompra - resultado.valorPago;
      return Column(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orangeAccent, size: 40),
          const SizedBox(height: 8),
          Text(
            'Valor pago insuficiente! Faltam ${_moeda.format(falta)}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Text('Troco', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          _moeda.format(resultado.troco),
          style: TextStyle(
            color: cor,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Troco')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _compraController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor da compra (R\$)',
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pagoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor pago pelo cliente (R\$)',
                ),
                validator: _validarValor,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calcularTroco,
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