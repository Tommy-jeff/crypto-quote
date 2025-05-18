import 'dart:developer';
import 'dart:ui';

import 'package:crypto_quote/components/coin_card.dart';
import 'package:crypto_quote/configs/app_settings.dart';
import 'package:crypto_quote/configs/const.dart';
import 'package:crypto_quote/models/moeda.dart';
import 'package:crypto_quote/pages/moeda_detalhe_page.dart';
import 'package:crypto_quote/repositories/favoritos_repository.dart';
import 'package:crypto_quote/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> with TickerProviderStateMixin {
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  List<Moeda> coins = [];
  late MoedaRepository moedaRepo;
  bool showFAB = true;
  late FavoritosRepository favoritosRepository;
  final _key = GlobalKey<ScaffoldState>();

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc["locale"], name: loc["name"]);
  }

  changeLanguageButton() {
    final locale = loc["locale"] == "pt_BR" ? "es_US" : "pt_BR";
    final name = loc["name"] == "R\$" ? "\$" : "R\$";

    return PopupMenuButton(
      icon: Icon(Icons.language, color: Colors.white),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.monetization_on_outlined),
                title: Text("Usar: $locale"),
                onTap: () {
                  context.read<AppSettings>().setLocale(locale, name);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
    );
  }

  changeFilterButton(Color color) {
    int nameFilterAplyied = 0;
    int valueFilterAplyied = 0;
    return PopupMenuButton(
      icon: Icon(Icons.filter_list, color: color),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              onTap:
                  () => {
                    if (nameFilterAplyied != 1)
                      {moedaRepo.sort(1), nameFilterAplyied = 1}
                    else if (nameFilterAplyied == 1)
                      {moedaRepo.sort(2), nameFilterAplyied = 2},
                  },
              child: ListTile(
                title: Text("A a Z"),
                trailing:
                    nameFilterAplyied == 1
                        ? Icon(Icons.arrow_upward_outlined)
                        : nameFilterAplyied == 2
                        ? Icon(Icons.arrow_downward_outlined)
                        : null,
              ),
            ),
            PopupMenuItem(
              onTap:
                  () => {
                    if (valueFilterAplyied != 3)
                      {moedaRepo.sort(3), valueFilterAplyied = 3}
                    else if (valueFilterAplyied == 3)
                      {moedaRepo.sort(4), valueFilterAplyied = 4},
                  },
              child: ListTile(
                title: Text("Preço"),
                trailing:
                    valueFilterAplyied == 3
                        ? Icon(Icons.arrow_upward_outlined)
                        : valueFilterAplyied == 4
                        ? Icon(Icons.arrow_downward_outlined)
                        : null,
              ),
            ),
          ],
    );
  }

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..forward();

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  @override
  void initState() {
    moedaRepo = MoedaRepository();
    getCoins();
    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    // _animation.dispose();
    super.dispose();
  }

  getCoins() async {
    List coinsDb = await moedaRepo.getCoins();
    for (Moeda item in coinsDb) {
      var dup = coins.where((t) => t.sigla == item.sigla);
      var fav = coins.where((f) => f.sigla == item.sigla && f.favorito != item.favorito);

      if(dup.isEmpty) {
        coins.add(item);
      }
      if (fav.isNotEmpty) {
        log("teste fav: ${fav.first.sigla}");
        int index = coins.indexWhere((i) => i.sigla == item.sigla);
        coins[index].favorito = 1;

        // coins.removeWhere((i) => i.sigla == item.sigla);
        // coins.insert(index, item);
      }
    }
  }

  shouldUpdateCoin() async {

  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return SliverAppBar(
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        snap: true,
        floating: true,
        centerTitle: true,
        title: Text("Criptos", style: TextStyle(color: Colors.white)),
        backgroundColor: Const.tomato,
        actions: [changeLanguageButton(), changeFilterButton(Colors.white)],
      );
    } else {
      return SliverAppBar(
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        snap: true,
        floating: true,
        centerTitle: true,
        title: Text(
          "${selecionadas.length} itens selecionados",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        actions: [changeFilterButton(Colors.black87)],
        leading: IconButton(
          onPressed: () {
            limparSelecionadas();
          },
          icon: Icon(
            Icons.arrow_back,
            // color: Colors.white
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // favoritosRepository = Provider.of<FavoritosRepository>(context);
    favoritosRepository = context.watch<FavoritosRepository>();
    moedaRepo = context.watch<MoedaRepository>();
    readNumberFormat();
    getCoins();

    return NestedScrollView(
      headerSliverBuilder: (__, context) => [appBarDinamica()],
      floatHeaderSlivers: true,
      body: Scaffold(
        key: _key,
        body: AnimatedBuilder(
          animation: moedaRepo,
          builder: (context, child) {
            // List<Moeda> tabela = MoedaRepository.tabela;
            return (coins.isEmpty)
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
                  child: Container(
                    color: Colors.red.withAlpha(10),
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: ListView.builder(
                      itemCount: coins.length,
                      itemBuilder: (context, index) {
                        Moeda moedaIndex = coins[index];
                        return CoinCard(
                          moeda: moedaIndex,
                          selecionadas: selecionadas,
                          onLongPress: (moeda) {
                            setState(() {
                              selecionadas.contains(moeda)
                                  ? selecionadas.remove(moeda)
                                  : selecionadas.add(moeda);
                            });
                          },
                        );
                        // coin(tabela[index]);
                      },
                    ),
                  ),
                );
          },
        ),
        floatingActionButton:
            selecionadas.isNotEmpty
                ? Padding(
                  padding: MediaQuery.of(context).padding,
                  child: ScaleTransition(
                    scale: _animation,
                    child: FloatingActionButton(
                      onPressed: () {
                        // favoritosRepository.alterFav(selecionadas);
                        moedaRepo.favoriteCoin(selecionadas);
                        limparSelecionadas();
                      },
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      backgroundColor: Const.golden,
                      child: Icon(Icons.star, color: Colors.white),
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
