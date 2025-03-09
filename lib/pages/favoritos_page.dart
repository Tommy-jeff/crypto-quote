import 'package:flutter/material.dart';

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
        headerSliverBuilder: (context, __) => [
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
          )
        ],
        body: const Material(),
      ),
    );
  }
}
