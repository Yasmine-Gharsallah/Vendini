import 'package:flutter/material.dart';
import 'package:vendini/pages/connexion.dart'; // Assurez-vous d'importer la page de connexion
import 'package:vendini/pages/inscription.dart'; // Assurez-vous d'importer la page d'inscription

class SixPage extends StatelessWidget {
  const SixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond d'écran avec une image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background.png'), // Image de fond
                fit: BoxFit.cover, // Adapter l'image à la taille de l'écran
              ),
            ),
          ),
          // Contenu principal
          Column(
            children: [
              const SizedBox(height: 50), // Espace avant le titre
              // Ligne pour centrer le logo et le titre
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer le contenu
                children: [
                  // Logo centré
                  Padding(
                    padding: const EdgeInsets.all(
                        10), // Ajoute un petit padding autour du logo
                    child: Image.asset(
                      'assets/images/logoVendini.png', // Chemin de votre logo
                      height: 160, // Taille ajustée du logo (plus grand)
                      width: 160, // Largeur ajustée
                      fit: BoxFit.contain, // Ajuste l'image sans la déformer
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 50), // Espace sous le logo pour centrer le titre
              // Titre centré
              const Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20), // Espacement latéral
                child: Text(
                  "Inscription à Vendini",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A1D2E), // Rouge foncé
                    letterSpacing: 1.5,
                    fontFamily:
                        'ElegantFont', // Remplacez par une police personnalisée
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacement sous le titre

              // Sous-titre
              const Text(
                "Connectez-vous avec votre adresse mail électronique.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8A1D2E), // Rouge foncé
                ),
              ),
              const SizedBox(height: 40), // Espace avant les boutons

              // Boutons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B2A2A), // Rouge foncé
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black.withOpacity(0.3),
                  elevation: 5,
                ),
                onPressed: () {
                  // Naviguer vers la page de connexion
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                  );
                },
                child: const Text(
                  'Connexion avec Gmail',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espacement entre les boutons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9B2A2A), // Rouge foncé
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black.withOpacity(0.3),
                  elevation: 5,
                ),
                onPressed: () {
                  // Naviguer vers la page d'inscription
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  InscriptionPage()),
                  );
                },
                child: Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Bouton "Home" en bas à gauche
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Image.asset(
                'assets/images/Home.png', // Chemin de votre icône "Home"
                height: 30, // Taille ajustée
                width: 30, // Taille ajustée
              ),
            ),
          ),
        ],
      ),
    );
  }
}
