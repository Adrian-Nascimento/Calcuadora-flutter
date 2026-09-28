import 'package:flutter/material.dart';
import 'troco_screen.dart';
import 'parcelamento_sem_juros_screen.dart';
import 'meta_de_poupanca_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadoras Financeiras')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.calculate,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _abrir(context, const TrocoScreen()),
              icon: const Icon(Icons.payments),
              label: const Text('Calculadora de Troco'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  _abrir(context, const ParcelamentoSemJurosScreen()),
              icon: const Icon(Icons.credit_card),
              label: const Text('Parcelamento sem Juros'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _abrir(context, const MetaDePoupancaScreen()),
              icon: const Icon(Icons.savings),
              label: const Text('Meta de Poupança'),
            ),
          ],
        ),
      ),
    );
  }
}