class ResultadoTroco {
  final double valorCompra;
  final double valorPago;
  final double troco;
  final bool pagamentoSuficiente;

  ResultadoTroco({
    required this.valorCompra,
    required this.valorPago,
    required this.troco,
    required this.pagamentoSuficiente,
  });
}