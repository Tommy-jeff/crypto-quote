import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/posicao.dart';

class ContaRepository extends ChangeNotifier {

  late Database db;
  final List<Posicao> _carteira = [];
  double _saldo = 0;

  double get saldo => _saldo;
  List<Posicao> get carteira => _carteira;

  ContaRepository(){
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query("conta", limit: 1);
    _saldo = conta.first["saldo"];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = DB.instance.database;

    db.update("conta", {
      "saldo" : valor
    });

    _saldo = valor;
    notifyListeners();
  }

}