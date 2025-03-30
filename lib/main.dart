import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/meu_aplicativo.dart';
import 'package:crypto_quote/repositories/conta_repository.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContaRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritosRepository()),
      ],
      child: const MeuAplicativo(),
    ),
  );
}
