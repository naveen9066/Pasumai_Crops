import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SupplementOrdersPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const SupplementOrdersPage({super.key, required this.onLocaleChange});

  @override
  _SupplementOrdersPageState createState() => _SupplementOrdersPageState();
}

class _SupplementOrdersPageState extends State<SupplementOrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedStatus = 'all'; // Default to 'all' (no filter)

  Future<void> fetchOrders({String status = 'all'}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = dotenv.env['BASE_URL'];
      final response = await http.get(
        Uri.parse('$baseUrl/api/farmer/getallsupplements?status=$status'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> fetchedOrders =
            List.from(responseData['orders'] ?? []);

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

  void updateOrderStatus(String orderId, String status) async {
    if (orderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid order ID')),
      );
      return;
    }

    final baseUrl = dotenv.env['BASE_URL'];
    final response = await http.put(
      Uri.parse('$baseUrl/api/farmer/getallsupplements/$orderId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"status": status}),
    );

    if (response.statusCode == 200) {
      fetchOrders(status: selectedStatus); // Refresh after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch with no filter by default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplement Orders'),
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
      ),
      body: Column(
        children: [
          // Dropdown for Status Filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedStatus,
              onChanged: (newStatus) {
                setState(() {
                  selectedStatus = newStatus!;
                  fetchOrders(
                      status:
                          selectedStatus); // Fetch orders with selected status
                });
              },
              items: [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'ordered', child: Text('Ordered')),
                DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'canceled', child: Text('Canceled')),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : orders.isEmpty
                        ? const Center(
                            child:
                                Text('No orders found for the selected status'))
                        : ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];

                              // Check if supplements is null or not before attempting to decode
                              List<dynamic> supplements = [];
                              if (order['supplements'] != null) {
                                try {
                                  supplements =
                                      json.decode(order['supplements']);
                                } catch (e) {
                                  return ListTile(
                                    title:
                                        const Text("Invalid supplement data"),
                                    subtitle: Text('Error parsing: $e'),
                                  );
                                }
                              }

                              double totalPrice = 0;
                              for (var s in supplements) {
                                final quantity =
                                    double.tryParse(s['quantity'].toString()) ??
                                        0;
                                final price = double.tryParse(
                                        s['per_price'].toString()) ??
                                    0;
                                totalPrice += quantity * price;
                              }

                              final orderId = order['id']?.toString() ?? '';

                              return Card(
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Farmer: ${order['username'] ?? 'Unknown'}'),
                                      Text(
                                          'Address: ${order['address1'] ?? 'Unknown'}'),
                                      const SizedBox(height: 8),
                                      ...supplements.map<Widget>((supplement) {
                                        final quantity = double.tryParse(
                                                supplement['quantity']
                                                    .toString()) ??
                                            0;
                                        final price = double.tryParse(
                                                supplement['per_price']
                                                    .toString()) ??
                                            0;
                                        final subTotal = quantity * price;
                                        return Text(
                                          '${supplement['sup_name']} - ${quantity.toStringAsFixed(0)} x ₹${price.toStringAsFixed(2)} = ₹${subTotal.toStringAsFixed(2)}',
                                        );
                                      }).toList(),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Status: ${order['status']}'),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => updateOrderStatus(
                                                orderId, 'accepted'),
                                            child: const Text('Accept'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => updateOrderStatus(
                                                orderId, 'delivered'),
                                            child: const Text('Delivered'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => updateOrderStatus(
                                                orderId, 'cancelled'),
                                            child: const Text('Cancelled'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                          ),
                                        ],
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
    );
  }
}
