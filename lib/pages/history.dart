import 'dart:ui';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated list of purchases for the example
    final List<Map<String, String>> purchases = [
      {
        'item': 'Armoire',
        'price': '200 TND',
        'date': '22/11/2024',
        'image': 'assets/images/7.png'
      },
      {
        'item': 'Manteau',
        'price': '50 TND',
        'date': '25/11/2024',
        'image': 'assets/images/5.png'
      },
    ];

    final List<Map<String, String>> sales = [
      {
        'item': 'Pyjama',
        'price': '30 TND',
        'date': '28/11/2024',
        'image': 'assets/images/4.png'
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Page content
          SingleChildScrollView( // Added SingleChildScrollView here
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Centered horizontally
                children: [
                  // Row for the back arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Go back to the previous page
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Centered title
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Historique Achat et Vente',
                      textAlign: TextAlign.center, // Centered
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB50D56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), // Space between title and image
                  // Centered image
                  Container(
                    width: 120, // Reduced width for the image
                    height: 120, // Reduced height for the image
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Hist.png'), // Added image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Space between image and list
                  // First blurred part for purchases (reduced in size)
                  Container(
                    height: 250, // Reduced height for the purchases section
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vos Achats',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB50D56),
                                ),
                              ),
                              const SizedBox(height: 16), // Space between title and list
                              // List of purchases with images, prices, and dates
                              Expanded(
                                child: ListView.builder(
                                  itemCount: purchases.length,
                                  itemBuilder: (context, index) {
                                    final purchase = purchases[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(
                                            purchase['image']!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(purchase['item']!),
                                        subtitle: Text(
                                          'Date: ${purchase['date']}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: Text(
                                          purchase['price']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Second blurred part for sales (reduced in size)
                  Container(
                    height: 250, // Reduced height for the sales section
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vos Ventes',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB50D56),
                                ),
                              ),
                              const SizedBox(height: 16), // Space between title and list
                              // List of sales with "Sold"
                              Expanded(
                                child: ListView.builder(
                                  itemCount: sales.length,
                                  itemBuilder: (context, index) {
                                    final sale = sales[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 8),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(
                                            sale['image']!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(sale['item']!),
                                        subtitle: Text(
                                          'Date: ${sale['date']}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: Stack(
                                          children: [
                                            Text(
                                              sale['price']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                color: Colors.red,
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: const Text(
                                                  'Vendu',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
          ),
        ],
      ),
    );
  }
}