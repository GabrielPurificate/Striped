import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tela_principal.dart';

class ContaModal extends StatefulWidget {
  const ContaModal({super.key});

  @override
  State<ContaModal> createState() => _ContaModalState();
}

class _ContaModalState extends State<ContaModal> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  String? faculdadeSelecionada;
  bool _isLoading = true; // Inicia como true para mostrar o loading inicial
  bool _isSaving = false; // Novo estado para o botão de salvar

  final List<String> faculdades = [
    'Faculdade',
    'IFF',
    'UNIG',
    'UniRedentor',
    'São José',
    'Outro',
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();
        if (mounted && doc.exists && doc.data() != null) {
          final data = doc.data()!;
          setState(() {
            nomeController.text = data['nome'] ?? '';
            sobrenomeController.text = data['sobrenome'] ?? '';
            if (faculdades.contains(data['faculdade'])) {
              faculdadeSelecionada = data['faculdade'];
            }
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao carregar dados: ${e.toString()}')),
          );
        }
      }
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _salvarConta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não encontrado. Tente reiniciar o app.");
      }

      // Salva nome e sobrenome em campos separados
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
        'nome': nomeController.text.trim(),
        'sobrenome': sobrenomeController.text.trim(),
        'faculdade': faculdadeSelecionada,
        'uid': user.uid,
      }, SetOptions(merge: true)); // Usa merge para criar ou atualizar

      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = !prefs.containsKey('isAccountSetup');
      await prefs.setBool('isAccountSetup', true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso!'), backgroundColor: Colors.green),
        );
        
        if (isFirstTime) {
           Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const TelaPrincipal()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar dados: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/zebra_conta.png',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 16,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.close, color: Colors.black54),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                           Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        top: 0,
                        bottom: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 24),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sua conta',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    key: const Key('nomeField'),
                                    controller: nomeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome',
                                      border: UnderlineInputBorder(),
                                    ),
                                    autofillHints: const [AutofillHints.givenName],
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Preencha o nome';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    key: const Key('sobrenomeField'),
                                    controller: sobrenomeController,
                                    decoration: const InputDecoration(
                                      labelText: 'Sobrenome',
                                      border: UnderlineInputBorder(),
                                    ),
                                    autofillHints: const [AutofillHints.familyName],
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Preencha o sobrenome';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: faculdadeSelecionada,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  hintText: 'Faculdade',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                                items: faculdades.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value == 'Faculdade' ? null : value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    faculdadeSelecionada = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Selecione a faculdade';
                                  }
                                  return null;
                                },
                                hint: const Text('Faculdade'),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FloatingActionButton(
                                backgroundColor: const Color(0xFF34D399),
                                mini: false,
                                onPressed: _isSaving ? null : _salvarConta,
                                child: _isSaving
                                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                                    : const Icon(Icons.save_alt, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}