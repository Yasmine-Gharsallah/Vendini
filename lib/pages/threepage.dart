import 'package:flutter/material.dart';

class ThreePage extends StatelessWidget {
  const ThreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Main image (sac with face)
                Image.asset(
                  'assets/images/sac.png', // Ensure the path is correct
                  fit: BoxFit.cover,
                  height: 200, // Set a height for better visibility
                ),
                const SizedBox(height: 30),
                // Title "How to Buy?"
                const Text(
                  "Comment Acheter ?",
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
                  "Connectez-vous sur l'application ! Choisissez ce que vous voulez ! Cliquez et acheter",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffad492b),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Arrow to navigate to the next page
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/four'); // Navigate to FourPage
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
