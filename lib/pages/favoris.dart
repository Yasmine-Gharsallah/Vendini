import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the page
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centered horizontally
                children: [
                  // Row for the back arrow
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the left
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(
                              context); // Go back to the previous page
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Centered title
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Mes Favoris',
                      textAlign: TextAlign.center, // Centered
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB50D56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5), // Space between title and image
                  // Centered image
                  Container(
                    width: 250,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/favoris.png.png'), // Added image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Space between image and list
                  // Section for favorite items
                  Container(
                    height: 500, // Height for the favorites section
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
                                'Articles Favoris',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB50D56),
                                ),
                              ),
                              const SizedBox(
                                  height: 16), // Space between title and list
                              // Fetch and display favorite items from Firestore
                              Expanded(
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('favorites')
                                      .doc(user?.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    // Si les données ne sont pas encore disponibles, afficher un indicateur de chargement
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    // Si le document n'existe pas ou n'a pas de données
                                    if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return const Center(
                                          child: Text('Aucun favori trouvé.'));
                                    }

                                    // Vérifier et récupérer la liste de favoris (un tableau d'objets)
                                    List<Map<String, dynamic>> favorites = [];
                                    if (snapshot.data!['favorites'] is List) {
                                      favorites =
                                          List<Map<String, dynamic>>.from(
                                              snapshot.data!['favorites']);
                                    }

                                    // Si 'favorites' est vide ou non disponible, retourner un message
                                    if (favorites.isEmpty) {
                                      return const Center(
                                          child: Text('Aucun favori trouvé.'));
                                    }

                                    // Extraire les IDs des favoris en tant que chaînes
                                    List<String> favoriteIds = favorites
                                        .map((item) =>
                                            item['id']?.toString() ?? '')
                                        .where((id) => id
                                            .isNotEmpty) // On s'assure de ne pas avoir d'ID vide
                                        .toList();

                                    // Si aucun ID n'est disponible, retournez un message d'erreur
                                    if (favoriteIds.isEmpty) {
                                      return const Center(
                                          child: Text(
                                              'Aucun produit favori trouvé.'));
                                    }

                                    // Requête pour récupérer les détails des produits en fonction des IDs
                                    return FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('products')
                                          .where(FieldPath.documentId,
                                              whereIn: favoriteIds)
                                          .get(),
                                      builder: (context, productSnapshot) {
                                        // Si les produits ne sont pas encore récupérés, afficher un indicateur de chargement
                                        if (productSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        // Si aucun produit n'est trouvé, afficher un message
                                        if (!productSnapshot.hasData ||
                                            productSnapshot
                                                .data!.docs.isEmpty) {
                                          return const Center(
                                              child: Text(
                                                  'Aucun produit favori trouvé.'));
                                        }

                                        // Récupérer les informations des produits
                                        final products = productSnapshot
                                            .data!.docs
                                            .map((doc) {
                                          final data = doc.data()
                                              as Map<String, dynamic>;
                                          return {
                                            'id': doc.id,
                                            'label': data['label'] ??
                                                'Produit inconnu',
                                            'price':
                                                data['price']?.toString() ??
                                                    '0',
                                            'imageUrl': data['imageUrl'] ??
                                                'assets/images/default.png',
                                          };
                                        }).toList();

                                        // Afficher les produits dans une liste
                                        return ListView.builder(
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            final product = products[index];
                                            return Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: ListTile(
                                                leading: Image.network(
                                                  product['imageUrl'],
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                                title: Text(product['label']),
                                                subtitle: Text(
                                                    '${product['price']} TND'),
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/productDetail',
                                                    arguments: product,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
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
          ),
        ],
      ),
    );
  }
}
