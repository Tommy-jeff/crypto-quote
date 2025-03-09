import 'dart:developer';

import 'package:crypto_quote/models/moeda.dart';
import 'package:flutter/material.dart';

class MoedaRepository extends ChangeNotifier{

  List<Moeda> tabela = [
    Moeda(
      icone: 'images/bitcoin.png',
      nome: 'Bitcoin',
      sigla: 'BTC',
      preco: 531146.46,
    ),
    Moeda(
      icone: 'images/cardano.png',
      nome: 'Cardano',
      sigla: 'ADA',
      preco: 5.67,
    ),
    Moeda(
      icone: 'images/ethereum.png',
      nome: 'Ethereum',
      sigla: 'ETH',
      preco: 13375.81,
    ),
    Moeda(
      icone: 'images/litecoin.png',
      nome: 'Litecoin',
      sigla: 'LTC',
      preco: 683.15,
    ),
    Moeda(
      icone: 'images/usdc.png',
      nome: 'USDC',
      sigla: 'USDC',
      preco: 5.97,
    ),
    Moeda(
      icone: 'images/xrp.png',
      nome: 'XRP',
      sigla: 'XRP',
      preco: 15.32,
    ),
  ];

  bool isSorted = false;
  sort() {
    if(!isSorted) {
      tabela.sort((Moeda a, Moeda b) => a.nome.compareTo(b.nome));
      isSorted = true;
    } else {
      tabela = tabela.reversed.toList();
    }
    notifyListeners();
  }

}
