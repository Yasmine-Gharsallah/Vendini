import 'package:flutter/material.dart';

class FivePage extends StatelessWidget {
  const FivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec dégradé
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/back.png'), // Image d'arrière-plan
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          // Contenu principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Image principale (ordinateur avec sac)
                Image.asset(
                  'assets/images/livraison.png', // Remplacez par votre image
                  height: 200,
                ),
                const SizedBox(height: 30),
                // Titre "Comment Vendre ?"
                const Text(
                  "Livraison ?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB4004E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Description
                const Text(
                  "Livraison pour toute la Tunisie\n et paiement sécurisé garantit !",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffad492b),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Flèche pour naviguer vers la page suivante
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/six'); // Navigation vers SixPage
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
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back to the previous page
              },
              child: Image.asset(
                'assets/images/Home.png', // Path to your home image
                height: 30, // Adjust the height as needed
                width: 30, // Adjust the width as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
