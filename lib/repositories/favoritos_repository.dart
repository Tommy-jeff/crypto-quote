import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../adapters/moeda_hive_adapter.dart';
import '../models/moeda.dart';

class FavoritosRepository extends ChangeNotifier{
  final List<Moeda> _listaFavoritos = [];
  late LazyBox box;

  FavoritosRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox() async {
    Hive.registerAdapter(MoedaHiveAdapter());
    box = await Hive.openLazyBox<Moeda>("moedas_favoritas");
  }

  _readFavoritas() async {
    for (dynamic key in box.keys){
      Moeda m = await box.get(key);
      _listaFavoritos.add(m);
      notifyListeners();
    }
  }

  UnmodifiableListView<Moeda> get listaFavoritos => UnmodifiableListView(_listaFavoritos);

  alterFav(List<Moeda> moedas){
    for (Moeda moeda in moedas){
      if(!_listaFavoritos.any((atual) => atual.sigla == moeda.sigla)){
        _listaFavoritos.add(moeda);
        box.put(moeda.sigla, moeda);
      } else if (_listaFavoritos.any((atual) => atual.sigla == moeda.sigla)){
        _listaFavoritos.remove(moeda);
        box.delete(moeda.sigla);
      }
    }
    notifyListeners();
  }

}