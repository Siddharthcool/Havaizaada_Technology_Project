import 'package:flutter/material.dart';
import 'package:frontend/model/model.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cartItems;
  final Function(List<Product>) onCartUpdated;  // Callback to update cart in HomePage

  const CartScreen({required this.cartItems, required this.onCartUpdated});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Function to increase the quantity of an item
  void increaseQuantity(Product product) {
    setState(() {
      product.quantity++;  // Increase quantity by 1
    });
    widget.onCartUpdated(widget.cartItems);  // Notify the HomePage to update the cart
  }

  // Function to decrease the quantity of an item
  void decreaseQuantity(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;  // Decrease quantity by 1, but not below 1
      }
    });
    widget.onCartUpdated(widget.cartItems);  // Notify the HomePage to update the cart
  }

  // Function to remove the item from the cart entirely
  void removeItem(Product product) {
    setState(() {
      widget.cartItems.remove(product);  // Remove the product from the cart
    });
    widget.onCartUpdated(widget.cartItems);  // Notify the HomePage to update the cart
  }

  // Function to handle the buy now action
  void proceedToBuy() {
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    // Navigate to a new screen (for example, a confirmation screen)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Confirmation"),
          content: Text("Your total amount is ₹${totalAmount.toStringAsFixed(2)}.\nProceed with the purchase."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Function for Checkout action (simulated)
  void checkout() {
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    // You can trigger further logic here like payment gateway, order processing, etc.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Checkout"),
          content: Text("Proceeding with checkout...\nTotal: ₹${totalAmount.toStringAsFixed(2)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog and proceed to checkout
              },
              child: Text("Confirm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total amount by summing the price * quantity for each item
    double totalAmount = widget.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: Colors.pink[50], // Light pink background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Set app bar height
        child: AppBar(
          backgroundColor: Colors.pink[50],
          centerTitle: true,  // Centers the title
          title: Text("Cart"),
        ),
      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 150, // Set a fixed height for all item containers
                          decoration: BoxDecoration(
                            color: Colors.white, // White background for the item container
                            borderRadius: BorderRadius.circular(12), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Image Section
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item.thumbnail,
                                  width: 100,  // Adjusted image width for better visibility
                                  height: 100,
                                  fit: BoxFit.cover,  // Ensures image doesn't get distorted
                                ),
                              ),
                              SizedBox(width: 10),
                              // Text and Price Section
                              Expanded(  // Added Expanded widget to make sure it takes up available space
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,  // To prevent overflow
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "₹${item.price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "${item.quantity} item(s)",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Quantity Buttons Section
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(  // Added Row to display the "-" and "+" buttons horizontally
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          decreaseQuantity(item);
                                        },
                                      ),
                                      Text(
                                        "${item.quantity}",  // Display quantity between "-" and "+"
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          increaseQuantity(item);
                                        },
                                      ),
                                    ],
                                  ),
                                  // Show delete icon when quantity is 1
                                  if (item.quantity == 1)
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        removeItem(item); // Remove the item from cart
                                      },
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Display the total amount
                      Text(
                        "Total: ₹${totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // Checkout Button aligned to the right
                      ElevatedButton(
                        onPressed: checkout,  // Trigger checkout action
                        child: Text("Checkout", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,  // Button color
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
