import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';

class MoedasPage extends StatelessWidget {
  const MoedasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tabela = MoedaRepository.tabela;

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
                "Cripto Moedas",
              style: TextStyle(
                color: Colors.white
              ),
            )),
        backgroundColor: Colors.red,
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext constext, int moeda){
            return ListTile(
              leading: Image.asset(tabela[moeda].icone),
              title: Row(
                spacing: 10,
                children: [
                  Text(
                    tabela[moeda].sigla,
                    style: TextStyle(
                    fontSize: 10,
                      fontWeight: FontWeight.w300
                    )
                  ),
                  Text(tabela[moeda].nome),
                ],
              ),
              trailing: Text("${tabela[moeda].preco.toString()} R\$"),
            );
          },
          padding: EdgeInsets.all(20.0),
          separatorBuilder: (_, __) => Divider(),
          itemCount: tabela.length),
    );
  }
}
