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

  Widget navbarItem(int atualPage, IconData icon, IconData selectedIcon, String label){
    bool activate = paginaAtual == atualPage;
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: 60,
          top: activate ? 1 : 60,
          left: MediaQuery.of(context).size.width * 0.042,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
              ),
            ),
          ),
        ),
        NavigationDestination(
          icon: Icon(icon),
          label: label,
          selectedIcon: Icon(
            selectedIcon,
            color: Const.tomato,
            size: 27,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    log("pagina atual: $paginaAtual");
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: setAtualPage,
        children: [
          MoedasPage(),
          FavoritosPage(),
          CarteiraPage(),
          ConfiguracoesPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Const.tomato,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: Colors.white.withAlpha(220), size: 25),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((state) {
            if (state.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Const.tomato,
              );
            }
            return TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withAlpha(220),
            );
          }),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          child: NavigationBar(
            height: 60,
            animationDuration: Duration(milliseconds: 350),
            indicatorColor: Colors.transparent,
            selectedIndex: paginaAtual,
            destinations: [
              navbarItem(0, Icons.list, Icons.view_list, "Moedas"),
              navbarItem(1, Icons.star_border_outlined, Icons.star, "Favoritos"),
              navbarItem(2, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, "Carteira"),
              // appbarItem(3, Icons.settings_outlined, Icons.settings, "Configurações"),
            ],
            onDestinationSelected: (pagina) {
              // pageController.jumpToPage(pagina);
              pageController.animateToPage(
                pagina,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOutQuad,
              );
            },
          ),
        ),
      ),
    );
  }
}
