import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/pages/moeda_detalhe_page.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class CoinCard extends StatefulWidget {
  Moeda moeda;

  CoinCard({super.key, required this.moeda});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  late NumberFormat real;

  static Map<String, Color> precoColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigo,
  };

  abrirDetalhes() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MoedaDetalhePage(moeda: widget.moeda)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Moeda> alterFav = [widget.moeda];
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Card(
      margin: EdgeInsets.only(top: 12),
      elevation: 1,
      child: InkWell(
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
                      Text(
                        widget.moeda.nome,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: TextStyle(fontSize: 13, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: precoColor['down']!.withAlpha(5),
                  border: Border.all(color: precoColor['down']!.withAlpha(5)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 16,
                    color: precoColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          title: Text("Remover das favoritas"),
                          onTap: () {
                            Navigator.pop(context);
                            Provider.of<FavoritosRepository>(
                              context,
                              listen: false,
                            ).alterFav(alterFav);
                          },
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
