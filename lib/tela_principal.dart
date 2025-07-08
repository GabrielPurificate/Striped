import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_drawer.dart';
import 'criar_lista_modal.dart';
import 'conta_modal.dart';
import 'tela_detalhes.dart'; // Importe a tela de detalhes

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false;

  // Função para buscar a lista e participar
  Future<void> _participarDaLista() async {
    final codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite um código.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final doc = await FirebaseFirestore.instance.collection('listas').doc(codigo).get();

      if (doc.exists && mounted) {
        // Se a lista foi encontrada, navega para a tela de detalhes
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaDetalhes(listId: codigo)),
        );
      } else if (mounted) {
        // Se a lista não foi encontrada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista não encontrada. Verifique o código.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      // Em caso de erro de rede ou outro problema
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ocorreu um erro ao buscar a lista.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      // Garante que o estado de loading seja desativado ao final
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);

    return Scaffold(
      drawer: const MyDrawer(currentPage: 'Início'),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext builderContext) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () => Scaffold.of(builderContext).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: primaryColor, size: 28),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.7,
                  minChildSize: 0.5,
                  maxChildSize: 0.9,
                  builder: (_, __) => const ContaModal(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('Striped Lists', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              const Text('Deu zebra na lista? A gente organiza!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              const Text('Gerar e compartilhar links para listas nunca foi tão fácil', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codigoController, // Conectado ao controller
                      decoration: InputDecoration(
                        hintText: 'Digite um código ou link',
                        prefixIcon: const Icon(Icons.keyboard_alt_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 2)),
                      ),
                    ),
                  ),
                  // Mostra um indicador de progresso ou o botão
                  _isLoading
                      ? const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: CircularProgressIndicator())
                      : TextButton(
                          onPressed: _participarDaLista, // Chama a função aqui
                          child: const Text('Participar', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                ],
              ),
              const SizedBox(height: 40),
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 20),
              const Text('Criar um link para compartilhar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text('Clique em Nova lista se quiser criar um link para enviar ao grupo', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (_, __) => CriarListaModal(),
              ),
            );
          },
          icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
          label: const Text('Nova lista', style: TextStyle(color: Colors.white, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}