import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_drawer.dart';
import 'tela_detalhes.dart'; // Importe a tela de detalhes

class TelaListas extends StatelessWidget {
  const TelaListas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(currentPage: 'Listas'),
      appBar: AppBar(
        // ... (seu AppBar continua o mesmo)
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF34D399), size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Campo de pesquisa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquise as listas ou busque pelo link',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                // TODO: Implementar a lógica de filtro
              },
            ),
          ),

          // StreamBuilder para ouvir e construir a lista de cards
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
            // MUDE A PROPRIEDADE 'stream' PARA ISTO:
              stream: FirebaseFirestore.instance
                .collection('listas')
                // AQUI ESTÁ A MUDANÇA: "busque apenas as listas onde o array 'membros' contém o ID do usuário atual"
                .where('membros', arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .orderBy('criadoEm', descending: true)
                .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar as listas.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhuma lista encontrada.'));
                }

                final listas = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: listas.length,
                  itemBuilder: (context, index) {
                    final listaData = listas[index].data() as Map<String, dynamic>;
                    final listaId = listas[index].id;
                    return _ListaCard(listaData: listaData, listaId: listaId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET CUSTOMIZADO PARA O CARD DA LISTA, SEGUINDO O SEU DESIGN
class _ListaCard extends StatelessWidget {
  final Map<String, dynamic> listaData;
  final String listaId;

  const _ListaCard({required this.listaData, required this.listaId});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);
    
    // Pega os dados do mapa, com valores padrão para segurança
    final titulo = listaData['titulo'] ?? 'Título indisponível';
    final descricao = listaData['descricao'] ?? '';
    final codigo = listaData['codigo'] ?? 'código-indisponível';
    final participantes = listaData['participantes'] as Map<String, dynamic>? ?? {};
    final numeroParticipantes = participantes.length;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Descrição
            Text(
              descricao,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Link
            Row(
              children: [
                Icon(Icons.tag, size: 16, color: Colors.grey[600]), // Ícone de tag
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    // ANTES: 'striped.vercel.app/$codigo',
                    // AGORA:
                    codigo, // Mostrando apenas o código
                    style: TextStyle(fontSize: 14, color: Colors.grey[800], letterSpacing: 1.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Botão e contagem de participantes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaDetalhes(listId: listaId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text('Ver lista'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.people_outline_rounded, color: Colors.grey[700]),
                    const SizedBox(width: 8),
                    Text(
                      '$numeroParticipantes participantes',
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}