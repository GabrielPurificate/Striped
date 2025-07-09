import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'link_gerado_modal.dart';

class CriarListaModal extends StatefulWidget {
  const CriarListaModal({super.key});

  @override
  State<CriarListaModal> createState() => _CriarListaModalState();
}

class _CriarListaModalState extends State<CriarListaModal> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _criarLista() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não autenticado.");
      }
      
      String codigoLista;
      DocumentSnapshot snapshot;
      do {
        codigoLista = '${randomAlpha(3)}-${randomAlpha(4)}-${randomAlpha(3)}'.toLowerCase();
        snapshot = await FirebaseFirestore.instance.collection('listas').doc(codigoLista).get();
      } while (snapshot.exists);

      final dadosDaLista = {
        'titulo': tituloController.text,
        'descricao': descricaoController.text,
        'codigo': codigoLista,
        'criadorId': user.uid,
        'criadoEm': FieldValue.serverTimestamp(),
        'participantes': {},
        'membros': [user.uid],
      };

      await FirebaseFirestore.instance.collection('listas').doc(codigoLista).set(dadosDaLista);

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => LinkGeradoModal(
            link: codigoLista,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar lista: ${e.toString()}')),
        );
      }
    } finally {
      if(mounted) {
        setState(() {
          _isLoading = false;
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
                      'assets/zebra_criar_lista.png',
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
                        onPressed: () => Navigator.of(context).pop(),
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
                          'Criar lista',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        key: const Key('tituloListaField'),
                        controller: tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título da lista',
                          border: UnderlineInputBorder(),
                        ),
                        autofillHints: const [AutofillHints.name],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Preencha o título da lista';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição da lista (opcional)',
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xFF34D399),
                          mini: false,
                          onPressed: _isLoading ? null : _criarLista,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                              : const Icon(Icons.arrow_forward, color: Colors.white),
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