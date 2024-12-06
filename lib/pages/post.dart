import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:typed_data'; // Pour Uint8List

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialisation de Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajouter un produit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddProductPage(),
    );
  }
}

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _warrantyController = TextEditingController();

  // Fonction pour sélectionner une image
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Pour le Web, utiliser dart:html pour sélectionner une image
      final html.FileUploadInputElement input = html.FileUploadInputElement();
      input.accept = 'image/*'; // Accepter uniquement les images
      input.click(); // Ouvrir la boîte de dialogue de sélection de fichier

      input.onChange.listen((e) async {
        final files = input.files;
        if (files!.isEmpty) return;

        // Lire l'image sélectionnée et la convertir en base64
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _image = XFile(reader.result.toString());
          });
        });
      });
    } else {
      // Pour mobile, utiliser ImagePicker pour choisir une image
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }
  }

  // Fonction pour uploader le produit
  Future<void> _uploadProduct() async {
    if (_image == null) return;

    try {
      // Pour le Web, convertir l'image base64 en fichier
      String imageUrl = '';
      if (kIsWeb) {
        final bytes = Uri.parse(_image!.path).data!.contentAsBytes();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('products/${DateTime.now().millisecondsSinceEpoch}');
        await storageRef.putData(Uint8List.fromList(bytes));
        imageUrl = await storageRef.getDownloadURL();
      } else {
        // Pour mobile, utiliser _image!.path pour récupérer l'URL de l'image
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('products/$fileName');
        await storageRef.putFile(File(_image!.path));
        imageUrl = await storageRef.getDownloadURL();
      }

      // Ajouter le produit à Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'label': _labelController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'brand': _brandController.text,
        'size': _sizeController.text,
        'condition': _conditionController.text,
        'warranty': _warrantyController.text,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit ajouté avec succès')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Effet de flou
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10.0, sigmaY: 10.0), // Appliquer le flou
            child: Container(
              color: Colors.black.withOpacity(0.2), // Couche semi-transparente
            ),
          ),
          // Contenu de la page
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bouton retour
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 20),
                // Formulaire
                Expanded(
                  child: SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      color:
                          Colors.white.withOpacity(0.9), // Transparence du fond
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Zone pour ajouter une image (plus grande)
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                height:
                                    250, // Augmenté pour une zone plus grande
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4CBC7),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: _image == null
                                    ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              size: 60, color: Colors.black54),
                                          SizedBox(height: 10),
                                          Text("Ajouter une photo",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16)),
                                        ],
                                      )
                                    : kIsWeb
                                        ? Image.network(_image!.path,
                                            fit: BoxFit.cover)
                                        : Image.file(File(_image!.path),
                                            fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Champs du formulaire
                            CustomTextField(
                                controller: _labelController, label: "Label"),
                            CustomTextField(
                                controller: _descriptionController,
                                label: "Description"),
                            CustomTextField(
                                controller: _priceController, label: "Prix"),
                            CustomTextField(
                                controller: _brandController, label: "Marque"),
                            CustomTextField(
                                controller: _sizeController, label: "Taille"),
                            CustomTextField(
                                controller: _conditionController,
                                label: "État"),
                            CustomTextField(
                                controller: _warrantyController,
                                label: "Garantie/Date d’acquisition"),
                            const SizedBox(height: 20),
                            // Bouton de validation
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFFA34961), // Couleur du bouton
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _uploadProduct,
                                child: const Text(
                                  "Validation",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
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
        ],
      ),
    );
  }
}

// Widget réutilisable pour les champs de texte
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField(
      {super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }
}
