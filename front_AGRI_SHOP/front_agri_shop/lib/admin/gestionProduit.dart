import 'package:flutter/material.dart';
import 'adminHome.dart';
import 'gestionCommande.dart';
import 'gestionDesClients.dart';
import 'reLoadingImg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../commande/productModel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class GestionDesProduits extends StatefulWidget {
  @override
  State<GestionDesProduits> createState() => _GestionDesProduitsState();
}

class _GestionDesProduitsState extends State<GestionDesProduits> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();
  XFile? _selectedXFile;
  String? _previewNom;
  String? _previewPrix;
  String? _previewDesc;
  String? _previewCategorie;
  final List<String> categories = [
    'Herbicides',
    'Fongicides',
    'Insecticides',
    'Nématicides',
  ];
  String? _selectedCategorie;


  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService.fetchProducts();
  }

  void refreshProducts() {
    setState(() {
      futureProducts = ProductService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des produits'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedXFile != null || _previewNom != null || _previewPrix != null || _previewDesc != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.yellow[50],
                  child: ListTile(
                    leading: _selectedXFile != null
                      ? (kIsWeb
                        ? Image.network(_selectedXFile!.path, height: 60, width: 60, fit: BoxFit.cover)
                        : Image.file(File(_selectedXFile!.path), height: 60, width: 60, fit: BoxFit.cover))
                      : Container(width: 60, height: 60, color: Colors.grey),
                    title: Text(_previewNom ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_previewDesc != null) Text(_previewDesc!),
                        if (_previewPrix != null) Text('${_previewPrix!} FCFA', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: \\${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun produit disponible'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return AdminProductCard(
                        product: product,
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirmer la suppression'),
                              content: Text('Voulez-vous vraiment supprimer ce produit ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final response = await http.delete(
                              Uri.parse('https://agri-shop-5b8y.onrender.com/api/products/${product.id}'),
                              headers: {'Content-Type': 'application/json'},
                            );
                            if (response.statusCode == 200 || response.statusCode == 204) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Produit supprimé'), backgroundColor: Colors.green),
                              );
                              refreshProducts();
                            } else {
                              print('Erreur: \\${response.body}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erreur lors de la suppression'), backgroundColor: Colors.red),
                              );
                            }
                          }
                        },
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final nomController = TextEditingController(text: product.name);
                              final prixController = TextEditingController(text: product.price.toString());
                              final descController = TextEditingController(text: product.description);
                              final imageController = TextEditingController(text: product.image);
                              final quantiteController = TextEditingController(text: product.quantity.toString());
                              final categorieController = TextEditingController(text: product.categorie);
                              return AlertDialog(
                                backgroundColor: Colors.green,
                                title: Text('Modifier le produit', style: TextStyle(color: Colors.white)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nomController,
                                      decoration: InputDecoration(labelText: 'Nom du produit'),
                                    ),
                                    TextField(
                                      controller: prixController,
                                      decoration: InputDecoration(labelText: 'Prix du produit'),
                                    ),
                                    TextField(
                                      controller: descController,
                                      decoration: InputDecoration(labelText: 'Description du produit'),
                                    ),
                                    TextField(
                                      controller: imageController,
                                      decoration: InputDecoration(labelText: 'chemin vers l\'image du produit'),
                                    ),
                                    TextField(
                                      controller: quantiteController,
                                      decoration: InputDecoration(labelText: 'Quantité'),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: _selectedCategorie,
                                      items: categories.map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      )).toList(),
                                      onChanged: (value) => setState(() => _selectedCategorie = value),
                                      decoration: InputDecoration(labelText: 'Catégorie'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final response = await http.put(
                                          Uri.parse('https://agri-shop-5b8y.onrender.com/api/products/${product.id}'),
                                          headers: {'Content-Type': 'application/json'},
                                          body: jsonEncode({
                                            'name': nomController.text,
                                            'price': double.tryParse(prixController.text) ?? 0.0,
                                            'description': descController.text,
                                            'image': imageController.text,
                                            'quantity': int.tryParse(quantiteController.text) ?? 0,
                                            'categorie': categorieController.text,
                                          }),
                                        );
                                        Navigator.pop(context);
                                        if (response.statusCode == 200 || response.statusCode == 204) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Produit modifié'), backgroundColor: Colors.green),
                                          );
                                          refreshProducts();
                                        } else {
                                          print('Erreur: \\${response.body}');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Erreur lors de la modification'), backgroundColor: Colors.red),
                                          );
                                        }
                                      },
                                      child: Text('Enregistrer'),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => StatefulBuilder(
                    builder: (context, setStateDialog) => AlertDialog(
                      backgroundColor: Colors.green,
                      title: Text('Ajouter un produit', style: TextStyle(color: Colors.white)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nomController,
                            decoration: InputDecoration(labelText: 'Nom du produit'),
                            onChanged: (v) => setStateDialog(() => _previewNom = v),
                          ),
                          TextField(
                            controller: prixController,
                            decoration: InputDecoration(labelText: 'Prix du produit'),
                            onChanged: (v) => setStateDialog(() => _previewPrix = v),
                          ),
                          TextField(
                            controller: descController,
                            decoration: InputDecoration(labelText: 'Description du produit'),
                            onChanged: (v) => setStateDialog(() => _previewDesc = v),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedCategorie,
                            items: categories.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            )).toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                _selectedCategorie = value;
                                _previewCategorie = value;
                              });
                            },
                            decoration: InputDecoration(labelText: 'Catégorie'),
                          ),
                          ElevatedButton(
                            onPressed: () async{
                              final ImagePicker? _picker = ImagePicker();
                              final XFile? image = await _picker?.pickImage(source: ImageSource.gallery);
                              if (image != null){
                                setState(() {
                                  _selectedXFile = image;
                                });
                                setStateDialog(() {});
                              }
                            },
                            child: Text('Uploader une image'),
                          ),
                          if (_selectedXFile != null) ...[
                            SizedBox(height: 12),
                            kIsWeb
                              ? Image.network(_selectedXFile!.path, height: 100)
                              : Image.file(File(_selectedXFile!.path), height: 100),
                          ],
                          ElevatedButton(
                            onPressed: () async {
                              String nom = nomController.text;
                              String prix = prixController.text;
                              String desc = descController.text;
                              String quantite = '1';
                              if (_selectedXFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Veuillez sélectionner une image'), backgroundColor: Colors.red),
                                );
                                return;
                              }

                              if (_selectedCategorie == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Veuillez sélectionner une catégorie'), backgroundColor: Colors.red),
                                );
                                return;
                              }

                              // Vérifier que tous les champs sont remplis
                              if (nom.isEmpty || prix.isEmpty ) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('nom ou prix manquant'), backgroundColor: Colors.red),
                                );
                                return;
                              }

                              bool success = await createProductWithImageUniversal(
                                name: nom,
                                price: prix,
                                description: desc,
                                quantity: quantite,
                                imageFile: _selectedXFile!,
                                context: context,
                                categorie: _selectedCategorie!,
                              );

                              if (success) {
                                // Réinitialiser les champs
                                setState(() {
                                  _selectedXFile = null;
                                  _previewNom = null;
                                  _previewPrix = null;
                                  _previewDesc = null;
                                  nomController.clear();
                                  prixController.clear();
                                  descController.clear();
                                  categorieController.clear();
                                });

                                // Fermer la boîte de dialogue
                                Navigator.pop(context);

                                // Afficher le message de succès
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Produit ajouté avec succès'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Rafraîchir la liste des produits
                                refreshProducts();

                                // Attendre un peu pour s'assurer que la liste est mise à jour
                                await Future.delayed(Duration(milliseconds: 500));
                                refreshProducts();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur lors de l\'ajout du produit'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text('Ajouter'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Text('Créer un produit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AdminProductCard({Key? key, required this.product, required this.onDelete, required this.onEdit}) : super(key: key);

  @override
  State<AdminProductCard> createState() => _AdminProductCardState();
}

class _AdminProductCardState extends State<AdminProductCard> {
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (widget.product.image.isNotEmpty && (widget.product.image.startsWith('http://') || widget.product.image.startsWith('https://'))) {
      imageWidget = Image.network(
        getProductImageUrl(widget.product.image),
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
      );
    } else if (widget.product.image.isNotEmpty && (widget.product.image.startsWith('/') || widget.product.image.contains(':\\') || widget.product.image.contains(':/'))) {
      if (kIsWeb) {
        imageWidget = Icon(Icons.image_not_supported, size: 60, color: Colors.grey);
      } else {
        imageWidget = Image.file(
          File(widget.product.image),
          height: 60,
          width: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
        );
      }
    } else if (widget.product.image.isNotEmpty) {
      imageWidget = Image.network(
        getProductImageUrl(widget.product.image),
        height: 60,
        width: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
      );
    } else {
      imageWidget = Container(width: 60, height: 60, color: Colors.grey);
    }
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: imageWidget,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(widget.product.description),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${widget.product.price} FCFA',
                              style: TextStyle(
                                color: Colors.green[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Stock : ${widget.product.quantity}',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> createProductWithImage({
  required String name,
  required String price,
  required String description,
  required String quantity,
  required File imageFile,
  required BuildContext context,
}) async {
  try {
    // L'URL d'upload est correcte, le backend doit enregistrer uniquement le chemin relatif (uploads/xxx.jpg)
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'),
    );
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['description'] = description;
    request.fields['quantity'] = quantity;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    var response = await request.send();
    if (response.statusCode == 201) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création du produit (code ${response.statusCode})'), backgroundColor: Colors.red),
      );
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur lors de l\'upload : $e'), backgroundColor: Colors.red),
    );
    return false;
  }
}

