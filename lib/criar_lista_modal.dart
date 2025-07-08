import 'package:flutter/material.dart';
import 'link_gerado_modal.dart';

class CriarListaModal extends StatefulWidget {
  CriarListaModal({super.key});

  @override
  State<CriarListaModal> createState() => _CriarListaModalState();
}

class _CriarListaModalState extends State<CriarListaModal> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              // ...imagem e close...
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => LinkGeradoModal(
                                  link: 'striped.vercel.app/fxt-tbor-kcw',
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
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
