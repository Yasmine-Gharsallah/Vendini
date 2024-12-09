import 'package:flutter/material.dart';

class Vendeur extends StatelessWidget {
  const Vendeur({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductPage(),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          ListView( // Use ListView for scrolling
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: [
              // Top bar with centered user information
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // Back button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Centered user information
                      Column(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/girl.png'),
                            radius: 25,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Nour Vendini",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return const Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 151, 116, 14),
                                size: 16,
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              // Title "En Promotion"
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "En Promotion",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Products section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                    children: [
                      _buildProductCard("Pyjama", "30 TND", 'assets/images/4.png'),
                      _buildProductCard("Pyjama", "50 TND", 'assets/images/8.png'),
                      _buildProductCard("Robe chemise", "95 TND", 'assets/images/9.png'),
                      _buildProductCard("Pyjama bébé", "25 TND", 'assets/images/10.png'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Center(
                child: Text(
                  "Code Promo: NSupCom",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 227, 144, 103),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sold products section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSoldProductCard('assets/images/11.png'),
                      _buildSoldProductCard('assets/images/12.png'),
                      _buildSoldProductCard('assets/images/13.png'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Contact: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "+216 52 237 915",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 113, 13, 41)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoldProductCard(String imagePath) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 160,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // "Sold" label
        Positioned(
          top: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              "Vendu",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}