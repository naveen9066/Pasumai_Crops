import '../farmer/orderslisting.dart';
import '../farmer/checkout_page.dart';
import 'package:flutter/material.dart';

class SupplementsPage extends StatefulWidget {
  const SupplementsPage({super.key});

  @override
  State<SupplementsPage> createState() => _SupplementsPageState();
}

class _SupplementsPageState extends State<SupplementsPage> {
  final Map<String, List<Map<String, dynamic>>> products = {
    'Seeds': [
      {
        "name": "Tomato Seed",
        "price": 50,
        "image": "images/suppliments/tomato_seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Ash gourd seed",
        "price": 30,
        "image": "images/suppliments/ash-gourd-seeds.jpg",
        "quantity": 0,
      },
      {
        "name": "Beetroot Seed",
        "price": 20,
        "image": "images/suppliments/beetroot-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Bitter gourd Seed",
        "price": 25,
        "image": "images/suppliments/bitter-gourd-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Bottle gourd Seed",
        "price": 25,
        "image": "images/suppliments/bottle-gourd-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Brinjal Seed",
        "price": 25,
        "image": "images/suppliments/brinjal-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Cabbage Seed",
        "price": 25,
        "image": "images/suppliments/cabbage-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Cauliflower Seed",
        "price": 25,
        "image": "images/suppliments/cauliflower-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Corriander Seed",
        "price": 25,
        "image": "images/suppliments/coriander-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Cucumber Seed",
        "price": 25,
        "image": "images/suppliments/cucumber-seeds.jpg",
        "quantity": 0,
      },
      {
        "name": "Drumstick Seed",
        "price": 25,
        "image": "images/suppliments/drumstick-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "French beans Seed",
        "price": 25,
        "image": "images/suppliments/french-beans-seeds.jpg",
        "quantity": 0,
      },
      {
        "name": "Lady finger Seed",
        "price": 25,
        "image": "images/suppliments/okra-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Pole beans Seed",
        "price": 25,
        "image": "images/suppliments/Pole-beans-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Pumpkin Seed",
        "price": 25,
        "image": "images/suppliments/pumpkin-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Ridge gourd Seed",
        "price": 25,
        "image": "images/suppliments/ridge-gourd-seed.jpg",
        "quantity": 0,
      },
      {
        "name": "Snack gourd Seed",
        "price": 25,
        "image": "images/suppliments/snake-gourd-seed.jpg",
        "quantity": 0,
      },
    ],
    'Vegetables': [
      {
        "name": "Tomato",
        "price": 30,
        "image": "images/marketinfo/tomato.jpg",
        "quantity": 0,
      },
      {
        "name": "Onion",
        "price": 40,
        "image": "images/suppliments/onion-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Potato",
        "price": 35,
        "image": "images/suppliments/pototo-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Carrot",
        "price": 50,
        "image": "images/suppliments/carrot-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Beans",
        "price": 80,
        "image": "images/suppliments/beans-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Cabbage",
        "price": 25,
        "image": "images/suppliments/cabbage-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Cauliflower",
        "price": 30,
        "image": "images/suppliments/cauliflower-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Brinjal",
        "price": 25,
        "image": "images/suppliments/brinjal-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Cucumber",
        "price": 15,
        "image": "images/suppliments/Cucumber-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Drumstick",
        "price": 90,
        "image": "images/suppliments/drumstick-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Bitter Gourd",
        "price": 35,
        "image": "images/suppliments/bitter-gourd-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Snake Gourd",
        "price": 30,
        "image": "images/suppliments/snake-gourd-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Ridge Gourd",
        "price": 28,
        "image": "images/suppliments/ridge-gourd-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Bottle Gourd",
        "price": 22,
        "image": "images/suppliments/bottle-gourd-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Ladies Finger",
        "price": 40,
        "image": "images/suppliments/okra-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Chayote",
        "price": 20,
        "image": "images/suppliments/Chayote-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Radish",
        "price": 25,
        "image": "images/suppliments/radish-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Turnip",
        "price": 28,
        "image": "images/suppliments/turnip-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Spinach",
        "price": 18,
        "image": "images/suppliments/spinach-veg.jpg",
        "quantity": 0
      },
      {
        "name": "Green Peas",
        "price": 60,
        "image": "images/suppliments/green-pea-veg.jpg",
        "quantity": 0
      }
    ],
    'Fertilizer': [
      {
        "name": "Organic Fertilizer",
        "price": 100,
        "image": "images/suppliments/organic_fertilizer.jpg",
        "quantity": 0,
      },
      {
        "name": "Calcium Nitrate",
        "price": 279,
        "image": "images/suppliments/product-2.jpg",
        "quantity": 0,
      },
      {
        "name": "Epsom Salt",
        "price": 259,
        "image": "images/suppliments/product-3.jpg",
        "quantity": 0,
      },
      {
        "name": "Ferrous Sulphate",
        "price": 199,
        "image": "images/suppliments/product-4.jpg",
        "quantity": 0,
      },
      {
        "name": "Potassium Fulvate",
        "price": 870,
        "image": "images/suppliments/product-5.jpg",
        "quantity": 0,
      },
      {
        "name": "NPK 19:19:19",
        "price": 174,
        "image": "images/suppliments/product-6.jpg",
        "quantity": 0,
      },
      {
        "name": "NPK 20:20:20",
        "price": 171,
        "image": "images/suppliments/product-7.jpg",
        "quantity": 0,
      },
      {
        "name": "NPK 13:40:13",
        "price": 247,
        "image": "images/suppliments/product-8.jpg",
        "quantity": 0,
      },
      {
        "name": "Zinc Sulphate",
        "price": 192,
        "image": "images/suppliments/product-9.jpg",
        "quantity": 0,
      },
      {
        "name": "Boron 10%",
        "price": 1015,
        "image": "images/suppliments/product-10.jpg",
        "quantity": 0,
      },
      {
        "name": "Silicon Fertilizer",
        "price": 499,
        "image": "images/suppliments/product-11.jpg",
        "quantity": 0,
      },
      {
        "name": "Zinc Oxide 39.5% SC",
        "price": 724,
        "image": "images/suppliments/product-12.jpg",
        "quantity": 0,
      },
      {
        "name": "Potassium Humate Flakes",
        "price": 229,
        "image": "images/suppliments/product-13.jpg",
        "quantity": 0,
      },
      {
        "name": "Sulphur Bentonite",
        "price": 42,
        "image": "images/suppliments/product-14.jpg",
        "quantity": 0,
      },
      {
        "name": "Seaweed Extract",
        "price": 327,
        "image": "images/suppliments/product-15.jpg",
        "quantity": 0,
      },
      {
        "name": "Micronutrient Mix",
        "price": 756,
        "image": "images/suppliments/product-16.jpg",
        "quantity": 0,
      },
      {
        "name": "NPK Abhimanyu Navratan",
        "price": 270,
        "image": "images/suppliments/product-17.jpg",
        "quantity": 0,
      },
      {
        "name": "Super Potassium Humate",
        "price": 90,
        "image": "images/suppliments/product-18.jpg",
        "quantity": 0,
      },
      {
        "name": "Magnesium Sulphate",
        "price": 35,
        "image": "images/suppliments/product-19.jpg",
        "quantity": 0,
      },
      {
        "name": "Copper Sulphate",
        "price": 145,
        "image": "images/suppliments/product-20.jpg",
        "quantity": 0,
      },
    ],
  };

