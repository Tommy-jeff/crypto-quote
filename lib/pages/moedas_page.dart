import 'dart:developer';

import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/pages/moeda_detalhe_page.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> with TickerProviderStateMixin {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> selecionadas = [];
  late MoedaRepository moedaRepo;
  bool showFAB = true;
  late FavoritosRepository favoritosRepository;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..forward();

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    _animation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    moedaRepo = MoedaRepository();
    super.initState();
  }

  limparSelecionadas() {
    setState(() {
     selecionadas = [];
    });
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return SliverAppBar(
        snap: true,
        floating: true,
        centerTitle: true,
        title: Text("Cripto Moedas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () => moedaRepo.sort(),
            icon: const Icon(Icons.swap_vert),
            color: Colors.white,
          ),
        ],
      );
    } else {
      return SliverAppBar(
        snap: true,
        floating: true,
        centerTitle: true,
        title: Text(
          "${selecionadas.length} itens selecionados",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () => moedaRepo.sort(),
            icon: const Icon(Icons.swap_vert),
            // color: Colors.white,
          ),
        ],
        leading: IconButton(
          onPressed: () {limparSelecionadas();},
          icon: Icon(
            Icons.arrow_back,
            // color: Colors.white
          ),
        ),
      );
    }
  }

  moestrarDetalhes(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MoedaDetalhePage(moeda: moeda)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // favoritosRepository = Provider.of<FavoritosRepository>(context);
    favoritosRepository = context.watch<FavoritosRepository>();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, __) => [appBarDinamica()],
        floatHeaderSlivers: true,
        body: AnimatedBuilder(
          animation: moedaRepo,
          builder: (context, child) {
            List tabela = moedaRepo.tabela;
            return (tabela.isEmpty)
                ? const Material()
                : NotificationListener<UserScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.direction == ScrollDirection.reverse &&
                        showFAB) {
                      _controller.reverse();
                      showFAB = false;
                    } else if (scroll.direction == ScrollDirection.forward &&
                        !showFAB) {
                      _controller.forward();
                      showFAB = true;
                    }
                    return true;
                  },
                  child: ListView.separated(
                    itemBuilder: (BuildContext constext, int moeda) {
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        leading:
                            selecionadas.contains(tabela[moeda])
                                ? Icon(
                                  Icons.check_circle,
                                  size: 35.0,
                                  color: Colors.black87,
                                )
                                : SizedBox(
                                  width: 35.0,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(tabela[moeda].icone),
                                    ),
                                  ),
                                ),
                        title: Row(
                          spacing: 10,
                          children: [
                            Text(
                              tabela[moeda].sigla,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              tabela[moeda].nome,
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if(favoritosRepository.listaFavoritos.contains(tabela[moeda]))
                              Icon(Icons.star, color: Colors.amber, size: 20),
                          ],
                        ),
                        trailing: Text(real.format(tabela[moeda].preco)),
                        selected: selecionadas.contains(tabela[moeda]),
                        selectedTileColor: Colors.blueGrey[50],
                        onLongPress: () {
                          setState(() {
                            selecionadas.contains(tabela[moeda])
                                ? selecionadas.remove(tabela[moeda])
                                : selecionadas.add(tabela[moeda]);
                          });
                        },
                        onTap: () => moestrarDetalhes(tabela[moeda]),
                      );
                    },
                    padding: EdgeInsets.all(15.0),
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: tabela.length,
                  ),
                );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          selecionadas.isNotEmpty
              ? ScaleTransition(
                scale: _animation,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    favoritosRepository.alterFav(selecionadas);
                    limparSelecionadas();
                  },
                  icon: Icon(Icons.star, color: Colors.white),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  backgroundColor: Colors.redAccent,
                  label: Text(
                    "FAVORITAR",
                    style: TextStyle(
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              : null,
    );
  }
}
