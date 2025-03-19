import 'package:crypto_quote/components/coin_card.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                snap: true,
                floating: true,
                centerTitle: true,
                title: Text("Favoritos", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
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
          color: Colors.indigo.withAlpha(5),
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
                      return CoinCard(moeda: favoritos.listaFavoritos[index]);
                    },
                  );
            },
          ),
        ),
      ),
    );
  }
}
