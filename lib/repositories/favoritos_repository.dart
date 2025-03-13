import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../models/moeda.dart';

class FavoritosRepository extends ChangeNotifier{
  List<Moeda> _listaFavoritos = [];

  UnmodifiableListView<Moeda> get listaFavoritos => UnmodifiableListView(_listaFavoritos);

  alterFav(List<Moeda> moedas){
    for (Moeda moeda in moedas){
      if(!_listaFavoritos.contains(moeda)) {
          _listaFavoritos.add(moeda);
        } else if (_listaFavoritos.contains(moeda)) {
        _listaFavoritos.remove(moeda);
      }
    }
    notifyListeners();
  }

  // remove(List<Moeda> moedas){
  //   for(Moeda moeda in moedas){
  //     if(_listaFavoritos.contains(moeda)) _listaFavoritos.remove(moeda);
  //   }
  //   notifyListeners();
  // }

}