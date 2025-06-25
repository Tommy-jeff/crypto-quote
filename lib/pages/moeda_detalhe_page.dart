import 'package:crypto_quote/components/full_button_component.dart';
import 'package:crypto_quote/components/full_textformfield_component.dart';
import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/configs/const.dart';
import 'package:crypto_quote/repositories/conta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/moeda.dart';

class MoedaDetalhePage extends StatefulWidget {
  final Moeda moeda;

  const MoedaDetalhePage({super.key, required this.moeda});

  @override
  State<MoedaDetalhePage> createState() => _MoedaDetalhePageState();
}

class _MoedaDetalhePageState extends State<MoedaDetalhePage> {
  late NumberFormat real;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _valor = TextEditingController();
  double crypto = 0;
  late ContaRepository contaRepository;

  executeCompraRepo() async {
    await contaRepository.comprar(widget.moeda, double.parse(_valor.text));
  }

  comprar() {
    if (_form.currentState!.validate()) {
      executeCompraRepo();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Const.tomato,
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text("Compra realizada com sucesso!", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);
    contaRepository = Provider.of<ContaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(widget.moeda.nome, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: Const.tomato,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 50, child: Image.asset(widget.moeda.icone)),
                      Text(
                        real.format(widget.moeda.preco),
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: -1, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _form,
                  child: FullTextformfieldComponent(
                    valor: _valor,
                    label: 'Valor',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                    inputFormater: [FilteringTextInputFormatter.digitsOnly],
                    textInputType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        crypto = (value.isEmpty) ? 0 : double.parse(value) / widget.moeda.preco;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Informe o valor da compra!';
                      } else if (double.parse(value) < 50) {
                        return 'Compra mínima é R\$ 50,00';
                      } else if (double.parse(value) > contaRepository.saldo) {
                        return 'Saldo insuficiente';
                      }
                      return null;
                    },
                  ),
                ),
                Visibility(
                  visible: crypto > 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.teal.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20)),
                      child: Text('$crypto ${widget.moeda.sigla}', style: TextStyle(fontSize: 20, color: Colors.teal)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 24.0),
                  child: FullButtonComponent(
                    icon: Icon(Icons.attach_money, color: Colors.white, size: 30),
                    label: "Comprar",
                    onPressed: comprar,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
