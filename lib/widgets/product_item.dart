import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatefulWidget {
  //final String id;
  //final String imageUrl;
  //final String title;

  //ProductItem(this.id, this.title, this.imageUrl);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    var _isLoadingFavorite = false;
    var _currentSacaffold = Scaffold.of(context);

    Future<void> _toggleFavoriteFunction() async {
      try {
        _isLoadingFavorite = true;
        await product.toggleFavorite(authData.token, authData.userId);
      } catch (error) {
        _currentSacaffold.showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
      setState(() {
        _isLoadingFavorite = false;
      });
    }

    return GridTile(
      child: Hero(
        tag: product.id,
        child: FadeInImage(
          placeholder: AssetImage('assets/images/product-placeholder.png'),
          image: NetworkImage(product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      footer: GestureDetector(
        onTap: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(title),
            ),
          );*/
          Navigator.pushNamed(context, ProductDetailScreen.routeName,
              arguments: product.id);
        },
        child: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            //another way of passing data, not usinf Provider.of, Consumer listens allways and re build only the part that is wrapt with it
            builder: (ctx, product, child) => IconButton(
              icon: _isLoadingFavorite
                  ? CircularProgressIndicator()
                  : Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
              onPressed: _toggleFavoriteFunction,
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Added to cart!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
