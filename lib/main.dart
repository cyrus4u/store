import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store/all_product.dart';
import 'package:store/model/events_model.dart';
import 'package:store/model/page_view_model.dart';
import 'dart:io';
import 'package:store/model/special_offer_model.dart';
import 'package:store/services/api_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<PageViewModel>> pageViewFuture;
  late Future<List<SpecialOfferModel>> specialOfferFuture;
  late Future<List<EventsModel>> eventFuture;
  PageController pageController = PageController();
  final api = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageViewFuture = api.fetchData(
      'pageview',
      (json) => PageViewModel.fromJson(json),
    );
    specialOfferFuture = api.fetchData(
      'products',
      (json) => SpecialOfferModel.fromJson(json),
    );
    eventFuture = api.fetchData('events', (json) => EventsModel.fromJson(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('DigiKala'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              color: Colors.white,
              child: FutureBuilder<List<PageViewModel>>(
                future: pageViewFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<PageViewModel>? model = snapshot.data;
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: pageController,
                          allowImplicitScrolling: true,
                          itemCount: model!.length,
                          itemBuilder: (context, index) {
                            return pageViewItems(model[index]);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmoothPageIndicator(
                            controller: pageController,
                            count: model.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 10,
                              dotWidth: 10,
                              spacing: 3,
                              dotColor: Colors.white,
                              activeDotColor: Colors.blue,
                            ),
                            onDotClicked: (index) {
                              pageController.animateToPage(
                                index,
                                duration: Duration(seconds: 1),
                                curve: Curves.bounceOut,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: JumpingDotsProgressIndicator(
                        fontSize: 60,
                        dotSpacing: 5,
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 300,
                color: Colors.red,
                child: FutureBuilder(
                  future: specialOfferFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<SpecialOfferModel>? model = snapshot.data;
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: model!.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SizedBox(
                              height: 300,
                              width: 200,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10,
                                      top: 15,
                                    ),
                                    child: Image.asset(
                                      'images/qorfe.png',
                                      height: 230,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AllProduct(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'مشاهده همه',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return specialOfferItem(model[index - 1]);
                          }
                        },
                      );
                    } else {
                      return Center(child: JumpingDotsProgressIndicator());
                    }
                  },
                ),
              ),
            ),
            Container(
              height: 500,
              width: double.infinity,
              child: FutureBuilder<List<EventsModel>>(
                future: eventFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<EventsModel>? model = snapshot.data;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      model![0].imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      model[1].imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      model[2].imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      model[3].imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container specialOfferItem(SpecialOfferModel specialOfferModel) {
    return Container(
      width: 200,
      height: 300,
      child: Card(
        child: SizedBox(
          width: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  specialOfferModel.imageUrl,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  specialOfferModel.productName,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${specialOfferModel.offPrice}T',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${specialOfferModel.price}T',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            specialOfferModel.offPercent.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  Padding pageViewItems(PageViewModel pageViewModel) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(pageViewModel.imageUrl, fit: BoxFit.fill),
      ),
    );
  }
}
