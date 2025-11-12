import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store/model/page_view_model.dart';
import 'dart:io';

import 'package:store/model/special_offer_model.dart';

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
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageViewFuture = sendRequestPageView();
    specialOfferFuture = sendRequestSpecialOffer();
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
                                        onPressed: () {},
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

  Future<List<PageViewModel>> sendRequestPageView() async {
    return await fetchData('pageview', (json) => PageViewModel.fromJson(json));
  }

  Future<List<SpecialOfferModel>> sendRequestSpecialOffer() async {
    return await fetchData(
      'products',
      (json) => SpecialOfferModel.fromJson(json),
    );
  }

  Future<List<T>> fetchData<T>(
    String tableName,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    const String baseUrl = 'https://ukrshwdqetdpzfsjmgbc.supabase.co/rest/v1/';
    const String apiKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrcnNod2RxZXRkcHpmc2ptZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4NDkzMzMsImV4cCI6MjA3ODQyNTMzM30.KNnALmGW6pW5GrUslwnL07dNUQRDwbYkzIhJV2bi4XU';

    try {
      final response = await Dio().get(
        '$baseUrl$tableName',
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Data fetched successfully from $tableName');
        final List data = response.data;
        return data.map((item) => fromJson(item)).toList();
      } else {
        print('⚠️ Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching $tableName data: $e');
      return [];
    }
  }

  Padding pageViewItems(PageViewModel pageViewModel) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(pageViewModel.imgeUrl, fit: BoxFit.fill),
      ),
    );
  }
}
