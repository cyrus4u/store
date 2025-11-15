import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/bottom_nav.dart';
import 'package:store/model/shop_basket_model.dart';
import 'package:store/model/special_offer_model.dart';
import 'package:store/shared_pref_helper.dart';
import 'package:store/single_product.dart';

class ShopBasket extends StatefulWidget {
  const ShopBasket({super.key});

  @override
  State<ShopBasket> createState() => _ShopBasketState();
}

class _ShopBasketState extends State<ShopBasket> {
  StreamController<ShopBasketModel> streamController = StreamController();
 @override
void initState() {
  super.initState();
  loadBasket();
}

Future<void> loadBasket() async {
  final images = await PrefHelper.getImageUrls();
  final titles = await PrefHelper.getTitles();
  final prices = await PrefHelper.getPrices();
  streamController.add(
    ShopBasketModel(images, titles, prices),
  );
  
  print(images.length);
}


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
        title: Text('سبد خرید', style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
      ),
      body: StreamBuilder<ShopBasketModel>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ShopBasketModel? model = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: model!.imageUrls.length,
              itemBuilder: (context, index) {
                return generateItem(
                  model.imageUrls[index],
                  model.productTitles[index],
                  model.productPrice[index],
                );
              },
            );
          } else {
            return Center(child: JumpingDotsProgressIndicator());
          }
        },
      ),
    );
  }

  Widget generateItem(
    String imageUrl,
    String productTitle,
    String productPrice,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 15),
                          child: Text(
                            productTitle,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            productPrice,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      width: 150,
                      height: 150,
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
