import 'package:crypto_quote/meu_aplicativo.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => FavoritosRepository(),
        child: const MeuAplicativo(),
      ),
  );

}

