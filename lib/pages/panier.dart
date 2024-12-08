import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId; // Unique identifier for the product
  final double price; // Price of the product
  final String name; // Name of the product
  final String image; // Image URL of the product
  bool isSelected; // Selection state of the product
  final String? documentId; // Firestore document ID (optional)

  // Constructor for creating a CartItem
  CartItem({
    required this.productId,
    required this.price,
    required this.name,
    required this.image,
    this.isSelected = false, // Default value for isSelected
    this.documentId,
  });

  // Factory constructor to create a CartItem from Firestore document
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    return CartItem(
      productId: doc.id, // Use the document ID as the product ID
      price: double.tryParse(doc['price'].toString()) ?? 0.0, // Convert price to double
      name: doc['label'] ?? 'Unknown', // Assuming 'label' is the name
      image: doc['imagePath'] ?? '', // Assuming 'imagePath' is the image URL
      documentId: doc.id, // Store the document ID for future reference
    );
  }
}

class PanierPage extends StatefulWidget {
  final String userId; // Pass the current user's ID

  const PanierPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final TextEditingController promoController = TextEditingController();
  bool promoApplied = false;
  double discount = 0.0;
  List<CartItem> products = []; // List to hold CartItem objects

  void applyPromoCode() {
    setState(() {
      if (promoController.text == "Eya0214") {
        promoApplied = true;
        discount = 0.1;
      } else {
        promoApplied = false;
        discount = 0.0;
      }
    });
  }

  double get subtotal => products
      .where((product) => product.isSelected)
      .fold(0, (sum, product) => sum + product.price);
  double get discountAmount => subtotal * discount;
  double get total => subtotal - discountAmount;

  Future<List<CartItem>> fetchProducts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchProducts().then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Mon Panier",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFb80d57),
                        shadows: [
                          Shadow(
                              color: Color.fromARGB(255, 39, 0, 14),
                              offset: Offset(0, 0.5),
                              blurRadius: 2)
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Image.asset('assets/images/panier.png', height: 120),
                    const SizedBox(height: 15),
                    const Text(
                      "Confirmer les produits à acheter",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 135, 2, 60)),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount : products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];
                          return Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(8),
                            width: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(product.image.isNotEmpty ? product.image : 'default_image_url', height: 100, fit: BoxFit.cover),
                                const SizedBox(height: 8),
                                Text(
                                  product.name.isNotEmpty ? product.name : 'Unknown Product',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                                const SizedBox(height: 4),
                                CheckboxListTile(
                                  title: const Text("Select"),
                                  value: product.isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      product.isSelected = value ?? false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: promoController,
                        decoration: InputDecoration(
                          labelText: "Promo Code",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: applyPromoCode,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      promoApplied ? "Promo Applied: 10% off" : "No Promo Applied",
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Subtotal: \$${subtotal.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Discount: \$${discountAmount.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle checkout logic here
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}