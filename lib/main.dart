import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'tela_principal.dart';
import 'conta_modal.dart'; // Importe seu modal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Faz o login anônimo se não houver usuário logado
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

  // Verifica se os dados do usuário já foram preenchidos
  final prefs = await SharedPreferences.getInstance();
  final bool isAccountSetup = prefs.getBool('isAccountSetup') ?? false;

  runApp(MyApp(isAccountSetup: isAccountSetup));
}

class MyApp extends StatelessWidget {
  final bool isAccountSetup;
  const MyApp({super.key, required this.isAccountSetup});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Striped Lists',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // Se a conta não foi configurada, mostra um 'wrapper' que chama o modal
      // Senão, vai direto para a tela principal
      home: isAccountSetup ? const TelaPrincipal() : const AccountSetupWrapper(),
    );
  }
}

// Widget auxiliar para mostrar o modal sobre a tela principal na primeira vez
class AccountSetupWrapper extends StatefulWidget {
  const AccountSetupWrapper({super.key});

  @override
  State<AccountSetupWrapper> createState() => _AccountSetupWrapperState();
}

class _AccountSetupWrapperState extends State<AccountSetupWrapper> {
  @override
  void initState() {
    super.initState();
    // Garante que o modal será exibido assim que a tela for construída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false, // Impede o usuário de fechar sem preencher
        backgroundColor: Colors.transparent,
        builder: (context) => const ContaModal(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mostra a tela principal por baixo enquanto o modal está ativo
    return const TelaPrincipal();
  }
}