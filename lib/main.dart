import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vendini/pages/connexion.dart';
import 'package:vendini/pages/paiement.dart';
import 'firebase_options.dart'; // Assurez-vous que ce fichier est généré et à jour

import 'package:vendini/pages/splash_screen.dart';
import 'package:vendini/pages/welcome_screen.dart';
import 'package:vendini/pages/threepage.dart';
import 'package:vendini/pages/fourpage.dart';
import 'package:vendini/pages/fivepage.dart';
import 'package:vendini/pages/sixpage.dart';
import 'package:vendini/pages/panier.dart';
import 'package:vendini/pages/post.dart'; // Exemple : ajouter un produit
import 'package:vendini/pages/history.dart'; // Décommentez si cette page est implémentée
import 'package:vendini/pages/infprod.dart'; // Décommentez si cette page est implémentée

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendini',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Page d'accueil initiale
      routes: {
        '/addProduct': (context) =>
            const AddProductPage(), // Route pour ajouter un produit
        '/history': (context) =>
            const HistoryPage(), // Route pour la page historique
        '/cart': (context) => PanierPage(),
        '/infoProduit': (context) => const Infprod(),
        '/welcome': (context) => const WelcomeScreen(),
        '/three': (context) => const ThreePage(),
        '/four': (context) => const FourPage(),
        '/five': (context) => const FivePage(),
        '/six': (context) => const SixPage(),
        '/payement': (context) => const Paiement(),
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFFE6B8AF),
        hintColor: const Color(0xFFA34961),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFFA34961),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
    );
  }
}
