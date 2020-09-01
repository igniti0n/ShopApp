import 'package:flutter/material.dart';

import '../screens/edit_products_screen.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(this.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl), //you provide the image, circleAvatar wraps it in itself
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductsScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                // Provider.of<Products>(context).removeProduct(id);
                var response = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you shure ?'),
                    content: Text('You are about to delete the item.'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('YES'),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('NO'),
                      )
                    ],
                  ),
                );
                if (response) {
                  try {
                    var value =
                        await Provider.of<Products>(context).removeProduct(id);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  }
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
