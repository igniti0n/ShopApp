import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String itemKey;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.itemKey, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                size: 40,
                color: Colors.white,
              ),
            ),
            // margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10) ,
          ),
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Are you shure ?"),
                content: Text("You are abuot to delte a cart item !"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("YES"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("NO"),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<Cart>(context, listen: false).removeItem(itemKey);
          },
          direction: DismissDirection.endToStart,
          child: ListTile(
            //contentPadding: EdgeInsets.all(8),
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(2),
                child: FittedBox(
                  child: Text(price.toString()),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text("Total: \$${quantity * price}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
