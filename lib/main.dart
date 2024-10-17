import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multistore/views/categories_screen.dart';
import 'package:multistore/views/productos_screen.dart';
import 'package:multistore/views/upload_banner_screen.dart';
import 'package:multistore/views/upload_product.dart';
import 'package:multistore/views/vendor_widget.dart';
import 'package:multistore/views/vendors_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD2k2_nJ1KybnI3SmSpHEB3_rXbv6vmnSY",
      projectId: "multi-store-app-intec",
      storageBucket: "gs://multi-store-app-intec.appspot.com",
      messagingSenderId: "775563200012",
      appId: "1:775563200012:web:e0896cffc6aa4088359029",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(), // Se establece el tema oscuro
      home: const HomeScreen(),
      builder: EasyLoading.init(),
      routes: {
        '/categories_screen': (context) => CategoriesScreen(),
        '/productos_screen': (context) => ProductForm(),
        '/upload_banner_screen': (context) => UploadBannerScreen(),
        '/upload_product': (context) => ProductFormScreen(),
        '/vendors_screen': (context) => VendorsScreen(),
        '/vendor_widget': (context) => VendorWidget(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi Store App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.white),
              title: Text('Categories Screen', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/categories_screen');
              },
            ),
            ListTile(
              leading: Icon(Icons.upload, color: Colors.white),
              title: Text('Upload Banner', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/upload_banner_screen');
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud_upload, color: Colors.white),
              title: Text('Upload Product', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/upload_product');
              },
            ),
            ListTile(
              leading: Icon(Icons.store, color: Colors.white),
              title: Text('Vendors Screen', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/vendors_screen');
              },
            ),

          ],
        ),
      ),
      body: Center(
        child: Text('Main Content Area'),
      ),
    );
  }
}
