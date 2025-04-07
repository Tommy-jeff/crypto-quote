import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _carteira = [];
  List<Historico> _historico = [];
  double _saldo = 0;

  double get saldo => _saldo;

  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
    await _getCarteira();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query("conta", limit: 1);
    _saldo = conta.first["saldo"];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;

    db.update("conta", {"saldo": valor});

    _saldo = valor;
    notifyListeners();
  }

  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      /// verificar se a moeda ja foi comprada antes
      final posicaoMoeda = await txn.query(
        "carteira",
        where: "sigla = ?",
        whereArgs: [moeda.sigla],
      );

      ///se não tem a moeda em carteira
      if (posicaoMoeda.isEmpty) {
        await txn.insert("carteira", {
          "sigla": moeda.sigla,
          "moeda": moeda.nome,
          "quantidade": (valor / moeda.preco).toString(),
        });
      }
      /// se já tem a moeda em carteira
      else {
        final atual = double.parse(posicaoMoeda.first["quantidade"].toString());
        await txn.update(
          "carteira",
          {"quantidade": (atual + (valor / moeda.preco)).toString()},
          where: "sigla = ?",
          whereArgs: [moeda.sigla],
        );
      }

      /// inserir a compra no histórico
      await txn.insert("historico", {
        "sigla": moeda.sigla,
        "moeda": moeda.nome,
        "quantidade": (valor / moeda.preco).toString(),
        "valor": valor,
        "tipo_operacao": "compra",
        "data_operacao": DateTime.now().millisecondsSinceEpoch,
      });

      /// Atualizar o saldo
      await txn.update("conta", {"saldo": saldo - valor});
    });

    await _initRepository();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira = [];
    List posicoes = await db.query("carteira");
    for (var posicao in posicoes) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == posicao["sigla"],
      );
      _carteira.add(Posicao(moeda: moeda, quantidade: double.parse(posicao["quantidade"])));
    }
    notifyListeners();
  }
}
