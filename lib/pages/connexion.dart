import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendini/pages/home.dart' as home;
import 'package:vendini/pages/inscription.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage; // Variable pour stocker le message d'erreur

  @override
  Widget build(BuildContext context) {
    // Obtenir les dimensions de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Fond d'écran couvrant tout l'écran
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgroundd.png',
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Container(
                // Margin et largeur dynamiques
                margin: EdgeInsets.only(top: screenHeight * 0.4, bottom: screenHeight*0.06,) ,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 90, 62, 61)
                          .withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                // Largeur dynamique
                width: screenWidth * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Titre avec taille de police dynamique
                    Text(
                      'Connectez-Vous',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFb80d57),
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(255, 39, 0, 14),
                            offset: Offset(0, 0.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Champ Email avec label et style dynamiques
                    _buildDynamicTextField(
                      context,
                      label: 'Email :',
                      hintText: 'Entrez votre email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Champ Mot de passe avec label et style dynamiques
                    _buildDynamicTextField(
                      context,
                      label: 'Mot de passe :',
                      hintText: 'Entrez votre mot de passe',
                      controller: _passwordController,
                      obscureText: true,
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Affichage du message d'erreur
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.01),

                    // Bouton de connexion dynamique
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();

                        setState(() {
                          _errorMessage = null;
                        });

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => home.HomePage(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _errorMessage = _getErrorMessage(e);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFb80d57),
                        // Padding dynamique
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.025,
                            horizontal: screenWidth * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Se Connecter',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Ligne d'inscription dynamique
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas un compte ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4f0002),
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InscriptionPage()),
                            );
                          },
                          child: Text(
                            'Créer un',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFb80d57),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Méthode helper pour créer des champs de texte dynamiques
  Widget _buildDynamicTextField(
    BuildContext context, {
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label dynamique
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4f0002),
            fontSize: screenWidth * 0.045,
          ),
        ),

        SizedBox(height: screenWidth * 0.035),

        // Champ de texte dynamique
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5CAC3).withOpacity(0.75),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Color.fromARGB(150, 109, 66, 66),
              fontSize: screenWidth * 0.035,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.03,
              horizontal: screenWidth * 0.03,
            ),
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF4f0002)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

// Méthode pour gérer les messages d'erreur Firebase
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé pour cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      default:
        return 'L\'email ou le mot de passe est incorrect.';
    }
  }
}
