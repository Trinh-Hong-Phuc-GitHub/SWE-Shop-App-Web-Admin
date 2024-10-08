import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  Future<void> _deleteCategory(BuildContext context, String categoryId, String categoryName) async {
    final productsQuery = await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .get();

    print('Found ${productsQuery.docs.length} products linked to category $categoryName.');

    if (productsQuery.docs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Không thể xóa'),
            content: Text('Các sản phẩm được liên kết cần phải được xóa trước khi xóa loại sản phẩm này.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Trở về'),
              ),
            ],
          );
        },
      );
    } else {
      // Xóa loại sản phẩm
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
      Navigator.of(context).pop(); // Đóng hộp thoại xác nhận xóa
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
    FirebaseFirestore.instance.collection('categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Xác nhận xóa'),
                      content: Text('Bạn có chắc muốn xóa danh mục này?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                          },
                          child: Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteCategory(context, categoryData.id, categoryData['categoryName']);
                          },
                          child: Text('Xóa'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      categoryData['image'],
                    ),
                  ),
                  Text(
                    categoryData['categoryName'],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
