import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image d'arrière-plan couvrant tout l'écran
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Remplacez par votre image
              fit: BoxFit.cover,
            ),
          ),
          // Contenu principal centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Alignement en haut
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centrage horizontal
              children: [
                // Logo de l'application
                Image.asset(
                  'assets/images/logoVendini.png', // Remplacez par votre logo
                  height: 350,
                ),
                const SizedBox(height: 20), // Espace entre le logo et le bouton

                // Bouton centré
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Navigation vers WelcomeScreen
                    Navigator.pushNamed(context, '/welcome');
                  },
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
