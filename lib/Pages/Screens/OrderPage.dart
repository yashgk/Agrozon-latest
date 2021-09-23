import 'package:agrozon/AppConstants/AppColors.dart';
import 'package:agrozon/AppConstants/AppConstant.dart';
import 'package:agrozon/CommonWidgets/ProgressDialog.dart';
import 'package:agrozon/Core/RealtimeDatabase.dart';
import 'package:agrozon/Model/ProductModel.dart';

import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Product> allproducts = [];
  List<Product> favouriteProds = [];
  Map<dynamic, dynamic> kartMap = {};
  List<Product> kartProducts = [];
  List<dynamic> qty = [];
  bool deleteItem = false;
  bool noItems = false;
  bool isLoading = false;
  TextStyle textStyle = TextStyle(
      color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 15);

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

  Future<void> getKartList() async {
    kartMap = await RealtimeDatabase.getKartList();
    setState(() {});
  }

  Future<void> finalize() async {
    setState(() {
      isLoading = true;
    });
    await getAllProducts();
    await getKartList();

    if (kartMap == null) {
      setState(() {
        noItems = true;
      });
    } else {
      qty = kartMap.values.toList();
      kartMap.keys.forEach((kartElement) {
        allproducts.forEach((element) {
          if (element.productId == kartElement) {
            kartProducts.add(element);
          }
        });
      });
      setState(() {});
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    finalize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ProgressDialog(text: "Please Wait...")
        : noItems
            ? Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(color: AppColors.whiteColor),
                child: Center(
                  child: Text(
                    "Your Kart is Empty",
                    style: TextStyle(
                        color: AppColors.darkGreyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ))
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.whiteColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: kartProducts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: AppColors.darkGreyColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            kartProducts[index].imageUrl,
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                      ),
                                      AppConstant.sizer(
                                          context: context, h: 0.0, w: 0.03),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              kartProducts[index].productName,
                                              style: textStyle,
                                            ),
                                            Text(
                                              "₹ " + kartProducts[index].price,
                                              style: textStyle,
                                            ),
                                            Text(
                                              "Ratings : " +
                                                  kartProducts[index].rating,
                                              style: textStyle,
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: AppColors.darkSlateGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: InkWell(
                                                onTap: () async {
                                                  if (int.parse(qty[index]) !=
                                                      30) {
                                                    await RealtimeDatabase
                                                        .addToKart(
                                                            kartProducts[index]
                                                                .productId);
                                                    await getKartList();
                                                    setState(() {
                                                      qty = kartMap.values
                                                          .toList();
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      AppColors.darkGreyColor,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 35,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Text(
                                                qty[index].toString() ?? "",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.darkGreyColor,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Container(
                                              child: InkWell(
                                                onTap: () async {
                                                  if (int.parse(qty[index]) ==
                                                      1) {
                                                    await RealtimeDatabase
                                                        .deleteFromKart(
                                                            kartProducts[index]
                                                                .productId);
                                                    await getKartList();
                                                    if (kartMap == null) {
                                                      setState(() {
                                                        noItems = true;
                                                      });
                                                    }
                                                    kartProducts.removeWhere(
                                                        (element) =>
                                                            element.productId ==
                                                            kartProducts[index]
                                                                .productId);
                                                  } else {
                                                    await RealtimeDatabase
                                                        .removeFromKart(
                                                            kartProducts[index]
                                                                .productId);
                                                    await getKartList();
                                                    if (kartMap == null) {
                                                      setState(() {
                                                        noItems = true;
                                                      });
                                                    }
                                                    setState(() {
                                                      qty = kartMap.values
                                                          .toList();
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  int.parse(qty[index]) == 1
                                                      ? Icons.delete
                                                      : Icons.remove,
                                                  color:
                                                      AppColors.darkGreyColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.darkGreyColor),
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ))
                  ],
                ),
              );
  }
}
