import 'dart:developer';

import 'package:crypto_quote/database/db.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class MoedaRepository extends ChangeNotifier {
  late Database db;
  List<Moeda> favoritos = [];
  static List<Moeda> tabela = [
    Moeda(
      icone: 'images/bitcoin.png',
      nome: 'Bitcoin',
      sigla: 'BTC',
      preco: 531146.46,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/cardano.png',
      nome: 'Cardano',
      sigla: 'ADA',
      preco: 5.67,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/ethereum-eth-logo.png',
      nome: 'Ethereum',
      sigla: 'ETH',
      preco: 13375.81,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/litecoin.png',
      nome: 'Litecoin',
      sigla: 'LTC',
      preco: 683.15,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/usdc.png',
      nome: 'USDC',
      sigla: 'USDC',
      preco: 5.97,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/xrp.png',
      nome: 'XRP',
      sigla: 'XRP',
      preco: 15.32,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/avalanche-avax-logo.png',
      nome: 'Avalanche',
      sigla: 'AVAX',
      preco: 100.66,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/bitcoin-cash-bch-logo.png',
      nome: 'Bitcoin Cash',
      sigla: 'BCH',
      preco: 1953.35,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/bnb-bnb-logo.png',
      nome: 'BNB',
      sigla: 'BNB',
      preco: 3206.81,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/chainlink-link-logo.png',
      nome: 'Chainlink',
      sigla: 'LINK',
      preco: 75.97,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/dogecoin-doge-logo.png',
      nome: 'Doge',
      sigla: 'DOGE',
      preco: 0.95,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/polkadot-new-dot-logo.png',
      nome: 'Polkadot',
      sigla: 'DOT',
      preco: 23.30,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/shiba-inu-shib-logo.png',
      nome: 'Shiba Inu',
      sigla: 'SHIB',
      preco: 0.000007,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/solana-sol-logo.png',
      nome: 'Solona',
      sigla: 'SOL',
      preco: 724.34,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/stellar-xlm-logo.png',
      nome: 'Stellar',
      sigla: 'XLM',
      preco: 1.48,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/sui-sui-logo.png',
      nome: 'Sui',
      sigla: 'SUI',
      preco: 12.95,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/tether-usdt-logo.png',
      nome: 'Tether',
      sigla: 'USDT',
      preco: 5.81,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/toncoin-ton-logo.png',
      nome: 'Toncoin',
      sigla: 'TON',
      preco: 15.34,
      dolarPreco: 0,
      favorito: 0,
    ),
    Moeda(
      icone: 'images/tron-trx-logo.png',
      nome: 'Tron',
      sigla: 'TRX',
      preco: 1.30,
      dolarPreco: 0,
      favorito: 0,
    ),
  ];

  MoedaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await populateCoinTable();
  }

  // todo conect to api
  populateCoinTable() async {
    for (Moeda item in tabela) {
      await insertCoin(item);
      notifyListeners();
    }
  }

  deleteCoin() async {
    db = DB.instance.database;

  }


  Future<List<Moeda>> getCoins() async {
    db = await DB.instance.database;
    List<Moeda> coins = [];
    List coinsQuery = await db.query("moeda");
    for (var coin in coinsQuery) {
      coins.add(
        Moeda(
          icone: coin["icone"],
          nome: coin["nome"],
          sigla: coin["sigla"],
          preco: coin["preco"],
          dolarPreco: coin["dolar_preco"],
          favorito: coin["favorito"],
        ),
      );
    }
    log("getCoins query: $coins");
    return coins;
  }

  Future<void> insertCoin(Moeda moeda) async {
    db = await DB.instance.database;
    await db.transaction((ins) async {
      final verifyCoin = await ins.query("moeda",
          where: "sigla = ?",
          whereArgs: [moeda.sigla]
      );
      if(verifyCoin.isEmpty){
        await ins.insert("moeda", {
          "nome": moeda.nome,
          "sigla": moeda.sigla,
          "icone": moeda.icone,
          "preco": moeda.preco,
          "dolar_preco": moeda.dolarPreco,
          "favorito": moeda.favorito,
        });
      }
    });
    notifyListeners();
  }

  Future<List<String>> getFavoriteList() async {
    db = await DB.instance.database;
    List<String> favs = [];
    List moedas = await db.query("moeda", where: "favorito = ?", whereArgs: [1]);
    for (var moeda in moedas) {
        favs.add(moeda["sigla"]);
    }
    notifyListeners();
    return favs;
  }

  getCoinFavTest(String sigla) async {
    db = await DB.instance.database;
    var coin = await db.query("moeda", where: "sigla = ?", whereArgs: [sigla]);
    log("getCoinFavTest: $coin");
  }

  favoriteCoin(List<Moeda> coins) async {
    db = await DB.instance.database;
    List updates = [];
    for (var c in coins) {
      var up = await db.update("moeda", {"favorito": 1}, where: "sigla = ?", whereArgs: [c.sigla]);
      log("Favoritando as moedas: ${c.nome}");
      updates.add(up);
    }

    await getCoinFavTest(coins.first.sigla);
    notifyListeners();
  }

  sort(int type) {
    /// type of filters:
    /// type 1 = filter the name from a to z
    /// type 2 = filter the name from z to a
    /// type 3 = filter the value from highest value to lowest value
    /// type 4 = filter the value from lowest value to highest value
    switch (type) {
      case (1):
        tabela.sort((Moeda a, Moeda b) => a.nome.compareTo(b.nome));
      case (2):
        tabela.sort((Moeda a, Moeda b) => b.nome.compareTo(a.nome));
      case (3):
        tabela.sort((Moeda a, Moeda b) => b.preco.compareTo(a.preco));
      case (4):
        tabela.sort((Moeda a, Moeda b) => a.preco.compareTo(b.preco));
    }
    notifyListeners();
  }
}
