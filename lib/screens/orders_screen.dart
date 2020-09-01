import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  bool _isLoading = false;
  static const String routeName = '/ordersScreen';

  // @override
  // void initState() {

  //       _isLoading = true;

  //    Provider.of<Orders>(context, listen: false).fetchAndStoreOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndStoreOrders(),
          builder: (ctx, connectionSnapshot) {
            if (connectionSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (connectionSnapshot.error != null) {
                return Center(child: Text('Error occured'));
              }
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(
                    orderData.orders[i],
                  ),
                ),
              );
            }
          }),
    );
  }
}
