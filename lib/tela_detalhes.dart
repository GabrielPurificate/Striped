import 'package:flutter/material.dart';
import 'my_drawer.dart';

class TelaListas extends StatefulWidget {
  const TelaListas({super.key});

  @override
  State<TelaListas> createState() => _TelaListasState();
}

class _TelaListasState extends State<TelaListas>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedOptionIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF34D399);

    return Scaffold(
      backgroundColor: Colors.white,

      // 1. ADICIONADO O DRAWER A ESTA TELA
      drawer: const MyDrawer(currentPage: 'Listas'),

      // 2. APPBAR ATUALIZADO PARA O PADRÃO
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Botão para abrir o menu
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black54),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        // Ações do lado direito (apenas o ícone de perfil)
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
        // Abas (Tabs)
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: primaryColor),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          tabs: const [
            Tab(text: 'Informações'),
            Tab(text: 'Lista'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInformacoesTab(primaryColor),
          _buildListaTab(primaryColor),
        ],
      ),
    );
  }

  Widget _buildInformacoesTab(Color primaryColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lista ônibus 30/06/2025', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Lista de chamada de alunos para ônibus Itaperuna', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
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
            children: [
              _buildOptionCard(icon: Icons.swap_horiz_rounded, text: 'Ida e volta', index: 0, primaryColor: primaryColor),
              _buildOptionCard(icon: Icons.arrow_forward_rounded, text: 'Somente ida', index: 1, primaryColor: primaryColor),
              _buildOptionCard(icon: Icons.arrow_back_rounded, text: 'Somente volta', index: 2, primaryColor: primaryColor),
              _buildOptionCard(icon: Icons.do_not_disturb_on_outlined, text: 'Não vou', index: 3, primaryColor: primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaTab(Color primaryColor) {
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Pesquise participantes',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () { },
                  child: Text('Filtrar', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline_rounded, size: 32, color: Colors.grey[400]),
                  Icon(Icons.list_alt_rounded, size: 24, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Participante(s) não encontrado(s)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Não identificamos nenhum participante, certifique-se de alguém já ter entrado ou verifique o campo de pesquisa', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('0 participantes', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({ required IconData icon, required String text, required int index, required Color primaryColor}) {
    final bool isSelected = _selectedOptionIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOptionIndex = index;
        });
      },
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