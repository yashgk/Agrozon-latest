import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/CommonWidgets/ProductTile.dart';
import 'package:agrozon/CommonWidgets/ProgressDialog.dart';
import 'package:agrozon/Core/RealtimeDatabase.dart';
import 'package:agrozon/Model/ProductModel.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Product> favouriteProds = [];
  bool isEmpty = false;
  bool isLoading = false;
  @override
  void initState() {
    getFav();
    super.initState();
  }

  Future<void> getFav() async {
    setState(() {
      isLoading = true;
    });
    favouriteProds = await RealtimeDatabase.getFavList();
    if (favouriteProds.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      favouriteProds.forEach((element) {
        element.isFavourite = true;
      });
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 45) / 2;
    final double itemWidth = size.width / 2;
    return isLoading
        ? ProgressDialog(text: "Please Wait...")
        : isEmpty
            ? Container(
                child: Center(
                  child: Text(
                    "Your Wishlist is Empty",
                    style: TextStyle(
                        color: AppColors.darkGreyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              )
            : Container(
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
                    children: List.generate(favouriteProds.length, (index) {
                      return ProductTile(
                        product: favouriteProds[index],
                        update: () {
                          setState(() {
                            getFav();
                          });
                        },
                      );
                    }),
                  ),
                ),
              );
  }
}
