import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  // List of items for sale
  List<Products> shoeShop = [
    Products(
      name: 'Jersey',
      description: 'Get your favorite team jersey now!',
      price: '29',
      imagePath: 'lib/images/hostel5.jpg',
    ),

    Products(
      name: 'HP Laptop',
      description: 'Nice and sleak laptop',
      price: '500',
      imagePath: 'lib/images/laptop.jpeg',
    ),

    Products(
      name: 'Men Slippers',
      description: 'Hostel description',
      price: '15',
      imagePath: 'lib/images/slipper2.jpg',
    ),

    Products(
      name: "Fada's services",
      description: 'Get your all your PPEs here',
      price: '29',
      imagePath: 'lib/images/fada.jpeg',
    ),
  ];
  // list of item to you
  List<Products> userCart = [];

  // get List of shoes for sale
  List<Products> getShoeList() {
    return shoeShop;
  }

  // get List of shoes in user cart
  List<Products> getUserCart() {
    return userCart;
  }

  // add shoe to user cart
  void addItemToCart(Products shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  // remove shoe from user cart
  void removeItemFromCart(Products shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}
