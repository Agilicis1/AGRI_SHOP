import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import '../homePage.dart';

class LoadingImage extends StatefulWidget {
  @override
  _LoadingImageState createState() => _LoadingImageState();
}

class _LoadingImageState extends State<LoadingImage> {
  File? _selectedImage;
  Uint8List? _imageBytes;
  String? _fileName;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
final List<String> categories = [
    'Herbicides',
    'Fongicides',
    'Insecticides',
    'Nématicides',
    'autres', 
  ];
  String? _selectedCategorie;
  final TextEditingController _categorieController = TextEditingController();
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name;
        if (kIsWeb) {
          _imageBytes = result.files.single.bytes;
          _selectedImage = null;
        } else {
          _selectedImage = File(result.files.single.path!);
          _imageBytes = null;
        }
      });
    }
  }

  Future<void> _uploadImageAndDescription() async {
    final hasImage = (kIsWeb && _imageBytes != null) || (!kIsWeb && _selectedImage != null);
    if (!hasImage || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez sélectionner une image et saisir une description.')),
      );
      return;
    }
    setState(() {
      _isUploading = true;
    });
    try {
      int? statusCode;
      if (kIsWeb && _imageBytes != null && _fileName != null) {
        statusCode = await MultipartRequestWithBytes(
          url: 'https://agri-shop-5b8y.onrender.com/upload-loading-image',
          bytes: _imageBytes!,
          filename: _fileName!,
          description: _descriptionController.text,
          categorie: _selectedCategorie ?? '',
        );
      } else if (!kIsWeb && _selectedImage != null) {
        statusCode = await MultipartRequestWithFile(
          url: 'https://agri-shop-5b8y.onrender.com/upload-loading-image',
          file: _selectedImage!,
          description: _descriptionController.text,
          categorie: _selectedCategorie ?? '',
        );
      } else {
        statusCode = null;
      }

      if (statusCode == 200 || statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('image et description envoyer avec succés , merci pour votre aide.'), backgroundColor: Colors.green),
        );
        setState(() {
          _selectedImage = null;
          _imageBytes = null;
          _fileName = null;
          _descriptionController.clear();
        });
      } else if (statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: Requête invalide (400).'), backgroundColor: Colors.red),
        );
      } else if (statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur serveur (500).'), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identification des plantes '),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (kIsWeb && _imageBytes != null)
                Image.memory(_imageBytes!, width: 200, height: 200, fit: BoxFit.cover)
              else if (!kIsWeb && _selectedImage != null)
                Image.file(_selectedImage!, width: 200, height: 200, fit: BoxFit.cover)
              else
                Icon(
                  Icons.image,
                  size: 120,
                  color: Colors.grey[400],
                ),
              if (_fileName != null) ...[
                SizedBox(height: 12),
                Text('Fichier sélectionné : $_fileName'),
              ],
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description de la maladie',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategorie,
                  items: categories.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategorie = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Catégorie de la maladie',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.upload_file),
                label: Text('Sélectionner une image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _uploadImageAndDescription,
                icon: Icon(Icons.send),
                label: _isUploading ? Text('Envoi...') : Text('Envoyer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<int> MultipartRequestWithFile({
  required String url,
  required File file,
  required String description,
  required String categorie,
}) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath('image', file.path));
  request.fields['description'] = description;
  request.fields['categorie'] = categorie;
  var response = await request.send();
  return response.statusCode;
}

Future<int> MultipartRequestWithBytes({
  required String url,
  required Uint8List bytes,
  required String filename,
  required String description,
  required String categorie,
}) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: filename));
  request.fields['description'] = description;
  request.fields['categorie'] = categorie;
  var response = await request.send();
  return response.statusCode;
}
