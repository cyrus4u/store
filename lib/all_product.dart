import 'package:flutter/material.dart';
import 'package:store/bottom_nav.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNav(),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('فروشگاه', style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.map))],
      ),
      body: Container(),
    );
  }
}
