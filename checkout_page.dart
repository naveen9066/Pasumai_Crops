import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> _placeOrder() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final farmerId = prefs.getString('farmer_id');
    final baseUrl = dotenv.env['BASE_URL'];

    List<Map<String, dynamic>> supplementsList = widget.cartItems.map((item) {
      return {
        "sup_name": item['name'],
        "quantity": item['quantity'].toString(),
        "per_price": item['price'].toString(),
      };
    }).toList();

    final Map<String, dynamic> requestBody = {
      "farmerid": farmerId,
      "username": usernameController.text,
      "phoneno": phoneController.text,
      "address1": addressController.text,
      "supplements": supplementsList,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/farmer/supplements'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // 🥳 Order placed successfully
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderConfirmedPage(),
          ),
        );
      } else {
        // ❌ Show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your Cart:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('₹${item['price']}'),
                  );
                },
              ),
              const Divider(),
              Text('Total Price: ₹${widget.totalPrice}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Enter Your Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 157, 236, 160),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Place Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🎉 Order Confirmed Page
class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to home after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/gif/orderconfirmed.gif',
                width: 250), // 📸 Your gif path
            const SizedBox(height: 20),
            const Text(
              'Order Confirmed!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            // Removed "Back to Home" button as the automatic navigation will occur
          ],
        ),
      ),
    );
  }
}
