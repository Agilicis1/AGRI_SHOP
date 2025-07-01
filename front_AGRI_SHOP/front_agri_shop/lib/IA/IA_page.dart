import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_agri_shop/commande/productModel.dart';
import 'package:front_agri_shop/commande/cartPage.dart';

class IA_page extends StatefulWidget {
  @override
  State<IA_page> createState() => _IA_pageState();
}

class _IA_pageState extends State<IA_page> {
  String? fileName;
  String? filePath;
  Uint8List? imageBytes;
  String? result;
  bool loading = false;
  List<String> productNames = [];
  bool productsLoaded = false;
  @override
  void initState() {
    super.initState();
    loadProductNames();
  }

  Future<void> loadProductNames() async {
    try {
      final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          productNames = data.map((item) => item['name'].toString().toLowerCase()).toList();
          productsLoaded = true;
        });
        print('Noms des produits chargés: $productNames');
      }
    } catch (e) {
      print('Erreur lors du chargement des noms de produits: $e');
    }
  }

  bool isProductAvailable(String productName) {
    if (!productsLoaded) return false;
    return productNames.any((name) => name.contains(productName.toLowerCase()));
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        fileName = result.files.single.name;
        if (kIsWeb) {
          filePath = null;
          imageBytes = result.files.single.bytes;
        } else {
          filePath = result.files.single.path;
          imageBytes = null;
        }
      });
      print('fileName: $fileName');
      print('filePath: $filePath');
      print('imageBytes: ${imageBytes?.length}');
      if (!kIsWeb && filePath != null) {
        print('File exists: ${File(filePath!).existsSync()}');
      }
    }
  }

  Future<void> analyzeImage() async {
    setState(() {
      loading = true;
      result = null;
    });
    try {
      var uri = Uri.parse('https://agri-shop-1.onrender.com/analyze-image');
      var request = http.MultipartRequest('POST', uri);
      if (kIsWeb && imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes!,
            filename: fileName ?? 'plante.jpg',
          ),
        );
      } else if (!kIsWeb && filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            filePath!,
          ),
        );
      } else {
        setState(() {
          loading = false;
        });
        print('Aucune image sélectionnée');
        return;
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        var respStr = await response.stream.bytesToString();
        var data = json.decode(respStr);
        setState(() {
          result = data['result'] ?? 'Aucune réponse.';
        });
        print('Réponse IA : ${data['result']}');
      } else {
        setState(() {
          result = 'Erreur lors de l\'analyse (code ${response.statusCode})';
        });
        print('Erreur lors de l\'analyse (code ${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        result = 'Erreur lors de l\'analyse: $e';
      });
      print('Erreur lors de l\'analyse: $e');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IA'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Analyse d\'image', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)), 
              SizedBox(height: 20), 
              Icon(
                Icons.smart_toy,
                size: 100,
                color: Colors.green,
              ),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Choisir une image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              
              if (fileName != null) ...[
                SizedBox(height: 20),
                Text('Fichier sélectionné : $fileName'),
              ],
              if (kIsWeb && imageBytes != null) ...[
                SizedBox(height: 20),
                Image.memory(imageBytes!, width: 200, height: 200, fit: BoxFit.cover),
              ],
              if (!kIsWeb && filePath != null) ...[
                SizedBox(height: 20),
                if (File(filePath!).existsSync())
                  Image.file(File(filePath!), width: 200, height: 200, fit: BoxFit.cover)
                else
                  Text('Fichier non trouvé', style: TextStyle(color: Colors.red)),
              ],
              if ((kIsWeb && imageBytes != null) || (!kIsWeb && filePath != null)) ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: analyzeImage,
                  child: Text('Analyser l\'image'),
                ),
              ],
              if (loading) ...[
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
              if (result != null) ...[
                SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      result!,
                      style: TextStyle(
                        color: result!.startsWith('Erreur') ? Colors.red : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Builder(
                      builder: (context) {
                        print('Texte à analyser: $result');
                        print('Liste des produits disponibles: $productNames');
                        
                        // Chercher le nom complet du produit dans le texte
                        String? foundProduct;
                        for (String productName in productNames) {
                          if (result!.toLowerCase().contains(productName.toLowerCase())) {
                            foundProduct = productName;
                            break;
                          }
                        }
                        
                        print('Produit trouvé: $foundProduct');
                        
                        if (foundProduct != null) {
                          return Column(
                            children: [
                              Text(
                                'Produit disponible: $foundProduct',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    final response = await http.get(Uri.parse('https://agri-shop-5b8y.onrender.com/api/products'));
                                    if (response.statusCode == 200) {
                                      List<dynamic> data = json.decode(response.body);
                                      // On récupère le produit dont le nom correspond à foundProduct 
                                      final productData = data.firstWhere(
                                        (item) => item['name'].toString().toLowerCase() == foundProduct!.toLowerCase(),
                                      );
                                      final product = Product.fromJson(productData);
                                      CartService.addItem(product);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.name} ajouté au panier'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print('Erreur lors de l\'ajout au panier: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erreur lors de l\'ajout au panier'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Text('Ajouter au panier'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                'Le produit n\'est pas disponible dans notre catalogue',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}