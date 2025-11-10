import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:store/model/page_view_model.dart';
import 'dart:io';

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
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageViewFuture = sendRequestPageView();
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
      body: Column(
        children: [
          Container(
            height: 250,
            color: Colors.amber,
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
        ],
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
