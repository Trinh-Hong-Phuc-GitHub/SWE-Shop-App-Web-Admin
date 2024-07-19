import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../details/product_detail_screen.dart';

class ProductListWidget extends StatefulWidget {
  final String searchQuery;
  final String selectedCategory;

  ProductListWidget({required this.searchQuery, required this.selectedCategory});

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final Stream<QuerySnapshot> _productStream =
  FirebaseFirestore.instance.collection('products').snapshots();

  Widget vendorData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
    } catch (e) {
      print('Failed to delete product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var productName = doc['productName'].toString().toLowerCase();
          var categoryName = doc['category'].toString().toLowerCase();
          bool matchesCategory = widget.selectedCategory.isEmpty ||
              categoryName == widget.selectedCategory.toLowerCase();
          return productName.contains(widget.searchQuery.toLowerCase()) && matchesCategory;
        }).toList();

        return SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredDocs.length,
            itemBuilder: ((context, index) {
              final product = filteredDocs[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  vendorData(
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        product['productImage'][0],
                        width: 50,
                        height: 50,
                      ),
                    ),
                    1,
                  ),
                  vendorData(
                    Text(
                      product['productName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    3,
                  ),
                  vendorData(
                    Text(
                      "\$" + ' ' + product['productPrice'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1,
                  ),
                  vendorData(
                    Text(
                      product['category'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1,
                  ),
                  vendorData(
                    product['approved'] == true
                        ? ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product['productId'])
                            .update({
                          'approved': false,
                        });
                      },
                      child: Text(
                        'Reject',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product['productId'])
                            .update({
                          'approved': true,
                        });
                      },
                      child: Text(
                        'Approved',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    1,
                  ),
                  vendorData(
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this product?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () async {
                                    await _deleteProduct(product['productId']);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'DELETE',
                        style: TextStyle(color: Colors.pink.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    1,
                  ),
                  vendorData(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(productData: product),
                          ),
                        );
                      },
                      child: Text(
                        'View More',
                        style: TextStyle(color: Colors.pink.shade900, fontWeight: FontWeight.bold),
                      ),
                    ),
                    1,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
