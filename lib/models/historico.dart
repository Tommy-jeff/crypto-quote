import 'package:crypto_quote/models/moeda.dart';

class Historico {
  DateTime dataOperacao;
  String tipoOperacao;
  Moeda moeda;
  double valor;
  double quantidade;

  Historico({required this.dataOperacao, required this.tipoOperacao, required this.moeda, required this.valor, required this.quantidade});
}
