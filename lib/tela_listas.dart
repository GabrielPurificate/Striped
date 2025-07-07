import 'package:flutter/material.dart';
import 'my_drawer.dart'; // Importe o Drawer para reutilizar

class TelaListas extends StatefulWidget {
  const TelaListas({super.key});

  @override
  State<TelaListas> createState() => _TelaListasState();
}

class _TelaListasState extends State<TelaListas> {
  // TODO: Futuramente, você irá carregar as listas do banco de dados aqui
  // e armazená-las em uma variável de estado, por exemplo:
  // List<MinhaLista> _listas = [];
  // bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);

    return Scaffold(
      // Reutilizamos o mesmo Drawer da tela principal
      drawer: const MyDrawer(currentPage: 'Listas'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // Botão para abrir o menu lateral (Drawer)
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        // Ícone de perfil
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: primaryColor,
              size: 28,
            ),
            onPressed: () {
              // TODO: Lógica para a tela de perfil
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            // Campo de pesquisa
            TextField(
              decoration: InputDecoration(
                hintText: 'Pesquise as listas ou busque pelo link',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                // TODO: Implementar a lógica de filtro da lista
              },
            ),

            // O conteúdo da tela mudará com base no estado (se há listas ou não)
            // Usamos um Expanded para que o conteúdo ocupe o espaço restante
            Expanded(
              child: Center(
                // TODO: Aqui você adicionará uma condição.
                // Se a lista estiver vazia, mostre a mensagem abaixo.
                // Se não, mostre um ListView.builder com as listas.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Lista(s) não encontrada(s)',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Não identificamos nenhuma lista, certifique-se\nde já ter adicionado uma nova lista ou verifique\no campo de pesquisa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}