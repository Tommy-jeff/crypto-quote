import 'package:flutter/material.dart';

import '../models/moeda.dart';

class MoedaDetalhePage extends StatefulWidget {
  Moeda moeda;

  MoedaDetalhePage({super.key, required this.moeda});

  @override
  State<MoedaDetalhePage> createState() => _MoedaDetalhePageState();
}

class _MoedaDetalhePageState extends State<MoedaDetalhePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,

        title: Row(
          spacing: 15,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(widget.moeda.icone),
              ),
            ),
            Text(
              widget.moeda.nome,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(height: 150, child: Image.asset(widget.moeda.icone)),
            ],
          ),
        ],
      ),
    );
  }
}
