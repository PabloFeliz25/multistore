import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? productName;
  String? price;
  String? category;
  String? discount;
  String? quantity;
  String? description;
  List<PlatformFile>? selectedFiles;

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    QuerySnapshot querySnapshot = await _firestore.collection('categories').get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    setState(() {
      categories = docs.map((doc) => doc['categoryName'] as String).toList();
    });
  }

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.files;
      });
    }
  }

  Future<List<String>> _uploadImagesToStorage() async {
    List<String> downloadUrls = [];
    if (selectedFiles != null) {
      for (var file in selectedFiles!) {
        String fileName = file.name;
        var ref = _storage.ref().child('productos').child(fileName);
        UploadTask uploadTask = ref.putData(file.bytes!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadURL = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadURL);
      }
    }
    return downloadUrls;
  }

  Future<void> _uploadProductToFirestore(List<String> imageUrls) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        await _firestore.collection('productos').add({
          'productName': productName,
          'price': price,
          'category': category,
          'discount': discount,
          'quantity': quantity,
          'description': description,
          'images': imageUrls,
        });
        EasyLoading.dismiss();
        _formKey.currentState?.reset();
        setState(() {
          selectedFiles = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto subido con éxito')));
      } catch (e) {
        EasyLoading.dismiss();
        print("Error al subir el producto a Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir el producto')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                onChanged: (value) {
                  productName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: category,
                decoration: InputDecoration(labelText: 'Categoría'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descuento'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  discount = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 4,
                onChanged: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Seleccionar imágenes'),
              ),
              SizedBox(height: 10),
              selectedFiles != null
                  ? Text('${selectedFiles!.length} imagen(es) seleccionada(s)')
                  : Text('No hay imágenes seleccionadas'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedFiles != null && selectedFiles!.isNotEmpty) {
                    List<String> imageUrls = await _uploadImagesToStorage();
                    await _uploadProductToFirestore(imageUrls);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona al menos una imagen')));
                  }
                },
                child: Text('Agregar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
