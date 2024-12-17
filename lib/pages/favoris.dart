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
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: const Color(0xFFFCDFDB),
      ),
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
                                      return const Center(child: CircularProgressIndicator()); // Loading indicator
                                    }
                                    if (!snapshot.hasData || !snapshot.data!.exists) {
                                      return const Center(child: Text('Aucun favori trouvé.')); // No favorites found
                                    }

                                    // Extract the favorites list from the document
                                    List<dynamic> favorites = snapshot.data!['favorites'] ?? [];

                                    if (favorites.isEmpty) {
                                      return const Center(child: Text('Aucun favori trouvé.')); // No favorites found
                                    }

                                    return ListView.builder(
                                      itemCount: favorites.length,
                                      itemBuilder: (context, index) {
                                        // Ensure that each favorite item is a string (product name)
                                        String productName = favorites[index] ?? 'Nom inconnu'; // Default value if null
                                        return Card(
                                          margin: const EdgeInsets.symmetric(vertical: 8),
                                          child: ListTile(
                                            title: Text(productName), // Display the product name
                                            onTap: () {
                                              // Navigate to product details or another action if needed
                                              Navigator.pushNamed(context, '/productDetail', arguments: productName);
                                            },
                                          ),
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