import 'package:comfi/components/shoe_tile.dart';
import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/shoe.dart';
import 'package:comfi/pages/column_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  // add shoe to cart
  void addShoeToCart(Shoe shoe) {
    Provider.of<Cart>(context, listen: false).addItemToCart(shoe);
  
  // alert the user, shoe successfully added
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text("Added successfully"),
      content: Text("Check your cart."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        )
      ],
    )
  );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Container(
          color: background,
          child: SingleChildScrollView(
            child: Column(
              children: [
              // search bar
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Search...', style: TextStyle(color: textSecondary),),
                    Icon(
                      Icons.search,
                      color: textSecondary,
                    )
                  ],
                ),
              ),
            
              // messages
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 25),
                child: Text(
                  'Do not be afraid to sacrifice thhe good things for the great ones.',
                  style: TextStyle(color: textSecondary),
                  ),
              ),
            
              // hot picks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Hot picks 🔥', 
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accent
                    ),
                    ),
                    Text(
                      'See all...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: accent),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
            
              // <<< ---- horizontal listview ------>>>
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cart.getShoeList().length,
                  itemBuilder: (context, index) {
                    Shoe shoe = cart.getShoeList()[index];
                    return ShoeTile(
                      shoe: shoe,
                      onTap: () => addShoeToCart(shoe),
                    );
                  },
                ),
              ),
            
            
                // <<< ---- vertical column ------>>>
            
                const SizedBox(height: 25),
            
            // Featured Hostels title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Featured Hostels 🏠',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accent
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Vertical hostel images
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              children: const [
                HostelCard(
                  imagePath: 'lib/images/fada.jpeg',
                  name: 'Green View Hostel',
                ),
                HostelCard(
                  imagePath: 'lib/images/A1.jpg',
                  name: 'Sunrise Hostel',
                ),
                HostelCard(
                  imagePath: 'lib/images/hostel1.jpeg',
                  name: 'Royal Comfort Hostel',
                ),
              ],
            ),
            
                
               Padding(
                 padding:
                 const EdgeInsets.only(top:25, left: 25, right:25),
                 child:
                 Divider(color:textPrimary,),
               )
              ],
            ),
          ),
        );
      }
    );
  }
}