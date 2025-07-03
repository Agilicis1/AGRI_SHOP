import 'package:flutter/material.dart';
import '/homePage.dart';
import 'cartPage.dart';
import 'productModel.dart' as prod;
import 'package:http/http.dart' as http;
import 'notificationModel.dart';

class ECommerce extends StatefulWidget {
  @override
  _ECommerceState createState() => _ECommerceState();
}

class _ECommerceState extends State<ECommerce> {
  late Future<List<prod.Product>> futureProducts;
  int _selectedSort = 0; 
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<prod.Product> _allProducts = [];
  String? _selectedCategoryLabel;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    futureProducts = prod.ProductService.fetchProducts();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _refreshProducts() async {
    setState(() {
      futureProducts = prod.ProductService.fetchProducts();
    });
  }


  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.eco, 'label': 'Herbicides'},
    {'icon': Icons.local_florist, 'label': 'Fongicides'},
    {'icon': Icons.bug_report, 'label': 'Insecticides'},
    {'icon': Icons.spa, 'label': 'Nématicides'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('AGRI_SHOP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            width: 180,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.green),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                  setState(() {
                    _cartItemCount = prod.Cart.items.length;
                  });
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _showSortDialog,
                  icon: Icon(Icons.sort),
                  label: Text('Trier'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategoryLabel == cat['label'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedCategoryLabel == cat['label']) {
                                _selectedCategoryLabel = null; 
                              } else {
                                _selectedCategoryLabel = cat['label'];
                              }
                            });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: isSelected ? Colors.green : Colors.green.withOpacity(0.1),
                                child: Icon(cat['icon'], color: isSelected ? Colors.white : Colors.green),
                              ),
                              SizedBox(height: 4),
                              Text(cat['label'], style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.green : Colors.black)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grille de produits
          Expanded(
            child: FutureBuilder<List<prod.Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun produit disponible'));
                }
                final products = snapshot.data ?? [];
                _allProducts = products;
                List<prod.Product> filteredProducts = _allProducts;
                if (_selectedCategoryLabel != null) {
                  filteredProducts = filteredProducts.where((p) => p.categorie == _selectedCategoryLabel).toList();
                }
                if (_searchText.isNotEmpty) {
                  filteredProducts = filteredProducts.where((p) => p.name.toLowerCase().contains(_searchText)).toList();
                }
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    padding: EdgeInsets.all(12),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return prod.ProductCard(
                        product: filteredProducts[index],
                        onAddToCart: () {
                          setState(() {
                            _cartItemCount++;
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() async {
    int tempValue = _selectedSort; // Utilise la valeur actuelle

    int? selectedValue = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Trier par prix'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    value: 1,
                    groupValue: tempValue,
                    title: Text('Prix croissant'),
                    onChanged: (value) {
                      setStateDialog(() {
                        tempValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    value: 2,
                    groupValue: tempValue,
                    title: Text('Prix décroissant'),
                    onChanged: (value) {
                      setStateDialog(() {
                        tempValue = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    value: 0,
                    groupValue: tempValue,
                    title: Text('Aucun tri'),
                    onChanged: (value) {
                      setStateDialog(() {
                        tempValue = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(tempValue),
                  child: Text('Valider'),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedValue != null) {
      setState(() {
        _selectedSort = selectedValue; // Mémorise le choix
        if (_selectedSort == 1) {
          futureProducts = prod.ProductService.fetchProductsByPriceAsc();
        } else if (_selectedSort == 2) {
          futureProducts = prod.ProductService.fetchProductsByPriceDesc();
        } else {
          futureProducts = prod.ProductService.fetchProducts();
        }
      });
    }
  }
}