import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit_prod_scren';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  var _priceFocuseNode = FocusNode();
  var _descriptionFocuseNode = FocusNode();
  var _imageTextController = TextEditingController();
  var _imageFocusNode = FocusNode();
  var _formKey = GlobalKey<FormState>();
  var _initialLoad = true;
  var _loading = false;
  var _editedProduct = Product(
    id: null,
    title: 'null',
    description: 'null',
    imageUrl: 'null',
    price: 0,
  );
  Map<String, String> _initialVlues = {
    'title': '',
    'description': '',
    'price': '',
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImage);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialLoad) {
      var productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialVlues['title'] = _editedProduct.title;
        _initialVlues['description'] = _editedProduct.description;
        _initialVlues['price'] = _editedProduct.price.toString();
        _imageTextController.text =
            _editedProduct.imageUrl; //DO IT TROUGH CONTORLLER
      }
      _initialLoad = false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //VAŽNO MAKNUTI IZ MEMORIJE, DISPOSATI SA WIDGETOM
    _imageFocusNode.removeListener(
        _updateImage); //remove listener before removing FocuseNode !!!!
    _imageFocusNode.dispose();
    _priceFocuseNode.dispose();
    _descriptionFocuseNode.dispose();
    _imageTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocusNode.hasFocus) setState(() {});
  }

  void saveForm() async {
    var validated = _formKey.currentState.validate();
    if (!validated) return;
    _formKey.currentState.save();

    setState(() {
      _loading = true;
    });

    if (_editedProduct.id != null) {
       await Provider.of<Products>(context, listen: false)
          .editProduct(_editedProduct.id, _editedProduct);
    } else {
      try{
     await  Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
      }catch(error){
         await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occured!'),
            content: Text('Something went wrong!'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Okey.'),
              )
            ],
          ),
        );
      } 
    }
     setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initialVlues['title'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "Title"),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocuseNode);
                      },
                      validator: (text) {
                        if (!text.isEmpty) return null;
                        return 'Must not be empty.';
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialVlues['price'],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: "Price"),
                      focusNode: _priceFocuseNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocuseNode);
                      },
                      validator: (text) {
                        var check = double.tryParse(text);
                        if (check == null) return "Invalid unput";
                        if (double.parse(text) <= 0)
                          return "Enter number greater than zero.";
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initialVlues['description'],
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(labelText: "Details"),
                      focusNode: _descriptionFocuseNode,
                      validator: (text) {
                        if (text.isEmpty) return 'Please enter a description.';
                        if (text.length < 10)
                          return 'Should be at least 10 characters long.';
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageTextController.text.isEmpty
                              ? Text("Enter URL")
                              : FittedBox(
                                  child:
                                      Image.network(_imageTextController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            controller: _imageTextController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              saveForm();
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
