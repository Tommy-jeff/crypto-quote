import 'dart:developer';

import 'package:crypto_quote/models/moeda.dart';
import 'package:flutter/material.dart';

class MoedaRepository extends ChangeNotifier{

  static List<Moeda> tabela = [
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
      icone: 'images/ethereum-eth-logo.png',
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
    Moeda(
      icone: 'images/avalanche-avax-logo.png',
      nome: 'Avalanche',
      sigla: 'AVAX',
      preco: 100.66,
    ),
    Moeda(
      icone: 'images/bitcoin-cash-bch-logo.png',
      nome: 'Bitcoin Cash',
      sigla: 'BCH',
      preco: 1953.35,
    ),
    Moeda(
      icone: 'images/bnb-bnb-logo.png',
      nome: 'BNB',
      sigla: 'BNB',
      preco: 3206.81,
    ),
    Moeda(
      icone: 'images/chainlink-link-logo.png',
      nome: 'Chainlink',
      sigla: 'LINK',
      preco: 75.97,
    ),
    Moeda(
      icone: 'images/dogecoin-doge-logo.png',
      nome: 'Doge',
      sigla: 'DOGE',
      preco: 0.95,
    ),
    Moeda(
      icone: 'images/polkadot-new-dot-logo.png',
      nome: 'Polkadot',
      sigla: 'DOT',
      preco: 23.30,
    ),
    Moeda(
      icone: 'images/shiba-inu-shib-logo.png',
      nome: 'Shiba Inu',
      sigla: 'SHIB',
      preco: 0.000007,
    ),
    Moeda(
      icone: 'images/solana-sol-logo.png',
      nome: 'Solona',
      sigla: 'SOL',
      preco: 724.34,
    ),
    Moeda(
      icone: 'images/stellar-xlm-logo.png',
      nome: 'Stellar',
      sigla: 'XLM',
      preco: 1.48,
    ),
    Moeda(
      icone: 'images/sui-sui-logo.png',
      nome: 'Sui',
      sigla: 'SUI',
      preco: 12.95,
    ),
    Moeda(
      icone: 'images/tether-usdt-logo.png',
      nome: 'Tether',
      sigla: 'USDT',
      preco: 5.81,
    ),
    Moeda(
      icone: 'images/toncoin-ton-logo.png',
      nome: 'Toncoin',
      sigla: 'TON',
      preco: 15.34,
    ),
    Moeda(
      icone: 'images/tron-trx-logo.png',
      nome: 'Tron',
      sigla: 'TRX',
      preco: 1.30,
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
