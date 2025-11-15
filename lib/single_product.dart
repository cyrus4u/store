import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/model/special_offer_model.dart';

class SingleProduct extends StatelessWidget {
  SingleProduct(this.specialOfferModel, {super.key});
  SpecialOfferModel specialOfferModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('کالا', style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Image.network(specialOfferModel.imageUrl, fit: BoxFit.fill),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  specialOfferModel.productName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  specialOfferModel.price.toString(),
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {},
                      child: Text('افزودن به سبد خرید'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDataToSP() async {
    List<String> imageUrls = [];
    List<String> productTitels = [];
    List<String> productPrice = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imageUrls.add(specialOfferModel.imageUrl);
    productTitels.add(specialOfferModel.productName);
    productPrice.add(specialOfferModel.price.toString());
    prefs.setStringList('imageUrls', imageUrls);
    prefs.setStringList('productTitels', productTitels);
    prefs.setStringList('productPrice', productPrice);

  }
}
