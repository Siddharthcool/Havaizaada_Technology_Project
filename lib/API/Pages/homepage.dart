import 'package:flutter/material.dart';
import 'package:frontend/API/Pages/cartScreen.dart';  // Assuming CartScreen is in 'Pages' folder
import 'package:frontend/API/api.dart';
import 'package:frontend/model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A list to hold products in the cart
  List<Product> cartItems = [];

  // Function to add an item to the cart
  void addToCart(Product product) {
    setState(() {
      cartItems.add(product);
    });
  }

  // Function to calculate the total quantity of items in the cart
  int getTotalItems() {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Function to update the cart when returning from CartScreen
  void updateCart(List<Product> updatedCart) {
    setState(() {
      cartItems = updatedCart;  // Update the cart with the new items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: Center(child: Text("Catalogue")),
        actions: [
          // Cart Icon with Notification Badge
          Stack(
            clipBehavior: Clip.none, // Allows stacking outside the bounds
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, size: 34),
                onPressed: () {
                  // Navigate to the Cart Screen and pass cartItems and updateCart function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cartItems: cartItems,
                        onCartUpdated: updateCart, // Pass the callback
                      ),
                    ),
                  );
                },
              ),
              if (getTotalItems() > 0) // Only show the badge if there are items in the cart
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 0,
                    ),
                    child: Text(
                      getTotalItems().toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(), // Fetch products from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products available"));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        product.thumbnail,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("\$${product.price.toStringAsFixed(2)}"),
                      ),
                      // Add to Cart Button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            addToCart(product); // Add the product to the cart
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink[50], // Light pink background
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text("Add to Cart"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
