import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/pages/moeda_detalhe_page.dart';
import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';
import '../configs/const.dart';

class CoinFavoriteCard extends StatefulWidget {
  Moeda moeda;

  CoinFavoriteCard({super.key, required this.moeda});

  @override
  State<CoinFavoriteCard> createState() => _CoinFavoriteCardState();
}

class _CoinFavoriteCardState extends State<CoinFavoriteCard> {
  late NumberFormat real;
  bool confirmDelete = false;

  static Map<String, Color> precoColor = <String, Color>{'up': Const.zucchini, 'down': Const.denim};

  abrirDetalhes() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => MoedaDetalhePage(moeda: widget.moeda)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Card.outlined(
      margin: EdgeInsets.only(top: 12),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        onTap: () => abrirDetalhes(),
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
                      Text(widget.moeda.sigla, style: TextStyle(fontSize: 13, color: Colors.black45)),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: precoColor['down']!.withAlpha(5),
                  border: Border.all(color: precoColor['down']!.withAlpha(5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(real.format(widget.moeda.preco), style: TextStyle(fontSize: 16, color: precoColor['down'], letterSpacing: -1)),
              ),
              IconButton(
                onPressed: () {
                  if (confirmDelete) {
                    Provider.of<MoedaRepository>(context, listen: false).desfavoriteCoin(widget.moeda.sigla);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Const.tomato,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text("Moeda ${widget.moeda.nome} desfavoritada"),
                        ),
                      ),
                    );
                  }
                  setState(() {
                    confirmDelete = !confirmDelete;
                  });
                },
                onLongPress: () {
                  setState(() {
                    confirmDelete = false;
                  });
                },
                icon:
                    !confirmDelete
                        ? Icon(Icons.delete_outline_rounded)
                        : Column(
                          children: [
                            Icon(Icons.delete_forever_rounded, color: Const.tomato, size: 30),
                            Icon(Icons.touch_app_rounded, color: Const.tomato),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
