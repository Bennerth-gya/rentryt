import 'package:flutter/material.dart';
import 'package:comfi/models/profile_body.dart';
import 'package:comfi/pages/update_profile_screen.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LineAwesomeIcons.moon)),
        ],
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
                          image: AssetImage('lib/images/strive.jpg'),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text('gbennerth@gmail.com'),

                const SizedBox(height: 20),

                /// ---------------- Edit Profile Button ----------------
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const UpdateProfileScreen());
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
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {},
                ),
                ProfileMenuWIdget(
                  title: 'Billing Details',
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {},
                ),
                ProfileMenuWIdget(
                  title: 'User Management',
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {},
                ),

                const Divider(color: Colors.grey),
                const SizedBox(height: 10),

                ProfileMenuWIdget(
                  title: 'Information',
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