Future<bool> createProductWithImageUniversal({
  required String name,
  required String price,
  required String description,
  required String quantity,
  required XFile imageFile,
  required BuildContext context,
  required String categorie,
}) async {
  try {
    final dio = Dio();
    FormData formData;
    if (kIsWeb) {
      final bytes = await imageFile.readAsBytes();
      formData = FormData.fromMap({
        'name': name,
        'price': double.parse(price),
        'description': description,
        'quantity': int.parse(quantity),
        'categorie': categorie,
        'image': MultipartFile.fromBytes(
          bytes,
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      });
    } else {
      formData = FormData.fromMap({
        'name': name,
        'price': double.parse(price),
        'description': description,
        'quantity': int.parse(quantity),
        'categorie': categorie,
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      });
    }

    // L'URL d'upload est correcte, le backend doit enregistrer uniquement le chemin relatif (uploads/xxx.jpg)
    print('Envoi des données du produit: ${formData.fields}');

    final response = await dio.post(
      'https://agri-shop-5b8y.onrender.com/api/products',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    print('Réponse du serveur: ${response.statusCode} - ${response.data}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final verifyResponse = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
      if (verifyResponse.statusCode == 200) {
        List<dynamic> products = json.decode(verifyResponse.body);
        final newProduct = products.firstWhere(
          (p) => p['name'] == name,
          orElse: () => null,
        );
        
        if (newProduct != null) {
          print('Produit créé avec succès: $newProduct');
          return true;
        }
      }
    }
    
    print('Erreur lors de la création du produit (code ${response.statusCode})');
    print('Réponse du serveur: ${response.data}');
    return false;
  } catch (e) {
    print('Erreur lors de l\'upload : $e');
    return false;
  }
}

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product(
        id: item['_id'] ?? '',
        name: item['name'] ?? '',
        description: item['description'] ?? '',
        image: item['image'] ?? 'assets/default.png',
        price: item['price'] != null ? double.tryParse(item['price'].toString()) ?? 0.0 : 0.0,
        quantity: item['quantity'] != null ? int.tryParse(item['quantity'].toString()) ?? 0 : 0,
        categorie: item['categorie'] != null ? item['categorie'] : 'Général',
      )).toList();
    } else {
      throw Exception('Erreur lors du chargement des produits');
    }
  }
}

// Fonction utilitaire pour obtenir l'URL complète de l'image produit (comme dans e-commerce)
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




    
