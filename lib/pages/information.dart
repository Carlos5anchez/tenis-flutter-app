import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tenis/views/info_tab.dart';
import 'package:flutter_tenis/views/noticias_tab.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mantente Informado"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Información"),
              Tab(text: "Noticias"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InformacionTab(),
            NoticiasTab(),
          ],
        ),
      ),
    );
  }
}
