import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:vendini/pages/home.dart' as home2;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialiser Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InscriptionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  File? _imageFile;
  bool _privacyAccepted = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _motdepasseController = TextEditingController();
  final TextEditingController _confirmerMotdepasseController =
      TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    await _checkPermission();
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToImgur(File imageFile) async {
    const clientId = '9f9ec81a2a40523';
    final uri = Uri.parse('https://api.imgur.com/3/image');
    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Client-ID $clientId';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

      // Send request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['data']['link']; // Return the URL of the uploaded image
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
    }
    return null;
  }

  Future<String?> _uploadImage() async {
    _checkPermission();
    if (_imageFile != null) {
      final uploadUrl = await _uploadImageToImgur(_imageFile!);
      return uploadUrl;
    }
    return null;
  }

  Future<void> _checkPermission() async {
    var status = await Permission.storage.status;
    var cameraStatus = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  void _showSelectImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir une image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir une photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createAccount() async {
    final String email = _emailController.text.trim();
    final String password = _motdepasseController.text.trim();
    final String confirmPassword = _confirmerMotdepasseController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Les mots de passe ne correspondent pas.")),
      );
      return;
    }

    if (_imageFile == null) {
      _showSelectImageDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une image.')),
      );
      return;
    }

    try {
      // Créer un utilisateur avec Firebase Authentication
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? profileImageUrl = await _uploadImage();

      final userData = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'email': _emailController.text,
        'telephone': _telephoneController.text,
        'profileImage': profileImageUrl ?? "",
      };

      await _firestore.collection('users').doc(user.user!.uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès!")),
      );

      // Rediriger vers la page d'accueil après la création
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => home2.HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Une erreur s'est produite.";
      if (e.code == 'email-already-in-use') {
        errorMessage = "Cet email est déjà utilisé.";
      } else if (e.code == 'weak-password') {
        errorMessage = "Le mot de passe est trop faible.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fond d'écran couvrant tout l'écran
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundd.png',
              fit: BoxFit.cover,
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              // Padding en pourcentage
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.05),
              child: Center(
                child: Container(
                  // Largeur en pourcentage
                  width: screenWidth * 0.9,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre avec taille de police adaptative
                      Text(
                        'Création de compte',
                        style: TextStyle(
                          fontSize:
                              screenWidth * 0.07, // Taille de police dynamique
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFb80d57),
                        ),
                      ),

                      // Avatar avec taille dynamique
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            // Rayon basé sur la largeur de l'écran
                            radius: screenWidth * 0.12,
                            backgroundColor:
                                const Color.fromARGB(255, 243, 171, 170),
                            child: _imageFile == null
                                ? Icon(
                                    Icons.person,
                                    size:
                                        screenWidth * 0.12, // Taille dynamique
                                    color: Color.fromARGB(255, 157, 16, 70),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: screenWidth * 0.24,
                                      height: screenWidth * 0.24,
                                    ),
                                  ),
                          ),
                          // Bouton caméra avec positionnement et taille dynamiques
                          Positioned(
                            right: -screenWidth * 0.02,
                            bottom: -screenWidth * 0.02,
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: screenWidth * 0.07,
                                color: Color.fromARGB(255, 88, 2, 39),
                              ),
                              onPressed: _showSelectImageDialog,
                            ),
                          ),
                        ],
                      ),

                      // Espacement dynamique
                      SizedBox(height: screenHeight * 0.03),

                      // Champs de texte avec largeurs et espacements dynamiques
                      _buildTextField(context, "Nom", _nomController),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(context, "Prénom", _prenomController),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(context, "Email", _emailController,
                          keyboardType: TextInputType.emailAddress),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                          context, "Téléphone", _telephoneController,
                          keyboardType: TextInputType.phone),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(
                          context, "Mot de Passe", _motdepasseController,
                          obscureText: true),
                      SizedBox(height: screenHeight * 0.02),
                      _buildTextField(context, "Confirmer le mot de passe",
                          _confirmerMotdepasseController,
                          obscureText: true),

                      // Politique de confidentialité avec taille dynamique
                      Row(
                        children: [
                          Checkbox(
                            value: _privacyAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _privacyAccepted = value ?? false;
                              });
                            },
                          ),
                          Flexible(
                            child: Text(
                              'Accepter la politique de confidentialité',
                              style: TextStyle(
                                  fontSize: screenWidth *
                                      0.035 // Taille de police dynamique
                                  ),
                            ),
                          ),
                        ],
                      ),

                      // Bouton avec dimensions dynamiques
                      ElevatedButton(
                        onPressed: () {
                          if (_privacyAccepted) {
                            _createAccount();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Vous devez accepter la politique de confidentialité."),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFb80d57),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                              horizontal: screenWidth * 0.05),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Créer mon compte',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.white),
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
    );
  }

// Méthode modifiée pour accepter le context et utiliser des tailles dynamiques
  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label avec taille dynamique
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4f0002),
              fontSize: screenWidth * 0.04 // Taille dynamique
              ),
        ),
        SizedBox(height: screenWidth * 0.02),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5CAC3).withOpacity(0.75),
            hintText: 'Entrez votre $label',
            contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.04, horizontal: screenWidth * 0.03),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFb80d57)),
            ),
          ),
        ),
      ],
    );
  }
}
