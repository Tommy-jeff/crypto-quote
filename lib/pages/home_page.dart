import 'package:crypto_quote/pages/favoritos_page.dart';
import 'package:crypto_quote/pages/moedas_page.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: setAtualPage,
        children: [
          MoedasPage(),
          FavoritosPage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.red,
          indicatorColor: Colors.transparent,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: Colors.white60),
          ),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        child: NavigationBar(
          animationDuration: Duration(milliseconds: 400),
          indicatorColor: Colors.transparent,
          selectedIndex: paginaAtual,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.list),
              label: "Moedas",
              selectedIcon: Icon(Icons.list, color: Colors.white),
            ),
            NavigationDestination(
              icon: Icon(Icons.star),
              label: "Favoritos",
              selectedIcon: Icon(Icons.star, color: Colors.white),
            ),
          ],
          onDestinationSelected: (pagina) {
            pageController.animateToPage(
              pagina,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
