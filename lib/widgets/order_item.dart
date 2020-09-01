import 'dart:math';

import 'package:flutter/material.dart';

import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          //if (_expanded)
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 250),
              height: _expanded ? min(widget.order.products.length * 20.0 + 28, 100) : 0,
              // constraints: BoxConstraints(
              //   minHeight: _expanded
              //       ? min(widget.order.products.length * 20.0 + 28, 100)
              //       : 0,
              //   maxHeight: _expanded
              //       ? min(widget.order.products.length * 20.0 + 28, 100)
              //       : 0,
              // ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              //height: min(widget.order.products.length * 20.0 + 28, 100),
              child: ListView(
                children: widget.order.products
                    .map(
                      (item) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${item.title} "),
                          Text("x${item.quantity} \$${item.price}")
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
