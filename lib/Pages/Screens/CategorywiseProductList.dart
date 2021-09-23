import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/CommonWidgets/ProductTile.dart';
import 'package:agrozon/CommonWidgets/ProgressDialog.dart';
import 'package:agrozon/Model/ProductModel.dart';
import 'package:flutter/material.dart';

class CategorywiseProductList extends StatefulWidget {
  final List<Product> allproduct;
  final String title;
  CategorywiseProductList({@required this.title, @required this.allproduct});

  @override
  _CategorywiseProductListState createState() =>
      _CategorywiseProductListState();
}

class _CategorywiseProductListState extends State<CategorywiseProductList> {
  List<Product> products = [];
  @override
  void initState() {
    filterProducts();
    super.initState();
  }

  void filterProducts() {
    switch (widget.title) {
      case "seeds":
        widget.allproduct.forEach((element) {
          if (element.productId.contains('s')) {
            products.add(element);
          }
        });
        break;
      case "pestiside":
        widget.allproduct.forEach((element) {
          if (element.productId.contains('p')) {
            products.add(element);
          }
        });
        break;
      case "fertilizer":
        widget.allproduct.forEach((element) {
          if (element.productId.contains('f')) {
            products.add(element);
          }
        });
        break;
      case "hardware":
        widget.allproduct.forEach((element) {
          if (element.productId.contains('h')) {
            products.add(element);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 45) / 2;
    final double itemWidth = size.width / 2;
    if (products.length == 0) {
      return ProgressDialog(text: 'please wait...');
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            widget.title,
            style: TextStyle(color: AppColors.darkGreyColor),
          ),
          centerTitle: true,
          backgroundColor: AppColors.whiteColor,
          leading: InkWell(
            child: Icon(Icons.arrow_back_ios, color: AppColors.darkGreyColor),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
          ),
          child: Container(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.71,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: List.generate(products.length, (index) {
                return ProductTile(
                  product: products[index],
                  update: () {
                    setState(() {});
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
