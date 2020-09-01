import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  //final String title;
  //ProductDetailScreen(this.title);
  static final routeName = '/thisRoute';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedProduct.title),
                collapseMode: CollapseMode.none,
                background: Container(
                  height: 300,
                  child: Hero(
                    tag: productId,
                    child: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 12,
              ),
              Text(
                "\$${loadedProduct.price}",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
