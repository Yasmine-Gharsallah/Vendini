import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PanierPage extends StatefulWidget {
  final String userId = "tk1UIXNwLzPMxXCZGseQ3OQGuLP2";

  const PanierPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<Map<String?, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
  }

  Future<void> fetchCartProducts() async {
    try {
      final fetchedProducts = await getUserCartProducts(widget.userId);
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching cart products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  final TextEditingController promoController = TextEditingController();
  bool promoApplied = false;
  double discount = 0.0;

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
          .where((product) => product['selected'] == true)
          .fold(0.0, (sum, product) {
        // Convert price to double, handling String and num types
        double price = 0.0;

        if (product['price'] is String) {
          price = double.tryParse(product['price']) ??
              0.0; // Convert String to double
        } else if (product['price'] is num) {
          price = (product['price'] as num).toDouble(); // Convert num to double
        }
        return sum + price; // Add to the sum
      });
  double get discountAmount => subtotal * discount;
  double get total => subtotal - discountAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double
                .infinity, // Assure que le container prend toute la hauteur de l'écran
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover, // Couvre tout l'écran
              ),
            ),
            child: SingleChildScrollView(
              // Maintient le contenu scrollable
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
                  //1er image
                  const SizedBox(height: 15),
                  Image.asset('assets/images/panier.png', height: 120),
                  const SizedBox(height: 15),
                  //2 eme image
                  Image.asset('assets/images/livraison2.png', height: 45),
                  const SizedBox(height: 35),
                  //
                  const Text(
                    "Confirmer les produits à acheter",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 135, 2, 60)),
                  ),
                  //les produits liste iamges glissants horizontalement
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
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
                                color: const Color.fromARGB(247, 66, 66, 66)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior:
                                Clip.none, // Permet à la Checkbox de dépasser
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        10), // Coins arrondis
                                    child: Image.network(
                                      product['imageUrl'] != null &&
                                              product['imageUrl'].isNotEmpty
                                          ? product[
                                              'imageUrl'] // Use imageUrl if valid
                                          : 'assets/images/armoire.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        product['label'] ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              20), // Espace flexible entre les deux Text
                                      Text(
                                        "${product['price']?.toString() ?? '0'} TND",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromARGB(255, 39, 39, 39),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Positioned(
                                right:
                                    -15, // Décalage horizontal (à droite) de la Checkbox
                                bottom:
                                    -15, // Décalage vertical (en bas) de la Checkbox
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      products[index]['selected'] =
                                          !product['selected'];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                        0.5), // Fond blanc autour de la Checkbox
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Fond blanc
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color.fromARGB(
                                                  247, 66, 66, 66)
                                              .withOpacity(0.2),
                                          blurRadius: 5,
                                          offset: const Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    child: Checkbox(
                                      value: product['selected'],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          products[index]['selected'] = value!;
                                        });
                                      },
                                      activeColor: const Color(
                                          0xFFb80d57), // Couleur de la case cochée
                                      checkColor: Colors
                                          .white, // Couleur du check à l'intérieur de la case
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  //Code promo
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(240, 46, 2, 2)
                              .withOpacity(0.7),
                          blurRadius: 8,
                          offset: const Offset(3, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Avez-vous un code promo ?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 137, 14, 49),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5CAC3)
                                .withOpacity(0.75), // Fond rose clair
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 113, 113, 113), // Couleur de la bordure
                              width: 0.8, // Épaisseur de la bordure
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 56, 30, 30)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: promoController,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .transparent, // Le fond est transparent
                                    hintText: 'Entrez votre code promo',
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(150, 109, 66, 66)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: applyPromoCode,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Valider",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 137, 14, 49),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (promoApplied)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Votre code promo vous permet de bénéficier d'une remise de ${(discount * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 74, 6, 25),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //Montant et promo
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 56, 30, 30),
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Panier",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFb80d57),
                              shadows: [
                                Shadow(
                                    color: Color.fromARGB(255, 39, 0, 14),
                                    offset: Offset(0, 0.5),
                                    blurRadius: 2),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        rowDetail(
                            'Sous Total', "${subtotal.toStringAsFixed(3)} TND"),
                        const Divider(),
                        rowDetail('Promotion',
                            "-${discountAmount.toStringAsFixed(3)} TND"),
                        const Divider(),
                        rowDetail('Montant après remise',
                            "${total.toStringAsFixed(3)} TND",
                            bold: true),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFb80d57),
                              minimumSize: const Size(100, 45),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/payement');
                            },
                            child: const Text(
                              "Payer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30, // Positionne l'icône en haut à gauche
            left: 15, // Décale un peu à gauche
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Retourne à la page précédente
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget rowDetail(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> getUserCartProducts(String userId) async {
  try {
    // Reference to the user's cart collection
    CollectionReference userCartCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    // Fetch all items in the cart
    QuerySnapshot cartSnapshot = await userCartCollection.get();

    // Extract product IDs from the cart
    List<String> productIds =
        cartSnapshot.docs.map((doc) => doc["id"] as String).toList();

    if (productIds.isEmpty) {
      return [];
    }

    // Fetch product details from the products collection
    CollectionReference productsCollection =
        FirebaseFirestore.instance.collection('products');
    QuerySnapshot productsSnapshot = await productsCollection
        .where(FieldPath.documentId, whereIn: productIds)
        .get();

    // Return the list of product data with "selected" key set to false for each product
    return productsSnapshot.docs.map((doc) {
      Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
      productData['selected'] = false;
      return productData;
    }).toList();
  } catch (e) {
    print('Error fetching user cart products: $e');
    return [];
  }
}
