import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: const Color(0xFFFCDFDB),
      ),
      body: Container(
        width: double.infinity, // Ensure full width
        height: double.infinity, // Ensure full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // Background image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Aucun profil trouvé.'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userData['profileImage'] ?? 'assets/images/default_profile.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Nom: ${userData['nom']} ${userData['prenom']}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Email: ${userData['email']}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text('Téléphone: ${userData['telephone']}', style: const TextStyle(fontSize: 16)), // Display phone number
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your edit profile functionality here
                      print('Edit Profile button pressed');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Change button color to red
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}