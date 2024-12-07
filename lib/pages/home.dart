import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance
  String? _userName;
  String? _userProfileImage;
  bool isLoading = true;

  final List<Map<String, String>> _scrollProducts = [
    {'name': 'Produit 1', 'price': '20 TND', 'image': 'assets/images/1.png'},
    {'name': 'Produit 2', 'price': '40 TND', 'image': 'assets/images/2.png'},
    {'name': 'Produit 3', 'price': '60 TND', 'image': 'assets/images/3.png'},
    {'name': 'Produit 5', 'price': '100 TND', 'image': 'assets/images/5.png'},
  ];

  final List<Map<String, String>> _blurProducts = [
    {'name': 'Pyjama', 'price': '30 TND', 'image': 'assets/images/4.png'},
    {'name': 'Manteau', 'price': '50 TND', 'image': 'assets/images/5.png'},
    {
      'name': 'Les misérables',
      'price': '80 TND',
      'image': 'assets/images/6.png'
    },
    {'name': 'Armoire', 'price': '200 TND', 'image': 'assets/images/7.png'},
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(_blurProducts);
    _searchController.addListener(_filterProducts);
    _initUser();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['nom'] + userDoc['prenom'] ?? 'User';
            _userProfileImage =
                userDoc['profileImage'] ?? 'assets/images/default_profile.png';
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error retrieving user data: $e');
      }
    }
  }
  void _filterByCategory(String category) {
    setState(() {
      if (category == 'Vêtement') {
        _filteredProducts = _blurProducts
            .where((product) =>
                product['image'] == 'assets/images/4.png' ||
                product['image'] == 'assets/images/5.png')
            .toList();
      } else if (category == 'Meuble') {
        _filteredProducts = _blurProducts
            .where((product) => product['image'] == 'assets/images/7.png')
            .toList();
      } else if (category == 'Livres') {
        _filteredProducts = _blurProducts
            .where((product) => product['image'] == 'assets/images/6.png')
            .toList();
      } else if (category == 'Vaisselle' || category == 'Électroménager') {
        _filteredProducts = [];
      }
    });
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _blurProducts
           .where((product) =>
            product['name']!.toLowerCase().contains(query) || 
            product['price']!.contains(query)) // Ajout pour permettre de filtrer aussi par prix
        .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCDFDB),
        automaticallyImplyLeading:
            false, // Empêcher l'espacement automatique du menu
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          children: [
            // Image de profil avec taille dynamique réduite
            CircleAvatar(
              radius: MediaQuery.of(context).size.width *
                  0.07, // 6% de la largeur de l'écran
              backgroundImage: _userProfileImage != null
                  ? NetworkImage(_userProfileImage!)
                  : AssetImage("assets/profile.png"),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.01), // Espacement entre image et texte
            // Texte du nom d'utilisateur
            Expanded(
              child: Text(
                _userName ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width *
                      0.035, // Taille dynamique réduite
                  overflow: TextOverflow
                      .ellipsis, // Pour éviter que le texte dépasse l'espace
                ),
              ),
            ),
            // Icône favoris alignée à droite avec un espacement réduit
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                print('Favoris');
              },
            ),
            // Icône panier alignée à droite
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
      ),

      // return Scaffold(
      //   drawer: _buildDrawer(),
      //   appBar: AppBar(
      //     backgroundColor: const Color(0xFFFCDFDB),
      //     title: Row(
      //       children: [
      //         CircleAvatar(
      //           radius: MediaQuery.of(context).size.width *
      //               0.08, // 8% de la largeur de l'écran
      //           backgroundImage: _userProfileImage != null
      //               ? NetworkImage(_userProfileImage!)
      //               : AssetImage("assets/profile.png"),
      //         ),
      //         SizedBox(
      //             width: MediaQuery.of(context).size.width *
      //                 0.03), // Espacement dynamique
      //         Text(
      //           _userName ?? "",
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //             fontSize: MediaQuery.of(context).size.width *
      //                 0.04, // Taille dynamique
      //           ),
      //         ),
      //       ],
      //     ),
      //     actions: [
      //       IconButton(
      //         icon: const Icon(Icons.favorite, color: Colors.white),
      //         onPressed: () {
      //           print('Favoris');
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.shopping_cart, color: Colors.white),
      //         onPressed: () {
      //           Navigator.pushNamed(context, '/cart');
      //         },
      //       ),
      //     ],
      //   ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width *
                  0.04), // Padding dynamique
              child: Text(
                'Découvrez nos offres !',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.06, // Taille dynamique
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB50D56),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.2, // 20% de la hauteur de l'écran
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _scrollProducts
                      .map((product) => _buildProductCard(
                            product['name']!,
                            product['price']!,
                            product['image']!,
                            hideDetails: true,
                            showDiscount: true,
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.04), // Padding dynamique
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width *
                              0.04), // Padding dynamique
                      child: GridView.builder(
                        itemCount: _filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width >
                                  600
                              ? 3
                              : 2, // 2 colonnes pour les petits écrans, 3 pour les plus grands
                          crossAxisSpacing: MediaQuery.of(context).size.width *
                              0.04, // Espacement dynamique
                          mainAxisSpacing: MediaQuery.of(context).size.height *
                              0.02, // Espacement dynamique
                        ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return _buildProductCard(
                            product['name']!,
                            product['price']!,
                            product['image']!,
                            showCartIcon: true,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 188, 223),
            ),
            child: Text(
              'Catégories',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Vêtement'),
            onTap: () {
              Navigator.pop(context);
              _filterByCategory('Vêtement');
            },
          ),
          ListTile(
            title: Text('Meuble'),
            onTap: () {
              Navigator.pop(context);
              _filterByCategory('Meuble');
            },
          ),
          ListTile(
            title: Text('Livres'),
            onTap: () {
              Navigator.pop(context);
              _filterByCategory('Livres');
            },
          ),
          ListTile(
            title: Text('Vaisselle'),
            onTap: () {
              Navigator.pop(context);
              _filterByCategory('Vaisselle');
            },
          ),
          ListTile(
            title: Text('Électroménager'),
            onTap: () {
              Navigator.pop(context);
              _filterByCategory('Électroménager');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      color: const Color(0xFFFCDFDB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              print('Accueil');
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              _showSettingsMenu();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              print('Notifications');
            },
          ),
        ],
      ),
    );
  }

  void _showSettingsMenu() async {
    try {
      // Show a confirmation dialog before logging out
      bool? confirmLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Déconnexion'),
            content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
            actions: <Widget>[
              TextButton(
                child: Text('Annuler'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Déconnexion'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      );

      // Only proceed with logout if confirmed
      if (confirmLogout == true) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        // Perform logout
        await FirebaseAuth.instance.signOut();

        // Dismiss loading indicator and navigate to login
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } catch (e) {
      // Handle potential logout errors
      Navigator.of(context).pop(); // Dismiss loading indicator if it's showing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de déconnexion: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProductCard(String productName, String price, String imagePath,
      {bool showDiscount = false,
      bool hideDetails = false,
      bool showCartIcon = false}) {
     return GestureDetector(
    onTap: () {
      if (imagePath == 'assets/images/4.png') {
        Navigator.pushNamed(context, '/infoProd'); // Navigation vers InfoProd
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.04), // Padding dynamique
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.cover,
              ),
            ),
            if (showDiscount)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.red,
                  child: const Text(
                    '-50%',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (!hideDetails)
              Positioned(
                bottom: 5,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                       style: const TextStyle(
    color: Color.fromARGB(255, 251, 251, 251), // Noir pur pour le contraste
    fontWeight: FontWeight.bold, // Texte en gras
    fontSize: 16, // Taille du texte ajustée pour plus de lisibilité
  ),
                    ),
                    Text(
  price,
  style: const TextStyle(
    color: Color.fromARGB(255, 143, 131, 131), // Noir pur pour le contraste
    fontWeight: FontWeight.bold, // Texte en gras
    fontSize: 16, // Taille du texte ajustée pour plus de lisibilité
  ),
),

                  ],
                ),
              ),
            if (showCartIcon)
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    print('Produit ajouté au panier : $productName');
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.add_shopping_cart,
                        color: Colors.pink, size: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    )
  );}
}
