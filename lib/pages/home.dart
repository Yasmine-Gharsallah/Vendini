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
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _userName = userDoc['nom'] + userDoc['prenom'] ?? 'User';
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
          .where((product) => product['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading) {
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
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: _userProfileImage != null ?
                  NetworkImage(_userProfileImage!) : AssetImage("assets/profile.png"),
            ),
            SizedBox(width: 10),
            Text(
              _userName ?? "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              print('Favoris');
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(
                  context, '/cart'); // Navigation vers la page du panier
            },
          ),
        ],
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Découvrez nos offres !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB50D56),
                ),
              ),
            ),
            SizedBox(
              height: 120,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        itemCount: _filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
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
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFCDFDB),
            ),
            child: Text(
              'Catégories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Vêtements'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Meubles'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Vaiselle'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Electroménager'),
            onTap: () {
              Navigator.pop(context);
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
              print('Paramètres');
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

  Widget _buildProductCard(String productName, String price, String imagePath,
      {bool showDiscount = false,
      bool hideDetails = false,
      bool showCartIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                width: 165,
                height: 135,
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
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      price,
                      style: const TextStyle(color: Colors.grey),
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
    );
  }
}
