import 'package:crypto_quote/components/coin_favorite_card.dart';
import 'package:crypto_quote/configs/const.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
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
        body: Container(
          color: Colors.red.withAlpha(10),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(12.0),
          child: Consumer<FavoritosRepository>(
            builder: (context, favoritos, child) {
              return favoritos.listaFavoritos.isEmpty
                  ? ListTile(
                    leading: Icon(Icons.star),
                    title: Text("Ainda não há favoritos"),
                  )
                  : ListView.builder(
                    itemCount: favoritos.listaFavoritos.length,
                    itemBuilder: (_, index) {
                      return CoinFavoriteCard(moeda: favoritos.listaFavoritos[index]);
                    },
                  );
            },
          ),
        ),
      ),
    );
  }
}
