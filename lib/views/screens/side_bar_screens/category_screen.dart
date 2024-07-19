import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '\CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  dynamic _image;

  String? fileName;

  late String categoryName;

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
        _formKey.currentState!.reset();
      });
    }
  }

  _uploadCategoryBannerToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('categoryImage').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadCategory() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      // Check if the category name already exists
      var existingCategory = await _firestore
          .collection('categories')
          .where('categoryName', isEqualTo: categoryName)
          .get();

      if (existingCategory.docs.isNotEmpty) {
        // Category name already exists
        EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Category name already exists. Please choose a different name.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Category name does not exist, proceed with creation
        String imageUrl = await _uploadCategoryBannerToStorage(_image);
        await _firestore.collection('categories').doc(fileName).set(
          {
            'image': imageUrl,
            'categoryName': categoryName,
          },
        ).whenComplete(() {
          EasyLoading.dismiss();
          setState(() {
            _image = null;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          border: Border.all(
                            color: Colors.grey.shade800,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _image != null
                            ? Image.memory(
                          _image,
                          fit: BoxFit.cover,
                        )
                            : Center(
                          child: Text('Category'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade900,
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 180,
                    child: TextFormField(
                      onChanged: (value) {
                        categoryName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Category Name Must Not Be Empty';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Category Name',
                        hintText: 'Enter Category Name',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade900,
                  ),
                  onPressed: () {
                    uploadCategory();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}
