class Product {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  int quantity;  // Add quantity field to track the number of items in the cart

  Product({required this.id, required this.title, required this.thumbnail, required this.price, this.quantity = 1});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: json['price'].toDouble(),
      quantity: 1,  // Default quantity is 1
    );
  }
}
