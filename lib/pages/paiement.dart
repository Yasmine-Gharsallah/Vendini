import 'package:flutter/material.dart';
import 'package:vendini/pages/panier.dart';

class Paiement extends StatelessWidget {
  const Paiement({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaymentScreen(),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod =
      'Paiement à la livraison'; // Option par défaut
  double productPrice = 50.0;
  double shippingCost = 10.0;

  double get total => productPrice + shippingCost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity, // Couvre toute la hauteur
        width: double.infinity, // Couvre toute la largeur
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                const AppBarSection(),
                const SizedBox(height: 20.0),
                ProductInfo(price: productPrice),
                const SizedBox(height: 30.0),
                const Text(
                  'Mode de paiement:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAA2C50),
                  ),
                ),
                PaymentMethod(
                  selectedPaymentMethod: selectedPaymentMethod,
                  onSelect: (String? value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                const DeliveryInfoBox(),
                const SizedBox(height: 20.0),
                const Text(
                  'Localisation',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAA2C50),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF7F1F1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                OrderSummary(
                  productPrice: productPrice,
                  shippingCost: shippingCost,
                  total: total,
                ),
                const SizedBox(height: 30.0),
                const ConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  PanierPage()),
            ); // Navigue explicitement vers la page du panier
          },
        ),
        const SizedBox(width: 10.0),
        const Text(
          'Achat sécurisé',
          style: TextStyle(
            color: Color(0xFFAA2C50),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ProductInfo extends StatelessWidget {
  final double price;

  const ProductInfo({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFBE1E6D),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pyjama d’été - ${price.toStringAsFixed(2)} TND',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage('assets/images/girl.png'),
                  ),
                  SizedBox(width: 8.0),
                  Row(
                    children: [
                      SizedBox(width: 5.0),
                      Text(
                        'Mise en vente par Nour',
                        style: TextStyle(color: Colors.white70, fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              'assets/images/pyjama.png',
              width: 60.0,
              height: 60.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String?> onSelect;

  const PaymentMethod(
      {super.key, required this.selectedPaymentMethod, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Paiement à la livraison'),
          value: 'Paiement à la livraison',
          groupValue: selectedPaymentMethod,
          onChanged: onSelect,
        ),
        RadioListTile<String>(
          title: const Text('Paiement à la carte'),
          value: 'Paiement à la carte',
          groupValue: selectedPaymentMethod,
          onChanged: onSelect,
        ),
      ],
    );
  }
}

class DeliveryInfoBox extends StatelessWidget {
  const DeliveryInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: const Column(
        children: [
          Text(
            'Hey !',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFAA2C50)),
          ),
          SizedBox(height: 8.0),
          Text(
            'Livraison gratuite pour un achat supérieur à x',
            style: TextStyle(fontSize: 16.0, color: Color(0xFF7B3F3F)),
          ),
        ],
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final double productPrice;
  final double shippingCost;
  final double total;

  const OrderSummary(
      {super.key,
      required this.productPrice,
      required this.shippingCost,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE7E5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          _buildRow('Prix', productPrice.toStringAsFixed(2)),
          const Divider(),
          _buildRow('Livraison', shippingCost.toStringAsFixed(2)),
          const Divider(),
          _buildRow('Total à payer', total.toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBE1E6D),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
        child: const Text('Confirmer le paiement',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
