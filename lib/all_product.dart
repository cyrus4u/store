import 'package:flutter/material.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('فروشگاه'),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.map))],
      ),
      body: Container(),
    );
  }
}
