import 'dart:convert';
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
                            return Container(
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
                            return Container(width: 200,);
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

  Future<List<PageViewModel>> sendRequestPageView() async {
    List<PageViewModel> model = [];

    try {
      var response = await Dio().get(
        'https://raw.githubusercontent.com/cyrus4u/my-images-data/main/photos.json',
        options: Options(responseType: ResponseType.plain), // Force raw text
      );

      // Convert response.data (String) → Map
      var jsonData = jsonDecode(response.data);

      // Access the list of photos
      var photos = jsonData['photos'];

      // Parse the list
      for (var item in photos) {
        PageViewModel page = PageViewModel(item['id'], item['imgUrl']);
        model.add(page);
      }

      // Debug logs
      for (var m in model) {
        print(m.imgUrl);
      }

      return model;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<List<SpecialOfferModel>> sendRequestSpecialOffer() async {
    List<SpecialOfferModel> models = [];

    // Your Supabase REST endpoint
    const String url =
        'https://ukrshwdqetdpzfsjmgbc.supabase.co/rest/v1/products';

    // Your anon public API key
    const String apiKey =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVrcnNod2RxZXRkcHpmc2ptZ2JjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4NDkzMzMsImV4cCI6MjA3ODQyNTMzM30.KNnALmGW6pW5GrUslwnL07dNUQRDwbYkzIhJV2bi4XU';

    try {
      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            'apikey': apiKey,
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      // Check response
      if (response.statusCode == 200) {
        print('✅ Data fetched successfully!');
        print(response.data);

        // Example: parse response into model
        models = (response.data as List)
            .map((item) => SpecialOfferModel.fromJson(item))
            .toList();
      } else {
        print('⚠️ Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
    }

    return models;
  }

  Padding pageViewItems(PageViewModel pageViewModel) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(pageViewModel.imgUrl, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
