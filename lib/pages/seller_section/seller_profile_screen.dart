
//import 'package:comfi/pages/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../consts/theme_toggle_button.dart';
import 'seller_update_profile_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    // ── Theme tokens ──────────────────────────────
    final scaffoldBg = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.5)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(
            bottom: BorderSide(color: borderColor)),
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scaffoldBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Icon(
              LineAwesomeIcons.angle_left_solid,
              color: primaryText,
              size: 18,
            ),
          ),
        ),
        title: Text('Seller Profile',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          // ✅ Theme toggle
          Padding(
            padding: const EdgeInsets.only(
                right: 16, top: 8, bottom: 8),
            child: ThemeToggleButton(
              surfaceColor: scaffoldBg,
              borderColor: borderColor,
              size: 38,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 28),

              // ── Profile hero card ─────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius:
                      BorderRadius.circular(28),
                  border: Border.all(color: borderColor),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: Column(
                  children: [

                    // Avatar + store badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Gradient ring
                        Container(
                          padding:
                              const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                const LinearGradient(
                              colors: [
                                Color(0xFF7C3AED),
                                Color(0xFF8B5CF6),
                              ],
                              begin:
                                  Alignment.topLeft,
                              end: Alignment
                                  .bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                        0xFF8B5CF6)
                                    .withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(
                                    0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/strive.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Edit pencil
                        Positioned(
                          bottom: 2, right: 2,
                          child: GestureDetector(
                            onTap: () => Get.to(
                                () => const SellerUpdateProfileScreen()),
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFF8B5CF6),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: surfaceColor,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                            0xFF8B5CF6)
                                        .withOpacity(
                                            0.4),
                                    blurRadius: 8,
                                    offset:
                                        const Offset(
                                            0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LineAwesomeIcons
                                    .pencil_alt_solid,
                                color: Colors.white,
                                size: 13,
                              ),
                            ),
                          ),
                        ),

                        // Verified seller badge
                        Positioned(
                          top: -6, right: -6,
                          child: Container(
                            padding:
                                const EdgeInsets.all(
                                    4),
                            decoration: BoxDecoration(
                              color: const Color(
                                  0xFF34D399),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: surfaceColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Name
                    Text('Bennerth Systrom',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Email
                    Text('gbennerth@gmail.com',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Seller badge
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF8B5CF6),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.storefront_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(width: 6),
                          Text('Verified Seller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Stats row
                    Row(
                      children: [
                        _StatItem(
                          label: 'Products',
                          value: '24',
                          isDark: isDark,
                          cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          color:
                              const Color(0xFF8B5CF6),
                        ),
                        const SizedBox(width: 10),
                        _StatItem(
                          label: 'Orders',
                          value: '138',
                          isDark: isDark,
                          cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          color:
                              const Color(0xFF06B6D4),
                        ),
                        const SizedBox(width: 10),
                        _StatItem(
                          label: 'Revenue',
                          value: '12.4K',
                          isDark: isDark,
                          cardBg: cardBg,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          color:
                              const Color(0xFF34D399),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Edit profile button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() =>
                            const SellerUpdateProfileScreen()),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF7C3AED),
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    14),
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
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text('Edit Profile',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w700,
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

              // ── Store info card ───────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius:
                      BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: const Color(
                                    0xFF8B5CF6)
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(
                                    10),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Color(0xFF8B5CF6),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('Store Info',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      label: 'Location',
                      value: 'Huni Valley, Ghana',
                      color: const Color(0xFFE83A8A),
                      secondaryText: secondaryText,
                      primaryText: primaryText,
                    ),
                    Divider(
                        color: borderColor, height: 20),
                    _InfoRow(
                      icon: Icons.phone_rounded,
                      label: 'Phone',
                      value: '+233 24 123 4567',
                      color: const Color(0xFF34D399),
                      secondaryText: secondaryText,
                      primaryText: primaryText,
                    ),
                    Divider(
                        color: borderColor, height: 20),
                    _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Member Since',
                      value: 'February 2, 2026',
                      color: const Color(0xFF8B5CF6),
                      secondaryText: secondaryText,
                      primaryText: primaryText,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Account section ───────────────
              _SectionLabel(
                  label: 'Account',
                  color: secondaryText),
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
                    icon: LineAwesomeIcons
                        .wallet_solid,
                    label: 'Billing Details',
                    subtitle: 'Payment methods',
                    iconBg: const Color(0xFF34D399),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: LineAwesomeIcons
                        .user_check_solid,
                    label: 'User Management',
                    subtitle: 'Manage your account',
                    iconBg: const Color(0xFF06B6D4),
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Support section ───────────────
              _SectionLabel(
                  label: 'Support',
                  color: secondaryText),
              const SizedBox(height: 10),

              _MenuCard(
                isDark: isDark,
                surfaceColor: surfaceColor,
                borderColor: borderColor,
                primaryText: primaryText,
                secondaryText: secondaryText,
                items: [
                  _MenuItem(
                    icon: LineAwesomeIcons
                        .info_circle_solid,
                    label: 'Information',
                    subtitle: 'About & Help',
                    iconBg: const Color(0xFFF59E0B),
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: LineAwesomeIcons
                        .sign_out_alt_solid,
                    label: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconBg: const Color(0xFFEF4444),
                    labelColor: const Color(0xFFEF4444),
                    onTap: () =>
                        _showLogoutSheet(
                            context,
                            isDark,
                            surfaceColor,
                            borderColor,
                            primaryText,
                            secondaryText),
                    showDivider: false,
                    showArrow: false,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Version
              Text('Comfi Seller v1.0.0',
                style: TextStyle(
                  color: secondaryText
                      .withOpacity(0.5),
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutSheet(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin:
                  const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text('Logout?',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You will be signed out of your\nseller account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                      side: BorderSide(
                          color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Text('Cancel',
                      style: TextStyle(
                        color: primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFEF4444),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Yes, Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
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
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.isDark,
    required this.cardBg,
    required this.primaryText,
    required this.secondaryText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(label,
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color primaryText;
  final Color secondaryText;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(label,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(value,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel(
      {required this.label, required this.color});

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
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius:
                    BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          color: item.iconBg
                              .withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(
                                  13),
                        ),
                        child: Icon(item.icon,
                            color: item.iconBg,
                            size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(item.label,
                              style: TextStyle(
                                color: item
                                        .labelColor ??
                                    primaryText,
                                fontSize: 14.5,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(item.subtitle,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.showArrow)
                        Icon(
                          Icons
                              .arrow_forward_ios_rounded,
                          size: 14,
                          color: secondaryText,
                        ),
                    ],
                  ),
                ),
              ),
              if (item.showDivider)
                Divider(
                  height: 1,
                  thickness: 1,
                  color: borderColor,
                  indent: 72,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}