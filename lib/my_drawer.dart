import 'package:flutter/material.dart';
import 'tela_listas.dart';
import 'tela_principal.dart';

class MyDrawer extends StatelessWidget {

  final String currentPage;

  const MyDrawer({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 10, 20),
            child: Row(
              children: [
                Image.asset('assets/minilogo.png', width: 24, height: 24),
                const SizedBox(width: 12),
                const Text('Striped Lists', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Início'),
              selected: currentPage == 'Início',
              selectedTileColor: primaryColor.withOpacity(0.2),
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TelaPrincipal()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Listas'),
              selected: currentPage == 'Listas',
              selectedTileColor: primaryColor.withOpacity(0.2),
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TelaListas()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}