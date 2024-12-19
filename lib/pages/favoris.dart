import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenir l'utilisateur actuel
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: const Color(0xFFFCDFDB),
      ),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre centré
                  const Text(
                    'Mes Favoris',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB50D56),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Liste des favoris
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('favorites')
                        .doc(user?.uid) // Document de favoris de l'utilisateur
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                            child: Text('Aucun favori trouvé.'));
                      }

                      // Extraire la liste des favoris
                      List<dynamic> favorites =
                          snapshot.data!['favorites'] ?? [];

                      if (favorites.isEmpty) {
                        return const Center(
                            child: Text('Aucun favori trouvé.'));
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          final favorite = favorites[index];
                          final productName = favorite['name'] ?? 'Nom inconnu';
                          final productPrice =
                              favorite['price'] ?? 'Prix inconnu';
                          final productImage =
                              favorite['image'] ?? 'assets/images/default.png';

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image du produit
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  child: Image.asset(
                                    productImage,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Nom et prix
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  productPrice,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
