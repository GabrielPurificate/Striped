import 'package:flutter/material.dart';
import 'my_drawer.dart'; // Importa o widget do Drawer

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo a cor principal para reutilização
    const Color primaryColor = Color(0xFF34D399);

    return Scaffold(
      drawer: const MyDrawer(currentPage: 'Início'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // A SOLUÇÃO ESTÁ AQUI: Envolver o IconButton com um Builder
        leading: Builder(
          builder: (BuildContext builderContext) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () {
                // Usamos o novo 'builderContext' que está abaixo do Scaffold
                Scaffold.of(builderContext).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: primaryColor,
              size: 28,
            ),
            onPressed: () {
              // TODO: Implementar a lógica para a tela de perfil
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // O corpo da tela continua o mesmo
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Striped Lists',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deu zebra na lista? A gente organiza!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Gerar e compartilhar links para listas nunca foi tão fácil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Digite um código ou link',
                        prefixIcon: const Icon(Icons.list_alt_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implementar lógica para participar da lista
                    },
                    child: const Text(
                      'Participar',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/logo.png', // Caminho da sua imagem
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                'Criar um link para compartilhar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Clique em Nova lista se quiser criar um link para enviar ao grupo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Implementar navegação para a tela de criação de lista
          },
          icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
          label: const Text(
            'Nova lista',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}