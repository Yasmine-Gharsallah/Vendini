import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  // Function to add a favorite item to Firestore
  Future<void> addFavorite(String userId, Map<String, dynamic> favoriteItem) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').doc(userId).set({
        'favorites': FieldValue.arrayUnion([favoriteItem])
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  // Function to remove a favorite item from Firestore
  Future<void> removeFavorite(String userId, Map<String, dynamic> favoriteItem) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').doc(userId).update({
        'favorites': FieldValue.arrayRemove([favoriteItem])
      });
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

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
                image: AssetImage('assets/images/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content of the page
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centered horizontally
                children: [
                  // Row for the back arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Go back to the previous page
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 12), // Space between title and image
                  // Centered image
                  Container(
                    width: 120, // Reduced width for the image
                    height: 120, // Reduced height for the image
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/favoris.png'), // Added image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Space between image and list
                  // Section for favorite items
                  Container(
                    height: 250, // Height for the favorites section
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
                              const SizedBox(height: 16), // Space between title and list
                              // Fetch and display favorite items from Firestore
                              Expanded(
                                child: StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('favorites')
                                      .doc(user?.uid) // Get the user's favorites document
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData || !snapshot.data!.exists) {
                                      return const Center(child: Text('Aucun favori trouvé.'));
                                    }

                                    // Extract the favorites list from the document
                                    List<dynamic> favorites = snapshot.data!['favorites'] ?? [];

                                    if (favorites.isEmpty) {
                                      return const Center(child: Text('Aucun favori trouvé.'));
                                    }

                                    return ListView.builder(
                                      itemCount: favorites.length,
                                      itemBuilder: (context, index) {
                                        // Ensure that each favorite item is a map
                                        final favori = favorites[index];
                                        if (favori is Map<String, dynamic>) {
                                          return Card(
                                            margin: const EdgeInsets.symmetric(vertical: 8),
                                            child: ListTile(
                                              leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.asset(
                                                  favori['image'], // Ensure this field exists in your Firestore data
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              title: Text(favori['item']), // Ensure this field exists in your Firestore data
                                              subtitle: Text(
                                                'Date: ${favori['date']}', // Ensure this field exists in your Firestore data
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () {
                                                  // Remove the favorite item from Firestore
                                                  removeFavorite(user!.uid, favori);
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox.shrink(); // Handle unexpected data types
                                        }
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