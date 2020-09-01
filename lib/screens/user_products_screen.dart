import 'package:flutter/material.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_products_screen.dart';

import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';

  Future<void> _onRefreshFunction(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _onRefreshFunction(context),
        builder: (ctx, currentSnapshot) =>
            currentSnapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _onRefreshFunction(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, i) => Column(children: <Widget>[
                            UserProductItem(
                              productsData.items[i].id,
                              productsData.items[i].title,
                              productsData.items[i].imageUrl,
                            ),
                            Divider(thickness: 1),
                          ]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
