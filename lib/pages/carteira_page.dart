import 'dart:developer';

import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/models/posicao.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../repositories/conta_repository.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  double totalCarteira = 0;
  double saldo = 0;
  late NumberFormat real;
  late ContaRepository conta;
  String graficoLabel = "";
  double graficoValor = 0;
  List<Posicao> carteira = [];

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);
    saldo = conta.saldo;
    setTotalCarteira();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text("Valor da Carteira", style: TextStyle(fontSize: 18)),
            ),
            Text(
              real.format(totalCarteira),
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            loadGrafico(),
          ],
        ),
      ),
    );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }

  setGraficoDados(int index) {
    if (index < 0) return;

    if (index == carteira.length) {
      graficoLabel = "saldo";
      graficoValor = conta.saldo;
    } else {
      graficoLabel = carteira[index].moeda.nome;
      graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
    }
  }

  loadCarteira(){
    setGraficoDados(index);
    carteira = conta.carteira;
    final tamanhoLista = carteira.length + 1;

    return List.generate(tamanhoLista, (i) {
      final bool isTouched = i == index;
      final bool isSaldo = i == tamanhoLista - 1;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 60 : 50;
      final Color? color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double porcentagem = 0;
      if (!isSaldo) {
        porcentagem = (carteira[i].moeda.preco * carteira[i].quantidade) / totalCarteira;
      } else {
        porcentagem = conta.saldo > 0 ? conta.saldo / totalCarteira : 0;
      }
      porcentagem *= 100;

      return PieChartSectionData(
        color: color,
        value: porcentagem,
        title: "${porcentagem.toStringAsFixed(0)}%",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87
        )
      );

    });
  }

  loadGrafico() {
    return conta.saldo <= 0
        ? Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Center(child: Text("Nada para mostrar")),
        )
        : Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 110,
                  sections: loadCarteira(),
                  pieTouchData: PieTouchData(
                    touchCallback:
                        (p0, p1) => {
                          setState(() {
                            index = p1!.touchedSection!.touchedSectionIndex;
                            setGraficoDados(index);
                          }),
                        },
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  graficoLabel,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal
                  ),
                ),
                Text(
                  real.format(graficoValor),
                  style: TextStyle(fontSize: 28),
                )
              ],
            )
          ],
        );
  }

  loadHistorico(){

  }
}
