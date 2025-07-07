import 'package:flutter/material.dart';
import 'tela_historico.dart'; // Importa a tela de histórico
import 'tela_principal.dart'; // Importa a tela principal

class MyDrawer extends StatelessWidget {
  // Parâmetro para saber qual é a página atual
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
          // ... (O cabeçalho continua o mesmo)
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

          // NOVO ITEM "INÍCIO"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Início'),
              selected: currentPage == 'Início', // Selecionado na tela principal
              selectedTileColor: primaryColor.withOpacity(0.2),
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                // Navega para a Tela Principal
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TelaPrincipal()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ITEM "LISTAS" PREPARADO PARA O FUTURO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListTile(
              leading: const Icon(Icons.list_alt_rounded),
              title: const Text('Listas'),
              selected: currentPage == 'Listas', // Será usado quando a tela for criada
              selectedTileColor: primaryColor.withOpacity(0.2),
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                // TODO: Criar e navegar para a TelaDeListas()
                // Por enquanto, apenas fecha o menu
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 8),

          // ITEM "HISTÓRICO" (sem alterações na lógica)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico'),
              selected: currentPage == 'Historico',
              selectedTileColor: primaryColor.withOpacity(0.2),
              selectedColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const TelaHistorico()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}