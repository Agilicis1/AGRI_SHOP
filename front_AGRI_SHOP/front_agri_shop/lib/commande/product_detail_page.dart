import 'package:flutter/material.dart';
import 'productModel.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int selectedKg = 1;
  final List<int> kgOptions = [1, 5, 9, 10];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.green),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.green),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Image produit
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: product.image.isNotEmpty
                  ? (product.image.startsWith('http://') || product.image.startsWith('https://'))
                      ? Image.network(product.image, height: 180, fit: BoxFit.contain)
                      : Image.asset(product.image, height: 180, fit: BoxFit.contain)
                  : Container(height: 180, width: 180, color: Colors.grey[200], child: Icon(Icons.image, size: 60, color: Colors.grey)),
            ),
          ),
          SizedBox(height: 16),
          // Sélecteur de quantité
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: kgOptions.map((kg) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text('$kg Kg'),
                selected: selectedKg == kg,
                selectedColor: Colors.green,
                onSelected: (_) => setState(() => selectedKg = kg),
              ),
            )).toList(),
          ),
          SizedBox(height: 16),
          // Nom, prix, promo
          Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          SizedBox(height: 4),
          Row(
            children: [
              Text('${product.price} FCFA', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(width: 12),
              if (product.price < 2000)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('50% OFF', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(product.description, style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 16),
          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {/* Ajouter au panier */},
                  child: Text('Go to cart'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {/* Acheter maintenant */},
                  child: Text('Buy Now', style: TextStyle(color: Colors.green)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Détails produit
          Text('Product Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text(
            'Ce produit est idéal pour vos cultures. Utilisation simple et efficace. Livraison rapide garantie.',
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 16),
          // Livraison
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.green),
                SizedBox(width: 8),
                Text('Delivery in 1 within Hour', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Actions secondaires
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.view_module, color: Colors.green),
                label: Text('View Similar', style: TextStyle(color: Colors.green)),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.compare_arrows, color: Colors.green),
                label: Text('Add to Compare', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Produits similaires (placeholder)
          Text('Similar To', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          Container(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemBuilder: (context, index) => Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Center(child: Text('Produit ${index + 1}')),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 