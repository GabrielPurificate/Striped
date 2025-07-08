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
  bool _isLoading = false; // Para controlar o estado de loading do botão

  final List<String> faculdades = [
    'Faculdade',
    'IFF',
    'UNIG',
    'UniRedentor',
    'São José',
    'Outro',
  ];

  final _formKey = GlobalKey<FormState>();

  // Função para salvar os dados
  Future<void> _salvarConta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Pega o usuário anônimo que já foi logado no main.dart
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não encontrado. Tente reiniciar o app.");
      }

      final nomeCompleto = '${nomeController.text.trim()} ${sobrenomeController.text.trim()}';

      // 2. Salva os dados no Firestore, na coleção 'usuarios', usando o uid como ID
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).set({
        'nome': nomeCompleto,
        'faculdade': faculdadeSelecionada,
        'uid': user.uid,
      });

      // 3. Salva no celular que a configuração da conta foi concluída
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAccountSetup', true);

      // 4. Navega para a TelaPrincipal e remove todas as telas anteriores da pilha
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const TelaPrincipal()),
          (Route<dynamic> route) => false,
        );
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
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // O build do seu widget continua praticamente o mesmo
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          // ... (O resto do seu código de UI continua aqui)
          // A única mudança é no botão de salvar:
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
                          // O usuário não deve poder fechar este modal
                          // A navegação só acontece após salvar
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
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
                          onPressed: _isLoading ? null : _salvarConta,
                          child: _isLoading
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