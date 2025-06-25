import 'dart:developer';

import 'package:crypto_quote/configs/const.dart';
import 'package:crypto_quote/pages/favoritos_page.dart';
import 'package:crypto_quote/pages/moedas_page.dart';
import 'package:flutter/material.dart';

import 'carteira_page.dart';
import 'configuracoes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: paginaAtual);
  }

  void setAtualPage(int pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    double navBarheight = 70.0;

    log("pagina atual: $paginaAtual");
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: setAtualPage,
        children: [MoedasPage(), FavoritosPage(), CarteiraPage(), ConfiguracoesPage()],
      ),
      bottomNavigationBar: SafeArea(
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            iconTheme: WidgetStatePropertyAll(IconThemeData(color: Colors.white.withAlpha(220), size: 25)),
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((state) {
              if (state.contains(WidgetState.selected)) {
                return TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Const.tomato);
              }
              return TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withAlpha(220));
            }),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              child: Stack(
                children: [
                  SizedBox(
                    height: navBarheight,
                    child: Stack(
                      children: [
                        Container(color: Const.tomato.withAlpha(230), width: MediaQuery.of(context).size.width),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeOutQuart,
                          height: navBarheight,
                          left:
                              paginaAtual == 0
                                  ? 0
                                  : paginaAtual == 1
                                  ? MediaQuery.of(context).size.width * 0.3105
                                  : MediaQuery.of(context).size.width * 0.619,
                          right:
                              paginaAtual == 0
                                  ? MediaQuery.of(context).size.width * 0.619
                                  : paginaAtual == 1
                                  ? MediaQuery.of(context).size.width * 0.3105
                                  : 0,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(220),
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NavigationBar(
                    height: navBarheight,
                    animationDuration: Duration(milliseconds: 350),
                    indicatorColor: Colors.transparent,
                    selectedIndex: paginaAtual,
                    destinations: [
                      NavigationDestination(
                        icon: Icon(Icons.list),
                        label: "Moedas",
                        selectedIcon: Icon(Icons.view_list, color: Const.tomato, size: 27),
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.star_border_outlined),
                        label: "Favoritos",
                        selectedIcon: Icon(Icons.star, color: Const.tomato, size: 27),
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.account_balance_wallet_outlined),
                        label: "Carteira",
                        selectedIcon: Icon(Icons.account_balance_wallet, color: Const.tomato, size: 27),
                      ),
                      // appbarItem(3, Icons.settings_outlined, Icons.settings, "Configurações"),
                    ],
                    onDestinationSelected: (pagina) {
                      // pageController.jumpToPage(pagina);
                      pageController.animateToPage(pagina, duration: Duration(milliseconds: 350), curve: Curves.easeOutQuart);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
