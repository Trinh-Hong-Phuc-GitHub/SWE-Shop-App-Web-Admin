import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final Stream<QuerySnapshot> _orderStrem =
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _orderStrem,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        return SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final order = snapshot.data!.docs[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  vendorData(
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.network(
                          order['productImage'][0],
                          width: 50,
                          height: 50,
                        ),
                      ),
                      1),
                  vendorData(
                      Text(
                        order['productName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      3),
                  vendorData(
                      Text(
                        "\$" + ' ' + order['productPrice'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      2),
                  vendorData(
                      Text(
                        order['productQuantity'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      2),
                  vendorData(
                      order['approved'] == true
                          ? ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(order['productId'])
                                .update({
                              'approved': false,
                            });
                          },
                          child: Text(
                            'Reject',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ))
                          : ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(order['productId'])
                              .update({
                            'approved': true,
                          });
                        },
                        child: Text(
                          'Approved',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow),
                        ),
                      ),
                      1),
                  vendorData(
                      ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'View More',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      1),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}