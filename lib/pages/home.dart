import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:vendini/pages/favoris.dart'; // Import the FavorisPage
import 'package:vendini/pages/profil.dart'; // Import the ProfilPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance
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
    {'name': 'Les misérables', 'price': '80 TND', 'image': 'assets/images/6.png'},
    {'name': 'Armoire', 'price': '200 TND', 'image': 'assets/images/7.png'},
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredProducts = [];
  final Set<Map<String, dynamic>> _favoriteProducts = Set<Map<String, dynamic>>(); // Set to keep track of favorite products

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
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['nom'] + ' ' + userDoc['prenom'] ?? 'User';
            _userProfileImage = userDoc['profileImage'] ?? 'assets/images/default_profile.png';
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error retrieving user data: $e');
      }
    }
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _blurProducts
          .where((product) => product['name']!.toLowerCase().contains(query) || product['price']!.contains(query)) // Allow filtering by price
          .toList();
    });
  }

  Future<void> _addFavoriteToFirestore(Map<String, dynamic> favoriteItem) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('favorites').doc(user.uid).set({
          'favorites': FieldValue.arrayUnion([favoriteItem])
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error adding favorite: $e');
      }
    }
  }

  Future<void> _removeFavoriteFromFirestore(Map<String, dynamic> favoriteItem) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('favorites').doc(user.uid).update({
          'favorites': FieldValue.arrayRemove([favoriteItem]),
        });
      } catch (e) {
        print('Error removing favorite: $e');
      }
    }
  }

  Widget _buildProductCard(String productName, String price, String imagePath, {bool showCartIcon = false, Function()? onTap}) {
    bool isFavorite = _favoriteProducts.any((item) => item['item'] == productName); // Check if the product is a favorite

    return GestureDetector(
      onTap: onTap ?? () {
        if (imagePath == 'assets/images/4.png') {
          Navigator.pushNamed(context, '/infoProd'); // Navigation to InfoProd
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04), // Dynamic padding
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
              Positioned(
                bottom: 5,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 251, 251, 251), // Contrast color
                        fontWeight: FontWeight.bold, // Bold text
                        fontSize: 16, // Adjusted text size
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 143, 131, 131), // Contrast color
                        fontWeight: FontWeight.bold, // Bold text
                        fontSize: 16, // Adjusted text size
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isFavorite) {
                        _favoriteProducts.removeWhere((item) => item['item'] == productName); // Remove from favorites
                        _removeFavoriteFromFirestore({ // Remove from Firestore
                          'item': productName,
                          'price': price,
                          'date': DateTime.now().toString(),
                          'image': imagePath,
                        });
                      } else {
                        _favoriteProducts.add({ // Add to favorites
                          'item': productName,
                          'price': price,
                          'date': DateTime.now().toString(),
                          'image': imagePath,
                        });
                        _addFavoriteToFirestore({ // Add to Firestore
                          'item': productName,
                          'price': price,
                          'date': DateTime.now().toString(),
                          'image': imagePath,
                        });
                        // Show SnackBar message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Vous avez ajouté cet article aux favoris'),
                            duration: Duration(seconds: 2), // Duration for the SnackBar
                          ),
                        );
                      }
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
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
                      child: Icon(Icons.add_shopping_cart, color: Colors.pink, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
        automaticallyImplyLeading: false, // Prevent automatic menu spacing
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilPage()), // Navigate to ProfilPage
                );
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.07, // 6% of screen width
                backgroundImage: _userProfileImage != null
                    ? NetworkImage(_userProfileImage!)
                    : AssetImage("assets/profile.png"),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01), // Spacing between image and text
            Expanded(
              child: Text(
                _userName ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.035, // Dynamic size
                  overflow: TextOverflow.ellipsis, // Prevent text overflow
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white), // Favorites icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavorisPage()), // Navigate to FavorisPage
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            IconButton(
              icon: Image.asset('assets/images/logout.png', width: 24, height: 24), // Custom logout image
              onPressed: () async {
                await _auth.signOut(); // Sign out the user
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
              },
            ),
          ],
        ),
      ),
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Dynamic padding
              child: Text(
                'Découvrez nos offres !',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06, // Dynamic size
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB50D56),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _scrollProducts
                      .map((product) => _buildProductCard(
                    product['name']!,
                    product['price']!,
                    product['image']!,
                    showCartIcon: true,
                  ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04), // Dynamic padding
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
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Dynamic padding
                      child: GridView.builder(
                        itemCount: _filteredProducts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // 2 columns for small screens, 3 for larger
                          crossAxisSpacing: MediaQuery.of(context).size.width * 0.04, // Dynamic spacing
                          mainAxisSpacing: MediaQuery.of(context).size.height * 0.02, // Dynamic spacing
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
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              print('Notifications');
            },
          ),
        ],
      ),
    );
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
}