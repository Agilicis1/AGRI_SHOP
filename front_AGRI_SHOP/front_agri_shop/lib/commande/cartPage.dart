import 'package:flutter/material.dart';
import 'E-commerce.dart';
import '../homePage.dart';
import 'productModel.dart';
import 'package:front_agri_shop/commande/cartPage.dart';
import 'package:front_agri_shop/commande/paiementPage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _removeItem(CartItem item) {
    setState(() {
      Cart.removeItem(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit supprimé du panier'),
        duration: Duration(seconds:2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = Cart.items.isNotEmpty;
    final total = Cart.items.fold<double>(0, (sum, item) => sum + item.product.price * item.quantity);
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          )
        ],
      ),
      body: Cart.items.isEmpty
          ? Center(child: Text('Votre panier est vide '))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: Cart.items.length,
                    itemBuilder: (context, index) {
                      final item = Cart.items[index];
                      return Card(
                        child: ListTile(
                          leading: (() {
                            final image = item.product.image;
                            if (image.isNotEmpty && (image.startsWith('http://') || image.startsWith('https://'))) {
                              return Image.network(image, height: 40, width: 40, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported));
                            } else if (image.isNotEmpty && (image.startsWith('/') || image.contains(':\\') || image.contains(':/'))) {
                              if (kIsWeb) {
                                return Icon(Icons.image_not_supported, size: 40, color: Colors.grey);
                              } else {
                                return Image.file(File(image), height: 40, width: 40, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported));
                              }
                            } else if (image.isNotEmpty) {
                              return Image.asset(image, height: 40, width: 40, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported));
                            } else {
                              return Container(width: 40, height: 40, color: Colors.grey);
                            }
                          })(),
                          title: Text(item.product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.description),
                              Text('Quantité : ${item.quantity}', style: TextStyle(color: Colors.black)),
                              Text('Prix unitaire : ${item.product.price} FCFA', style: TextStyle(color: Colors.green)),
                              Text('Total : ${item.product.price * item.quantity} FCFA', style: TextStyle(color: Colors.blue)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _removeItem(item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (hasItems)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaiementPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Payer'),
                      ),
                    ),
                  ),
                if (hasItems)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Total panier : $total FCFA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                  ),
              ],
            ),
    );
  }
}
