import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersListingPage extends StatefulWidget {
  const OrdersListingPage({super.key});

  @override
  _OrdersListingPageState createState() => _OrdersListingPageState();
}

class _OrdersListingPageState extends State<OrdersListingPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String errorMessage = '';

  // Fetch orders from the API
  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final farmerId = prefs.getString('farmer_id');
      final baseUrl = dotenv.env['BASE_URL'];
      final response = await http
          .get(Uri.parse('$baseUrl/api/farmer/getsupplements/$farmerId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> fetchedOrders = List.from(
            responseData['orders']); // Extract 'orders' from the response

        // Sort orders so that "ordered" status comes first
        fetchedOrders.sort((a, b) {
          if (a['status'] == 'ordered') return -1;
          if (b['status'] == 'ordered') return 1;
          return 0;
        });

        setState(() {
          orders = fetchedOrders;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load orders';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Call the API when the page is loaded
  }

  // Method to show the order details in a dialog
  void showOrderDetailsDialog(Map<String, dynamic> order) {
    final List<dynamic> supplements =
        json.decode(order['supplements']); // Decode supplements JSON

    // Calculate total price
    double totalPrice = 0;
    supplements.forEach((supplement) {
      totalPrice += double.parse(supplement['quantity']) *
          double.parse(supplement['per_price']);
    });

    // Show dialog with order details
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Farmer: ${order['username']}'),
                Text('Status: ${order['status'] ?? 'Not available'}'),
                Text('Address: ${order['address1']}'),
                SizedBox(height: 10),
                Text('Supplements:'),
                ...supplements.map((supplement) {
                  return Text(
                    '${supplement['sup_name']} - ${supplement['quantity']} x ₹${supplement['per_price']} = ₹${(double.parse(supplement['quantity']) * double.parse(supplement['per_price'])).toStringAsFixed(2)}',
                  );
                }).toList(),
                SizedBox(height: 10),
                Text('Total Price: ₹${totalPrice.toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Listing'),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    // Decode supplements to calculate total price
                    final List<dynamic> supplements = json.decode(
                        order['supplements']); // Decode supplements JSON
                    double totalPrice = 0;
                    supplements.forEach((supplement) {
                      totalPrice += double.parse(supplement['quantity']) *
                          double.parse(supplement['per_price']);
                    });

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Order #${index + 1}'),
                          subtitle: Text(
                              'Status: ${order['status'] ?? 'Not available'}'),
                          trailing: Text('₹${totalPrice.toStringAsFixed(2)}'),
                          onTap: () {
                            // Show order details in a dialog
                            showOrderDetailsDialog(order);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
