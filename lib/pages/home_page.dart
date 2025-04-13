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

  Widget testeAppBar() {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () => {},
        // _key.currentState?.openDrawer(),
        icon: Icon(Icons.menu_rounded, color: Colors.white),
      ),
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
      actions: [
        // changeLanguageButton(), changeFilterButton(Colors.white)
      ],
    );
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
          backgroundColor: Colors.grey[200],
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: Const.tomato50, size: 25),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Const.tomato50,
            );
          }),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.grey[200],
          animationDuration: Duration(milliseconds: 350),
          indicatorColor: Colors.transparent,
          selectedIndex: paginaAtual,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.list),
              label: "Moedas",
              selectedIcon: Icon(Icons.view_list, color: Const.tomato, size: 30,
              ),
            ),
            NavigationDestination(
              icon: Icon(Icons.star_border_outlined),
              label: "Favoritos",
              selectedIcon: Icon(Icons.star, color: Const.tomato, size: 30),
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: "Carteira",
              selectedIcon: Icon(
                Icons.account_balance_wallet,
                color: Const.tomato,
                size: 30,
              ),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: "Configurações",
              selectedIcon: Icon(Icons.settings, color: Const.tomato, size: 30),
            ),
          ],
          onDestinationSelected: (pagina) {
            pageController.jumpToPage(pagina);
            // pageController.animateToPage(
            //   pagina,
            //   duration: Duration(milliseconds: 200),
            //   curve: Curves.ease,
            // );
          },
        ),
      ),
    );
  }
}
