import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  late MoedaRepository moedaRepository;

  // List<String> listaFav = [];

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MoedaDetalhePage(moeda: moeda)));
  }

  @override
  void initState() {
    moedaRepository = MoedaRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    favoritosRepository = context.watch<FavoritosRepository>();
    moedaRepository = context.watch<MoedaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Card.outlined(
      margin: EdgeInsets.only(top: 12),
      color: widget.selecionadas.contains(widget.moeda) ? Colors.blueGrey[50] : null,
      // shadowColor: Const.tomato,
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
              Image.asset(widget.moeda.icone, height: 40),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.moeda.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      Row(
                        spacing: 10.0,
                        children: [
                          widget.moeda.favorito == 1
                              ? Icon(Icons.star_rounded, color: Colors.amber, size: 22)
                              : Icon(Icons.star_border_rounded, color: Colors.grey, size: 20),
                          Text(widget.moeda.sigla, style: TextStyle(fontSize: 13, color: Colors.black45)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(margin: EdgeInsets.only(right: 20.0), child: Text(real.format(widget.moeda.preco), style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }
}
