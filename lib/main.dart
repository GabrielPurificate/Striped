import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'tela_principal.dart';
import 'conta_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

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
      home: isAccountSetup ? const TelaPrincipal() : const AccountSetupWrapper(),
    );
  }
}

class AccountSetupWrapper extends StatefulWidget {
  const AccountSetupWrapper({super.key});

  @override
  State<AccountSetupWrapper> createState() => _AccountSetupWrapperState();
}

class _AccountSetupWrapperState extends State<AccountSetupWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => const ContaModal(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const TelaPrincipal();
  }
}