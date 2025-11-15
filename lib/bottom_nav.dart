import 'package:flutter/material.dart';
import 'package:store/shop_basket.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      color: Colors.red,
      child: Container(
        height: 60,

        child: Row(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.home)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.person)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 60),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ShopBasket()),
                        );
                      },
                      icon: Icon(Icons.shopping_basket),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
