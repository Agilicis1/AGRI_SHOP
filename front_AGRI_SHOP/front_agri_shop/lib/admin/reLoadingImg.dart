import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'adminHome.dart';
import 'gestionCommande.dart';
import 'gestionProduit.dart';
import 'gestionDesClients.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ReLoadingImg extends StatefulWidget {
  @override
  _ReLoadingImgState createState() => _ReLoadingImgState();
}
class _ReLoadingImgState extends State<ReLoadingImg> {
  List<dynamic> images = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImageLoaded();
  }

  Future<void> getImageLoaded({bool showSnackbar = false}) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/loading-images');
    if (showSnackbar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chargement des images...')),
      );
    }
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() => images = data);
    } else {
      if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur HTTP: ${response.statusCode}')),
        );
      }
      setState(() => images = []);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getExternalStorageDirectory();
        final file = File('${dir!.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image téléchargée dans ${file.path}')),
        );
      } else if(response.statusCode == 404){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image non trouvée')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Autre erreur: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du telechargement de l\'image')),
      );
    }
  }

  Future<void> deleteImage(String imageId) async {
    final url = Uri.parse('https://agri-shop-5b8y.onrender.com/api/loading-images/$imageId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image supprimée avec succès')),
        );
        getImageLoaded(); // Rafraîchir la liste
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recupération des images uploadées '),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : images.isEmpty
              ? Center(child: Text('Aucune image trouvée.'))
              : ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final imgObj = images[index];
                    final imgUrl = 'https://agri-shop-5b8y.onrender.com/' + (imgObj['image'] ?? '');
                    final description = imgObj['description'] ?? '';
                    final categorie = imgObj['categorie'] ?? '';
                    final customCategorie = imgObj['customCategorie'] ?? '';
                    final categorieAffichee = (categorie == 'autres' && customCategorie.isNotEmpty)
                        ? customCategorie
                        : categorie;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            imgUrl,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                          ),
                          SizedBox(height: 8),
                          Text('description de la maladie: ' + description, style: TextStyle(fontSize: 16)),
                          Text('categorie de la maladie: ' + categorieAffichee, style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                            /*  IconButton(
                                icon: Icon(Icons.download),
                                onPressed: () {
                                  downloadImage(imgUrl);
                                },
                              ),*/
                              /*IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (imgObj['_id'] != null) {
                                    deleteImage(imgObj['_id']);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('ID de l\'image introuvable')),
                                    );
                                  }
                                },
                              ),*/
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}