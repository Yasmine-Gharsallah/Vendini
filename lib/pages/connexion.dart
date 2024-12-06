import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vendini/pages/home.dart' as home ;
import 'package:vendini/pages/inscription.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage; // Variable pour stocker le message d'erreur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/backgroundd.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 350.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 90, 62, 61).withOpacity(0.6),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Connectez-Vous',
                      style: TextStyle(
                        fontSize: 28,
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
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4f0002),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5CAC3).withOpacity(0.75),
                        hintText: 'Entrez votre email',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(150, 109, 66, 66)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF4f0002)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mot de passe :',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4f0002),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF5CAC3).withOpacity(0.75),
                        hintText: 'Entrez votre mot de passe',
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(150, 109, 66, 66)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
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
                    const SizedBox(height: 30),
                    if (_errorMessage != null) // Affiche l'erreur si elle existe
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
      
                        setState(() {
                          _errorMessage =
                              null; // Réinitialise le message d'erreur
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
                          if (e.code == 'user-not-found') {
                            setState(() {
                              _errorMessage =
                                  'Aucun utilisateur trouvé pour cet email.';
                            });
                          } else if (e.code == 'wrong-password') {
                            setState(() {
                              _errorMessage = 'Mot de passe incorrect.';
                            });
                          } else {
                            setState(() {
                              _errorMessage = 'L\'email ou le mot de passe est incorrect.';
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFb80d57),
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Se Connecter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Vous n'avez pas un compte ? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4f0002),
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
                          child: const Text(
                            'Créer un',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFb80d57),
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
}
