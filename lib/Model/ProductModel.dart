import 'package:flutter/material.dart';

class Product {
  String productId;
  String productName;
  String productDesc;
  String price;
  String rating;
  bool isFavourite;
  String imageUrl;
  Product(
      { this.productId,
       this.productName,
       this.productDesc,
      this.price,
       this.rating,
      this.isFavourite = false,
       this.imageUrl});
}
