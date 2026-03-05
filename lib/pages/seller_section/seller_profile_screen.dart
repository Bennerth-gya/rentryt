// lib/pages/seller/seller_profile_screen.dart
import 'package:comfi/models/profile_body.dart';
import 'package:comfi/pages/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../consts/colors.dart';
import 'seller_update_profile_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: background,
        title: Center(
          child: const Text("Profile", style: TextStyle(color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                /// ---------------- Profile Image + Pencil ----------------
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                          image: AssetImage('assets/images/strive.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// Pencil icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.amber,
                        ),
                        child: const Icon(
                          LineAwesomeIcons.pencil_alt_solid,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  'Systrom',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'gbennerth@gmail.com',
                  style: TextStyle(color: Colors.white60),
                ),

                const SizedBox(height: 20),

                /// ---------------- Edit Profile Button ----------------
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SellerUpdateProfileScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Edit profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),

                /// ---------------- Menu ----------------
                ProfileMenuWIdget(
                  title: 'Settings',
                  textColor: Colors.white,
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {},
                ),
                ProfileMenuWIdget(
                  title: 'Billing Details',
                  textColor: Colors.white,
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {},
                ),
                ProfileMenuWIdget(
                  title: 'User Management',
                  textColor: Colors.white,
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {},
                ),

                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                ProfileMenuWIdget(
                  title: 'Information',
                  textColor: Colors.white,
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {},
                ),
                ProfileMenuWIdget(
                  title: 'Logout',
                  textColor: Colors.red,
                  endIcon: false,
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  onPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
