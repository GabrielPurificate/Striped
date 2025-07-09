import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TelaDetalhes extends StatefulWidget {
  final String listId;
  const TelaDetalhes({super.key, required this.listId});

  @override
  State<TelaDetalhes> createState() => _TelaDetalhesState();
}

class _TelaDetalhesState extends State<TelaDetalhes>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _opcoes = ['Ida e volta', 'Somente ida', 'Somente volta', 'Não vou'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _salvarParticipacao(String status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final usuarioDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
    final dadosUsuario = usuarioDoc.data();
    if(dadosUsuario == null) return;

    await FirebaseFirestore.instance.collection('listas').doc(widget.listId).update({
      'participantes.${user.uid}': {
        'nome': dadosUsuario['nome'],
        'faculdade': dadosUsuario['faculdade'],
        'status': status,
        'uid': user.uid,
      },
      'membros': FieldValue.arrayUnion([user.uid]),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sua presença foi confirmada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('listas').doc(widget.listId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('Lista não encontrada.')));
        }

        final listaData = snapshot.data!.data() as Map<String, dynamic>;
        final participantes = listaData['participantes'] as Map<String, dynamic>? ?? {};
        
        String? statusAtual = participantes[userId]?['status'];
        int selectedIndex = statusAtual != null ? _opcoes.indexOf(statusAtual) : -1;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: Text(
              listaData['titulo'] ?? 'Detalhes da Lista',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: primaryColor),
                insets: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              tabs: const [Tab(text: 'Informações'), Tab(text: 'Lista')],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildInformacoesTab(primaryColor, listaData, selectedIndex),
              _buildListaTab(primaryColor, participantes),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInformacoesTab(Color primaryColor, Map<String, dynamic> listaData, int selectedIndex) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(listaData['titulo'] ?? 'Carregando...', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(listaData['descricao'] ?? '', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 32),
          const Text('Selecione sua opção:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: List.generate(_opcoes.length, (index) {
              final icons = [Icons.swap_horiz_rounded, Icons.arrow_forward_rounded, Icons.arrow_back_rounded, Icons.do_not_disturb_on_outlined];
              return _buildOptionCard(
                icon: icons[index],
                text: _opcoes[index],
                isSelected: selectedIndex == index,
                onTap: () {
                  _salvarParticipacao(_opcoes[index]);
                },
                primaryColor: primaryColor,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildListaTab(Color primaryColor, Map<String, dynamic> participantes) {
    final listaDeParticipantes = participantes.values.toList();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (listaDeParticipantes.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline_rounded, size: 32, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    const Text('Nenhum participante ainda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: listaDeParticipantes.length,
                  itemBuilder: (context, index) {
                    final participante = listaDeParticipantes[index];
                    return ListTile(
                      title: Text(participante['nome'] ?? 'Nome não encontrado'),
                      subtitle: Text(participante['status'] ?? ''),
                      trailing: Text(participante['faculdade'] ?? ''),
                    );
                  },
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('${listaDeParticipantes.length} participantes', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: isSelected ? primaryColor : Colors.grey[700]),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(fontWeight: FontWeight.w500, color: isSelected ? primaryColor : Colors.grey[800])),
          ],
        ),
      ),
    );
  }
}