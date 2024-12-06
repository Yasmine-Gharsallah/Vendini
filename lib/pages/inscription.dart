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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InscriptionPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InscriptionPage extends StatefulWidget {
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

  // Future<void> _signup() async {
  //   if (_formKey.currentState!.validate()) {
  //     if (_selectedGender == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Veuillez sélectionner un genre.')),
  //       );
  //       return;
  //     }
  //     if (role == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Veuillez sélectionner un rôle.')),
  //       );
  //       return;
  //     }

  //     if (_selectedImage == null) {
  //       _showSelectImageDialog();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Veuillez sélectionner une image.')),
  //       );
  //       return;
  //     }

  //     try {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       userCredential = await _auth.createUserWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       int cin = int.parse(_cinController.text.trim());
  //       DateTime date = DateTime.parse(_dobController.text.trim());
  //       Gender gender = _selectedGender == "Male" ? Gender.MALE : Gender.FEMALE;

  //       String? profileImageUrl = await _uploadImage();

  //       UserModel user = UserModel(
  //         id: userCredential!.user!.uid,
  //         username: _nameController.text.trim(),
  //         cin: cin,
  //         birthday: date,
  //         phoneNumber: _phoneController.text.trim(),
  //         role: role ?? Role.PATIENT,
  //         profilePicture: profileImageUrl,
  //         gender: gender,
  //       );

  //       await _firestore
  //           .collection('users')
  //           .doc(user.id)
  //           .set(user.toFirestore());
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       GlobalController().setCurrentUser(user);
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Inscription réussie!')),
  //         );
  //       }
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginPage()),
  //       );
  //     } on FirebaseAuthException catch (e) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(e.message ?? "Error occurred during signup.")),
  //         );
  //       }
  //     }
  //   }
  // }

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
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond fixe
          Positioned.fill(
            child: _imageFile != null ? Image.file(_imageFile!):Image.asset(
              'assets/images/backgroundd.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
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
                  width: 350,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Création de compte',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFb80d57),
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                const Color.fromARGB(255, 243, 171, 170),
                            child: _imageFile == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Color.fromARGB(255, 157, 16, 70),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 28,
                                color: Color.fromARGB(255, 88, 2, 39),
                              ),
                              onPressed: _showSelectImageDialog,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildTextField("Nom", _nomController),
                      const SizedBox(height: 15),
                      _buildTextField("Prénom", _prenomController),
                      const SizedBox(height: 15),
                      _buildTextField("Email", _emailController,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 15),
                      _buildTextField("Téléphone", _telephoneController,
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 15),
                      _buildTextField("Mot de Passe", _motdepasseController,
                          obscureText: true),
                      const SizedBox(height: 15),
                      _buildTextField("Confirmer le mot de passe",
                          _confirmerMotdepasseController,
                          obscureText: true),
                      const SizedBox(height: 20),
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
                          const Flexible(
                            child: Text(
                              'Accepter la politique de confidentialité',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          'Créer mon compte',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4f0002)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5CAC3).withOpacity(0.75),
            hintText: 'Entrez votre $label',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
