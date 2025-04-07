import 'dart:developer';

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
    pageController = PageController(initialPage: paginaAtual);
  }

  void setAtualPage(int pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("pagina atual: $paginaAtual");
    return Scaffold(
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
          // backgroundColor: Colors.grey[200],
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(
                color: Colors.red[300],
              size: 27
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((state) {
            if (state.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              );
            }
            return TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red[300],
            );
          }),
        ),
        child: NavigationBar(
          backgroundColor: Colors.grey[200],
          animationDuration: Duration(milliseconds: 350),
          indicatorColor: Colors.transparent,
          selectedIndex: paginaAtual,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.list),
              label: "Moedas",
              selectedIcon: Icon(Icons.view_list, color: Colors.red, ),
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border_outlined),
              label: "Favoritos",
              selectedIcon: Icon(Icons.star, color: Colors.red),
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: "Carteira",
              selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.red),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: "Configurações",
              selectedIcon: Icon(Icons.settings, color: Colors.red),
            ),
          ],
          onDestinationSelected: (pagina) {
            pageController.animateToPage(
              pagina,
              duration: Duration(milliseconds: 350),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
