import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Image d'arrière-plan
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                // Image principale
                Image.asset(
                  'assets/images/bienv.png', // Image principale
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                // Texte de bienvenue
                const Text(
                  "Bienvenue Sur Vendini",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffad492b),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Découvrez notre application de commerce d'articles occasion à prix réduits. "
                    "Achetez et vendez avec notre communauté Vendini.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8B1A2E),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                    height: 100), // Ajoute un espace pour le défilement
              ],
            ),
          ),
          // Flèche de navigation en bas
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, '/three'); // Navigation vers ThreePage
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFB4004E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          // Bouton d'accueil en bas à gauche
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Image.asset(
                'assets/images/Home.png', // Chemin de l'image
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
