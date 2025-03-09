import 'package:flutter/material.dart';

import 'pages/home_page.dart';

class MeuAplicativo extends StatelessWidget {
  const MeuAplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moedasbase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Colors.red),
      home: HomePage(),
    );
  }
}
