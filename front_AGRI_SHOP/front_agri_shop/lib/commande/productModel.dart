import 'package:flutter/material.dart';
import 'package:front_agri_shop/commande/cartPage.dart';
import 'package:front_agri_shop/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:front_agri_shop/admin/gestionProduit.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int quantity;
  final String categorie;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.quantity,
    required this.categorie,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? 'assets/default.png',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      quantity: json['quantity'] != null ? int.tryParse(json['quantity'].toString()) ?? 0 : 0,
      categorie: json['categorie'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
      'categorie': categorie,
    };
  }
}

class CartItem {
    final Product product;
    int quantity;

    CartItem({required this.product, required this.quantity});

    Map<String, dynamic> toJson() {
      return {
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
        'categorie': product.categorie,
      };
    }
    Map<String, dynamic> toJsonWithPayment(String phone, String modepayement) {
      return {
        'productId': product.id,
        'name': product.name,
        'quantity': quantity,
        'price': product.price,
        'phone': phone,
        'modepayement': modepayement,
      };
    }
}

class Cart {
    static List<CartItem> items = [];

    static void addItem(Product product) {
        final cartItem = CartItem(product: product, quantity: 1);
        items.add(cartItem);
    }
    
    static void removeItem(CartItem item) {
        items.remove(item);
    }

    static void clear() {
        items.clear();
    }
}

class CartService {
    static void addItem(Product product) {
        Cart.addItem(product);
    }
}

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    Widget imageWidget;
    if (product.image.isNotEmpty && (product.image.startsWith('http://') || product.image.startsWith('https://'))) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          product.image,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 150),
        ),
      );
    } else if (product.image.isNotEmpty && (product.image.startsWith('/') || product.image.contains(':\\') || product.image.contains(':/'))) {
      if (kIsWeb) {
        imageWidget = Icon(Icons.image_not_supported, size: 150, color: Colors.grey);
      } else {
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(product.image),
            height: 100,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 150),
          ),
        );
      }
    } else if (product.image.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          product.image,
          height: 150,
          width: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 150),
        ),
      );
    } else {
      imageWidget = Container(width: 100, height: 100, color: Colors.grey[200], child: Icon(Icons.image, size: 40, color: Colors.grey));
    }
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            SizedBox(height: 8),
            Text(
              product.name.isNotEmpty ? product.name : (product.id ?? 'Produit'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              product.description,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product.price} FCFA',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantité :', style: TextStyle(fontSize: 14)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: selectedQuantity > 1
                          ? () => setState(() => selectedQuantity--)
                          : null,
                    ),
                    Text('$selectedQuantity', style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => setState(() => selectedQuantity++),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.green),
                  onPressed: () {
                    Cart.items.add(CartItem(product: product, quantity: selectedQuantity));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} x$selectedQuantity ajouté au panier'), backgroundColor: Colors.green),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }
  static Future<List<Product>> fetchProductsByPriceAsc() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/products'));
    if (response.statusCode == 200) {
      List<Product> products = (json.decode(response.body) as List)
          .map((item) => Product.fromJson(item))
          .toList();
      products.sort((a, b) => a.price.compareTo(b.price));
      return products;
    } else if (response.statusCode == 404) {
      throw Exception('Aucun produit trouvé');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur server');
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }
  static Future<List<Product>> fetchProductsByPriceDesc() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/products'));
    if (response.statusCode == 200) {
      List<Product> products = (json.decode(response.body) as List)
          .map((item) => Product.fromJson(item))
          .toList();
      products.sort((a, b) => b.price.compareTo(a.price));
      return products;
    } else if (response.statusCode == 404) {
      throw Exception('Aucun produit trouvé');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur server');
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }
}
File? _selectedImage;
