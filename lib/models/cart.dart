import 'package:comfi/models/shoe.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  // List of items for sale
  List<Shoe> shoeShop  = [
    Shoe(
      name: 'Jersey', 
      description: 'Get your favorite team jersey now!', 
      price: '29',
      imagePath: 'lib/images/hostel5.jpg'),

      Shoe(
        name: 'HP Laptop', 
        description: 'Nice and sleak laptop', 
        price: '500', 
        imagePath: 'lib/images/laptop.jpeg'),

      Shoe(
        name: 'Men Slippers', 
        description: 'Hostel description', 
        price: '15', 
        imagePath: 'lib/images/slipper2.jpg'),

        Shoe(
          name: "Fada's services",
         description: 'Get your all your PPEs here', 
         price: '29', 
         imagePath: 'lib/images/fada.jpeg'),
  ];
  // list of item to you
  List<Shoe> userCart = [];

  // get List of shoes for sale
  List<Shoe> getShoeList() {
    return shoeShop; 
}
  // get List of shoes in user cart
  List<Shoe> getUserCart() {
    return userCart; 
  }
  
  // add shoe to user cart
  void addItemToCart(Shoe shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  // remove shoe from user cart
  void removeItemFromCart(Shoe shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}