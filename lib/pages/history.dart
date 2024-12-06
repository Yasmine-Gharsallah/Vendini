import 'dart:ui';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste simulée des achats pour l'exemple
    final List<Map<String, String>> purchases = [
      {
        'item': 'Pyjama',
        'price': '30 TND',
        'date': '28/11/2024',
        'image': 'assets/images/4.png'
      },
      {
        'item': 'Manteau',
        'price': '50 TND',
        'date': '25/11/2024',
        'image': 'assets/images/5.png'
      },
    ];

    final List<Map<String, String>> sales = [
      {
        'item': 'Armoire',
        'price': '200 TND',
        'date': '22/11/2024',
        'image': 'assets/images/7.png'
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background.png'), // Image de fond
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu de la page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centré horizontalement
              children: [
                // Row pour la flèche à gauche
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Aligner à gauche
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Retour à la page précédente
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Titre centré
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Historique Achat et Vente',
                    textAlign: TextAlign.center, // Centré
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB50D56),
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Espace entre le titre et l'image
                // Image Hist.png petite et centrée
                Container(
                  width: 120, // Largeur réduite pour l'image
                  height: 120, // Hauteur réduite pour l'image
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/Hist.png'), // Image ajoutée
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Espace entre l'image et la liste
                // Première partie floue pour les achats (réduite en taille)
                Container(
                  height: 250, // Hauteur réduite pour la section des achats
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vos Achats',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB50D56),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Liste des achats avec images, prix et date
                            Expanded(
                              child: ListView.builder(
                                itemCount: purchases.length,
                                itemBuilder: (context, index) {
                                  final purchase = purchases[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          purchase['image']!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(purchase['item']!),
                                      subtitle: Text(
                                        'Date: ${purchase['date']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: Text(
                                        purchase['price']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Deuxième partie floue pour les ventes (réduite en taille)
                Container(
                  height: 250, // Hauteur réduite pour la section des ventes
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vos Ventes',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB50D56),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Liste des ventes avec "Vendu"
                            Expanded(
                              child: ListView.builder(
                                itemCount: sales.length,
                                itemBuilder: (context, index) {
                                  final sale = sales[index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          sale['image']!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(sale['item']!),
                                      subtitle: Text(
                                        'Date: ${sale['date']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: Stack(
                                        children: [
                                          Text(
                                            sale['price']!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              color: Colors.red,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: const Text(
                                                'Vendu',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
