import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:store/bottom_nav.dart';
import 'package:store/google_maps.dart';
import 'package:store/model/special_offer_model.dart';
import 'package:store/services/api_service.dart';
import 'package:store/single_product.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  late Future<List<SpecialOfferModel>> specialOfferFuture;
  final api = ApiService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    specialOfferFuture = api.fetchData(
      'products',
      (json) => SpecialOfferModel.fromJson(json),
    );
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
        title: Text('فروشگاه', style: TextStyle(fontFamily: 'Vazir')),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleMaps()),
              );
            },
            icon: Icon(Icons.map),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List<SpecialOfferModel>>(
          future: specialOfferFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SpecialOfferModel>? model = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: List.generate(
                    model!.length,
                    (index) => generateItem(model[index]),
                  ),
                ),
              );
            } else {
              return Center(child: JumpingDotsProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget generateItem(SpecialOfferModel specialOfferModel) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleProduct(specialOfferModel),
          ),
        );

        // 🔥 After coming back from SingleProduct, refresh the basket screen
        // BUT: we can't call loadBasket() here because it's inside ShopBasket.

        // Instead: tell Flutter to rebuild the whole bottom nav screen structure
        setState(() {});
      },
      child: Card(
        elevation: 10,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Image.network(specialOfferModel.imageUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  specialOfferModel.productName,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(specialOfferModel.price.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
