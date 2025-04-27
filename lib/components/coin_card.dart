import 'dart:developer';

import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/const.dart';
import '../pages/moeda_detalhe_page.dart';
import '../repositories/favoritos_repository.dart';

class CoinCard extends StatefulWidget {
  Moeda moeda;
  List<Moeda> selecionadas;
  final void Function(Moeda) onLongPress;

  CoinCard({super.key, required this.moeda, required this.selecionadas, required this.onLongPress});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  late NumberFormat real;
  late FavoritosRepository favoritosRepository;

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MoedaDetalhePage(moeda: moeda)),
    );
  }

  @override
  Widget build(BuildContext context) {
    favoritosRepository = context.watch<FavoritosRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Card.outlined(
      margin: EdgeInsets.only(top: 12),
      color:
          widget.selecionadas.contains(widget.moeda) ? Const.tomatoWhite : null,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onTap: () => mostrarDetalhes(widget.moeda),
        onLongPress: () {
          widget.onLongPress(widget.moeda);
        },
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              widget.selecionadas.contains(widget.moeda)
                  ? Icon(
                    Icons.check_circle_rounded,
                    size: 40.0,
                    color: Colors.black87,
                  )
                  : Image.asset(widget.moeda.icone, height: 40),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.moeda.nome,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        spacing: 10.0,
                        children: [
                          Text(
                            widget.moeda.sigla,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black45,
                            ),
                          ),
                          Visibility(
                            visible: favoritosRepository.listaFavoritos.any(
                              (fav) => fav.sigla == widget.moeda.sigla,
                            ),
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Text(
                  real.format(widget.moeda.preco),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
