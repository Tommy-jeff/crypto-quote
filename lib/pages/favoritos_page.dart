import 'dart:developer';

import 'package:crypto_quote/components/coin_favorite_card.dart';
import 'package:crypto_quote/configs/const.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {

  late MoedaRepository moedaRepository;
  List<Moeda> favCoinsList = [];

  @override
  void initState() {
    log("initState called on favorite page");
    for (var item in favCoinsList) {
      log("favCoinsList item: ${item.sigla}");
    }
    moedaRepository = MoedaRepository();
    getCoins();
    super.initState();
  }

  getCoins() async {
    List favCoinInDb = await moedaRepository.getFavoriteList();
    log("getCoins called on favorite page");
    for (var favCoin in favCoinInDb){
      var dup = favCoinsList.where((t) => t.sigla == favCoin.sigla);
      if(dup.isEmpty) {
        favCoinsList.add(favCoin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    moedaRepository = context.watch<MoedaRepository>();
    getCoins();

    return NestedScrollView(
        headerSliverBuilder:
            (context, __) => [
              SliverAppBar(
                toolbarHeight: 70,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    )
                ),
                snap: true,
                floating: true,
                centerTitle: true,
                title: Text("Favoritos", style: TextStyle(color: Colors.white)),
                backgroundColor: Const.tomato,
                actions: [
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.swap_vert),
                    color: Colors.white,
                  ),
                ],
              ),
            ],
        body: Scaffold(
          body: Container(
            color: Colors.red.withAlpha(10),
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: favCoinsList.isEmpty
                ? ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Ainda não há favoritos"),
                )
                : ListView.builder(
                  itemCount: favCoinsList.length,
                  itemBuilder: (_, index) {
                    return CoinFavoriteCard(moeda: favCoinsList[index]);
                  },
                ),
          ),
        ),
      );
  }
}
