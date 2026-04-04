import 'package:flutter/material.dart';

//import 'package:comfi/models/profile_body.dart';
import 'package:comfi/pages/update_profile_screen.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

//import '../consts/theme_toggle_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg        = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        
        // title: Text('Profile',
        //   style: TextStyle(
        //     color: primaryText,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w700,
        //     letterSpacing: -0.3,
        //   ),
        // ),
        centerTitle: true,
        actions: [
          // ✅ Replaced sun/moon IconButton with ThemeToggleButton
          Padding(
            padding: const EdgeInsets.only(
                right: 16, top: 8, bottom: 8),
            // child: ThemeToggleButton(
            //   surfaceColor: surfaceColor,
            //   borderColor: borderColor,
            //   size: 38,
            // ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // ── Profile Card ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF7C3AED),
                                Color(0xFF8B5CF6)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6)
                                    .withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/strive.jpg'),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 2, right: 2,
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF7C3AED),
                                  Color(0xFF8B5CF6)
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: surfaceColor, width: 2),
                            ),
                            child: const Icon(
                              LineAwesomeIcons.pencil_alt_solid,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text('Systrom',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: primaryText,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('gbennerth@gmail.com',
                      style: TextStyle(
                          fontSize: 13, color: secondaryText),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Premium Member',
                        style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatItem(
                          label: 'Orders', value: '12',
                          isDark: isDark, cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                        ),
                        const SizedBox(width: 10),
                        _StatItem(
                          label: 'Wishlist', value: '5',
                          isDark: isDark, cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                        ),
                        const SizedBox(width: 10),
                        _StatItem(
                          label: 'Reviews', value: '8',
                          isDark: isDark, cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Get.to(
                            () => const UpdateProfileScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF7C3AED),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                                LineAwesomeIcons
                                    .pencil_alt_solid,
                                size: 16,
                                color: Colors.white),
                            SizedBox(width: 8),
                            Text('Edit Profile',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              _SectionLabel(
                  label: 'Account', color: secondaryText),
              const SizedBox(height: 10),

              _MenuCard(
                isDark: isDark,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                items: [
                  _MenuItem(
                    icon: LineAwesomeIcons.cog_solid,
                    label: 'Settings',
                    subtitle: 'App preferences',
                    iconBg: const Color(0xFF8B5CF6),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: LineAwesomeIcons.wallet_solid,
                    label: 'Billing Details',
                    subtitle: 'Payment methods',
                    iconBg: const Color(0xFF059669),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: LineAwesomeIcons.user_check_solid,
                    label: 'User Management',
                    subtitle: 'Manage your account',
                    iconBg: const Color(0xFF0284C7),
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _SectionLabel(
                  label: 'Support', color: secondaryText),
              const SizedBox(height: 10),

              _MenuCard(
                isDark: isDark,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                items: [
                  _MenuItem(
                    icon: LineAwesomeIcons.info_circle_solid,
                    label: 'Information',
                    subtitle: 'About & Help',
                    iconBg: const Color(0xFFF59E0B),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: LineAwesomeIcons.sign_out_alt_solid,
                    label: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconBg: const Color(0xFFEF4444),
                    labelColor: const Color(0xFFEF4444),
                    onTap: () {},
                    showDivider: false,
                    showArrow: false,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text('Comfi v1.0.0',
                style: TextStyle(
                  color: secondaryText.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat item ─────────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color cardBg;
  final Color primaryText;
  final Color secondaryText;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isDark,
    required this.cardBg,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 2),
            Text(label,
              style: TextStyle(
                fontSize: 11,
                color: secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Menu card ─────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;
  final List<_MenuItem> items;

  const _MenuCard({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: items.map((item) {
          return _MenuTile(
            item: item,
            primaryText: primaryText,
            secondaryText: secondaryText,
            borderColor: borderColor,
          );
        }).toList(),
      ),
    );
  }
}

// ── Menu item data ────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconBg;
  final Color? labelColor;
  final VoidCallback onTap;
  final bool showDivider;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconBg,
    required this.onTap,
    this.labelColor,
    this.showDivider = true,
    this.showArrow = true,
  });
}

// ── Menu tile ─────────────────────────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  final _MenuItem item;
  final Color primaryText;
  final Color secondaryText;
  final Color borderColor;

  const _MenuTile({
    required this.item,
    required this.primaryText,
    required this.secondaryText,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: item.iconBg.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.icon,
                      color: item.iconBg, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(item.label,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color:
                              item.labelColor ?? primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(item.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.showArrow)
                  Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: secondaryText),
              ],
            ),
          ),
        ),
        if (item.showDivider)
          Divider(
            height: 1, thickness: 1,
            color: borderColor,
            indent: 72,
          ),
      ],
    );
  }
}