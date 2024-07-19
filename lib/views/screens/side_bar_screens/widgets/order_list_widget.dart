import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../details/order_detail_screen.dart';

class OrderListWidget extends StatefulWidget {
  final String sortBy;

  const OrderListWidget({Key? key, required this.sortBy}) : super(key: key);

  @override
  _OrderListWidgetState createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  late Stream<QuerySnapshot> _orderStream;

  @override
  void initState() {
    super.initState();
    _orderStream = _getOrderedStream();
  }

  @override
  void didUpdateWidget(covariant OrderListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sortBy != widget.sortBy) {
      setState(() {
        _orderStream = _getOrderedStream();
      });
    }
  }

  Stream<QuerySnapshot> _getOrderedStream() {
    CollectionReference ordersRef =
    FirebaseFirestore.instance.collection('orders');

    switch (widget.sortBy) {
      case 'latest_first':
        return ordersRef.orderBy('orderDate', descending: true).snapshots();
      case 'oldest_first':
        return ordersRef.orderBy('orderDate', descending: false).snapshots();
      default:
        return ordersRef.snapshots();
    }
  }

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
      stream: _orderStream,
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
              Timestamp orderDate = order['orderDate'];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  vendorData(
                    Text(
                      order['orderDate'].toDate().toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    2,
                  ),
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
                    1,
                  ),
                  vendorData(
                    Text(
                      order['productName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    3,
                  ),
                  vendorData(
                    Text(
                      order['quantity'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1,
                  ),
                  vendorData(
                    Text(
                      "\$" + ' ' + order['price'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    1,
                  ),
                  vendorData(
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailScreen(
                              orderData: order,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View More',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
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
