import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cached_network_image/cached_network_image.dart';

class   UploadBannerScreen extends StatefulWidget {
  @override
  _UploadBannerScreenState createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  Future<String> _uploadBannerToStorage(dynamic image) async {
    var ref = _storage.ref().child('banners').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> _uploadBannerToFirestore() async {
    if (_image != null && fileName != null) {
      EasyLoading.show();
      try {
        String imageURL = await _uploadBannerToStorage(_image);
        await _firestore.collection('banners').doc(fileName).set({
          'bannerImage': imageURL,
        });
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          fileName = null;
        });
      } catch (e) {
        EasyLoading.dismiss();
        print("Error al subir el banner o guardarlo en Firestore: $e");
      }
    } else {
      print("No se ha seleccionado una imagen o el nombre del archivo es nulo.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: Text(
            'Banners',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ),
        Divider(color: Colors.grey),
        Row(
          children: [
            Column(
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? Image.memory(_image, fit: BoxFit.cover)
                      : Center(child: Text('Upload Banner...')),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _pickImage, child: Text('Select Image'))
              ],
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _uploadBannerToFirestore,
              child: Text('Save'),
            )
          ],
        ),
        Divider(color: Colors.grey),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(10),
          child: Text(
            'Banners Subidos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('banners').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error al cargar banners'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay banners subidos.'));
              }
              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 8,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String imageUrl = snapshot.data!.docs[index]['bannerImage'];
                  return Image.network(imageUrl);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}