import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:agrozon/CommonWidgets/ProgressDialog.dart';
import 'package:agrozon/Core/RealtimeDatabase.dart';
import 'package:agrozon/Model/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:agrozon/CommonWidgets/CarouselTile.dart';
import 'package:agrozon/CommonWidgets/ProductTile.dart';
import 'package:agrozon/Pages/Screens/CategorywiseProductList.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<Product> allproducts = [];
  List<Product> favouriteProds = [];

  Future<void> getAllProducts() async {
    allproducts = await RealtimeDatabase.getAllProducts();
    setState(() {});
  }

  Future<void> getFav() async {
    favouriteProds = await RealtimeDatabase.getFavList();
    favouriteProds.forEach((element) {
      element.isFavourite = true;
    });

    setState(() {});
  }

  Future<void> finalize() async {
    await getAllProducts();
    await getFav();

    allproducts.forEach((element) {
      favouriteProds.forEach((favelement) {
        if (favelement.productName == element.productName) {
          element.isFavourite = true;
        }
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    finalize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    if (allproducts.length == 0) {
      return ProgressDialog(text: 'please wait...');
    }
    return Container(
      padding: EdgeInsets.all(5),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.whiteColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppConstant.sizer(context: context, h: 0.0, w: 0.03),
              Text(
                'Category',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // AppConstant.sizer(context: context, h: 0.01, w: 0.0),
          SingleChildScrollView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CarouselTile(
                  label: 'Seed',
                  imagePath: 'assets/images/seed.png',
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategorywiseProductList(
                          title: "seeds",
                          allproduct: allproducts,
                        ),
                      ),
                    );
                  },
                ),
                AppConstant.sizer(context: context, h: 0.0, w: 0.05),
                CarouselTile(
                  label: 'Protection',
                  imagePath: 'assets/images/protect.png',
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorywiseProductList(
                                  title: "pestiside",
                                  allproduct: allproducts,
                                )));
                  },
                ),
                AppConstant.sizer(context: context, h: 0.0, w: 0.05),
                CarouselTile(
                  label: 'Nutrition',
                  imagePath: 'assets/images/nutrition.png',
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategorywiseProductList(
                          title: "fertilizer",
                          allproduct: allproducts,
                        ),
                      ),
                    );
                  },
                ),
                AppConstant.sizer(context: context, h: 0.0, w: 0.05),
                CarouselTile(
                  label: 'Hardware',
                  imagePath: 'assets/images/hardware.png',
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorywiseProductList(
                                  title: "hardware",
                                  allproduct: allproducts,
                                )));
                  },
                ),
              ],
            ),
          ),
          // AppConstant.sizer(context: context, h: 0.01, w: 0.0),
          Row(
            children: [
              AppConstant.sizer(context: context, h: 0.0, w: 0.03),
              Text(
                'All Products',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.darkGreyColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          AppConstant.sizer(context: context, h: 0.01, w: 0.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.71,
              padding: EdgeInsets.symmetric(horizontal: 10),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: List.generate(allproducts.length, (index) {
                return ProductTile(
                  product: allproducts[index],
                  update: () {
                    setState(() {});
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
