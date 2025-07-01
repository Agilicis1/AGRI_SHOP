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
  final VoidCallback? onAddToCart;
  const ProductCard({Key? key, required this.product, this.onAddToCart}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int selectedQuantity = 1;
  int _cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    Widget imageWidget;
    imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        getProductImageUrl(product.image),
        height: 150,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 300;
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(child: imageWidget, flex: isMobile ? 2 : 3),
                SizedBox(height: 2),
                Text(
                  product.name.isNotEmpty ? product.name : (product.id ?? 'Produit'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 15 : 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: isMobile ? 9 : 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Boutons -1+
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: isMobile ? 18 : 22),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: selectedQuantity > 1
                              ? () => setState(() => selectedQuantity--)
                              : null,
                        ),
                        Text('$selectedQuantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 12 : 14)),
                        IconButton(
                          icon: Icon(Icons.add, size: isMobile ? 18 : 22),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => setState(() => selectedQuantity++),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Bouton panier à droite
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart, color: Colors.green, size: isMobile ? 18 : 22),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _cartItemCount++;
                        });
                        Cart.items.add(CartItem(product: product, quantity: selectedQuantity));
                        if (widget.onAddToCart != null) {
                          widget.onAddToCart!();
                        }
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${product.price} FCFA',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 12 : 15,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }
  static Future<List<Product>> fetchProductsByPriceAsc() async {
    final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
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
    final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
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

// Fonction utilitaire pour obtenir l'URL complète de l'image produit
String getProductImageUrl(String image) {
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image;
  } else if (image.isNotEmpty) {
    if (image.startsWith('uploads/')) {
      return 'https://agri-shop-5b8y.onrender.com/' + image;
    } else {
      return 'https://agri-shop-5b8y.onrender.com/uploads/' + image;
    }
  } else {
    return 'assets/default.png';
  }
}

File? _selectedImage;
