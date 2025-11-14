import 'package:flutter/material.dart';
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
}
