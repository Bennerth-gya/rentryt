import 'package:comfi/pages/seller_section/seller_profile_screen.dart';
import 'package:comfi/pages/seller_section/seller_settings_screen.dart';
import 'package:comfi/pages/seller_section/sellers_theme_screen.dart';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/presentation/state/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../consts/colors.dart';

// Import your destination screens (create them if they don't exist yet)
import 'seller_section/seller_earnings_screen.dart';
import 'seller_section/seller_support_screen.dart';
// import 'seller_wallet_screen.dart';   // optional – if #6B4EFF is a wallet/balance page

class SellerMenuScreen extends StatelessWidget {
  const SellerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE CARD (already clickable – good)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellerProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B4EFF), Color(0xFF4A63F6)],
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.person_outline, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// MENU ITEMS – now all clickable
              _menuItem(
                context: context,
                icon: Icons.color_lens_outlined,
                title:
                    "#6B4EFF", // ← maybe rename to "Wallet", "Balance", "Theme" etc.?
                destination:
                    const SellersThemeScreen(), // or const SellerWalletScreen()
              ),
              _menuItem(
                context: context,
                icon: Icons.settings_outlined,
                title: "Settings",
                destination: const SellerSettingsScreen(),
              ),
              _menuItem(
                context: context,
                icon: Icons.attach_money_outlined,
                title: "Earnings",
                destination: const SellerEarningsScreen(),
              ),
              _menuItem(
                context: context,
                icon: Icons.support_agent_outlined,
                title: "Support",
                destination: const SellerSupportScreen(),
              ),

              const Spacer(),

              /// Logout – also made tappable (with confirmation recommended)
              InkWell(
                onTap: () async {
                  await context.read<AuthController>().logoutUser();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logging out...")),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(18),
      splashColor: const Color(0xFF6B4EFF).withOpacity(0.3),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            // Optional: arrow indicator (very common in menus)
            const Icon(Icons.chevron_right, color: Colors.white54, size: 26),
          ],
        ),
      ),
    );
  }
}