  String selectedCategory = 'Seeds'; // Default category
  double totalPrice = 0.0;
  final List<Map<String, dynamic>> cartItems = [];

  void calculateTotalPrice() {
    totalPrice = 0.0;
    cartItems.forEach((item) {
      totalPrice += item['price'] * item['quantity'];
    });
    setState(() {});
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      bool itemExists = false;
      for (var item in cartItems) {
        if (item['name'] == product['name']) {
          item['quantity']++;
          itemExists = true;
          break;
        }
      }
      if (!itemExists) {
        cartItems.add({
          'name': product['name'],
          'price': product['price'],
          'quantity': 1,
        });
      }
    });
    calculateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 192, 255, 202),
        title: const Text('Supplements', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart,
                    color: Color.fromARGB(255, 249, 249, 249)),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartItems.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return CartPage(cartItems: cartItems, totalPrice: totalPrice);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrdersListingPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                categoryButton(context, 'Seeds'),
                categoryButton(context, 'Vegetables'),
                categoryButton(context, 'Fertilizer'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: products[selectedCategory]!.length,
              itemBuilder: (context, index) {
                final product = products[selectedCategory]![index];
                return buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                product['image'],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text('₹${product['price']}',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 13, 14, 13))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (product['quantity'] > 0) product['quantity']--;
                        });
                        calculateTotalPrice();
                      },
                    ),
                    Text(product['quantity'].toString(),
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () {
                        setState(() {
                          product['quantity']++;
                        });
                        calculateTotalPrice();
                      },
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    addToCart(product);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                  child: const Text('Add to Cart',
                      style: TextStyle(color: Color.fromARGB(255, 15, 15, 15))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(BuildContext context, String category) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: selectedCategory == category
              ? Colors.green
              : const Color.fromARGB(255, 14, 14, 14),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: selectedCategory == category
            ? Colors.green.withOpacity(0.1)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: selectedCategory == category
              ? Colors.green
              : const Color.fromARGB(255, 14, 14, 14),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CartPage(
      {super.key, required this.cartItems, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Cart',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('₹${item['price']}'),
                );
              },
            ),
          ),
          const Divider(),
          Text(
            'Total: ₹$totalPrice',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(
                    cartItems: cartItems,
                    totalPrice: totalPrice,
                  ),
                ),
              );
            },
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}
