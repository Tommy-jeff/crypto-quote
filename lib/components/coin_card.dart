import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinCard extends StatefulWidget {
  Moeda moeda;

  CoinCard({super.key, required this.moeda});

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  late NumberFormat real;

  @override
  Widget build(BuildContext context) {
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);

    return Card.outlined(
      margin: EdgeInsets.only(top: 12),
      borderOnForeground: true,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.moeda.sigla,
                        style: TextStyle(fontSize: 13, color: Colors.black45),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20.0),
                child: Text(
                    real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
