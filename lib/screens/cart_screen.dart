import 'dart:async';

import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../widgets/Cart_item.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/app_drawer.dart';

// class CartScreen extends StatefulWidget {
//   static final routeName = "/cart";

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

class CartScreen extends StatelessWidget {
  static final routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text("\$${cart.totalPrice.toStringAsFixed(2)}"),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart),
                  ],
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  });

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.numberOfElements <= 0 || _isLoading 
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalPrice,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              } catch (error) {
                // Scaffold.of(ctx)
                //     .showSnackBar(SnackBar(content: Text(error.toString())));
                print(error.toString());
              }
            },
      child: _isLoading ? CircularProgressIndicator() : Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
