import 'package:comfi/components/section_container.dart';
import 'package:comfi/consts/theme_controller.dart';
import 'package:comfi/widgets/responsive/responsive.dart';
import 'package:comfi/widgets/responsive/responsive_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LargeScreenSettingsScreen extends StatefulWidget {
  const LargeScreenSettingsScreen({super.key});

  @override
  State<LargeScreenSettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<LargeScreenSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _orderUpdates = true;
  bool _promoAlerts = false;
  bool _newArrivals = true;
  bool _biometricLogin = false;
  bool _twoFactorAuth = true;
  bool _savePaymentInfo = false;
  bool _compactView = false;
  bool _autoPlayVideos = true;
  bool _dataSaver = false;

  String _selectedCurrency = 'GHS (₵)';
  String _selectedLanguage = 'English';
  int _selectedSectionIndex = 0;

  static const List<String> _currencies = <String>[
    'GHS (₵)',
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'NGN (₦)',
  ];

  static const List<String> _languages = <String>[
    'English',
    'French',
    'Twi',
    'Hausa',
    'Yoruba',
  ];

  void _showPicker({
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: borderColor),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              ...options.map(
                (option) => InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(option);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: option == selected
                          ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: option == selected
                                  ? const Color(0xFF8B5CF6)
                                  : primaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (option == selected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF8B5CF6),
                          )
                        else
                          Icon(
                            Icons.chevron_right_rounded,
                            color: secondaryText,
                          ),
                      ],
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

  void _showSaveSnackbar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Settings saved successfully',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);
    final sections = _buildSections(secondaryText);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: primaryText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: FilledButton.icon(
              onPressed: _showSaveSnackbar,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ResponsiveWrapper(
            maxWidth: 1100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SettingsProfileBanner(),
                const SizedBox(height: 24),
                if (!Responsive.isMobile(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Responsive.value(
                          context,
                          mobile: 280,
                          tablet: 240,
                          desktop: 280,
                        ),
                        child: _SettingsNavPanel(
                          sections: sections,
                          selectedIndex: _selectedSectionIndex,
                          onSelected: (index) {
                            setState(() => _selectedSectionIndex = index);
                          },
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _SettingsSectionCard(
                          section: sections[_selectedSectionIndex],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: sections
                        .map(
                          (section) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _SettingsSectionCard(section: section),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<_SettingsSection> _buildSections(Color secondaryText) {
    final themeController = Get.find<ThemeController>();

    return <_SettingsSection>[
      _SettingsSection(
        title: 'Appearance',
        description: 'Theme, density, and browsing comfort',
        icon: Icons.palette_rounded,
        accent: const Color(0xFF8B5CF6),
        children: [
          Obx(
            () => _SettingsSwitchTile(
              title: 'Dark mode',
              subtitle: 'Use the darker color palette across the app',
              icon: Icons.dark_mode_rounded,
              value: themeController.isDark,
              onChanged: (value) {
                if (themeController.isDark != value) {
                  themeController.toggleTheme();
                }
              },
            ),
          ),
          _SettingsSwitchTile(
            title: 'Compact view',
            subtitle: 'Show denser product cards on wider screens',
            icon: Icons.density_medium_rounded,
            value: _compactView,
            onChanged: (value) => setState(() => _compactView = value),
          ),
          _SettingsSwitchTile(
            title: 'Auto-play videos',
            subtitle: 'Play product media automatically where supported',
            icon: Icons.play_circle_fill_rounded,
            value: _autoPlayVideos,
            onChanged: (value) => setState(() => _autoPlayVideos = value),
          ),
        ],
      ),
      _SettingsSection(
        title: 'Notifications',
        description: 'Control how Comfi reaches you',
        icon: Icons.notifications_active_rounded,
        accent: const Color(0xFFF59E0B),
        children: [
          _SettingsSwitchTile(
            title: 'Push notifications',
            subtitle: 'Instant alerts for deliveries and chat updates',
            icon: Icons.notifications_rounded,
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          _SettingsSwitchTile(
            title: 'Email notifications',
            subtitle: 'Order receipts and important account messages',
            icon: Icons.mail_rounded,
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          _SettingsSwitchTile(
            title: 'Order updates',
            subtitle: 'Track delivery and payment milestones',
            icon: Icons.local_shipping_rounded,
            value: _orderUpdates,
            onChanged: (value) => setState(() => _orderUpdates = value),
          ),
          _SettingsSwitchTile(
            title: 'Promo alerts',
            subtitle: 'Flash deals, drops, and category promotions',
            icon: Icons.local_offer_rounded,
            value: _promoAlerts,
            onChanged: (value) => setState(() => _promoAlerts = value),
          ),
          _SettingsSwitchTile(
            title: 'New arrivals',
            subtitle: 'Be first to hear about fresh inventory',
            icon: Icons.new_releases_rounded,
            value: _newArrivals,
            onChanged: (value) => setState(() => _newArrivals = value),
          ),
        ],
      ),
      _SettingsSection(
        title: 'Security',
        description: 'Protect your account and payment flow',
        icon: Icons.shield_rounded,
        accent: const Color(0xFF10B981),
        children: [
          _SettingsSwitchTile(
            title: 'Biometric login',
            subtitle: 'Use fingerprint or face unlock where available',
            icon: Icons.fingerprint_rounded,
            value: _biometricLogin,
            onChanged: (value) => setState(() => _biometricLogin = value),
          ),
          _SettingsSwitchTile(
            title: 'Two-factor authentication',
            subtitle: 'Add an extra verification step on sign in',
            icon: Icons.security_rounded,
            value: _twoFactorAuth,
            onChanged: (value) => setState(() => _twoFactorAuth = value),
          ),
          _SettingsSwitchTile(
            title: 'Save payment details',
            subtitle: 'Remember payment methods for faster checkout',
            icon: Icons.payment_rounded,
            value: _savePaymentInfo,
            onChanged: (value) => setState(() => _savePaymentInfo = value),
          ),
        ],
      ),
      _SettingsSection(
        title: 'Preferences',
        description: 'Language, currency, and data usage',
        icon: Icons.tune_rounded,
        accent: const Color(0xFF0EA5E9),
        children: [
          _SettingsValueTile(
            title: 'Currency',
            subtitle: 'Choose how product prices are displayed',
            icon: Icons.payments_rounded,
            value: _selectedCurrency,
            onTap: () => _showPicker(
              title: 'Select currency',
              options: _currencies,
              selected: _selectedCurrency,
              onSelected: (value) => setState(() => _selectedCurrency = value),
            ),
          ),
          _SettingsValueTile(
            title: 'Language',
            subtitle: 'Pick the language used around the app',
            icon: Icons.language_rounded,
            value: _selectedLanguage,
            onTap: () => _showPicker(
              title: 'Select language',
              options: _languages,
              selected: _selectedLanguage,
              onSelected: (value) => setState(() => _selectedLanguage = value),
            ),
          ),
          _SettingsSwitchTile(
            title: 'Data saver',
            subtitle: 'Load lighter media when bandwidth is limited',
            icon: Icons.data_saver_off_rounded,
            value: _dataSaver,
            onChanged: (value) => setState(() => _dataSaver = value),
          ),
        ],
      ),
      _SettingsSection(
        title: 'Privacy',
        description: 'Legal information and local app data',
        icon: Icons.lock_person_rounded,
        accent: const Color(0xFFEF4444),
        children: [
          const _SettingsActionTile(
            title: 'Privacy policy',
            subtitle: 'See how Comfi handles your account and order data',
            icon: Icons.policy_rounded,
          ),
          const _SettingsActionTile(
            title: 'Terms of service',
            subtitle: 'Review the rules for using the Comfi marketplace',
            icon: Icons.article_rounded,
          ),
          _SettingsActionTile(
            title: 'Clear cache',
            subtitle: 'Free up local storage used by media previews',
            icon: Icons.delete_sweep_rounded,
            labelColor: const Color(0xFFEF4444),
            trailing: Text(
              '45.2 MB',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

class _SettingsProfileBanner extends StatelessWidget {
  const _SettingsProfileBanner();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      padding: const EdgeInsets.all(24),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4C1D95), Color(0xFF7C3AED), Color(0xFF8B5CF6)],
      ),
      borderColor: Colors.transparent,
      showShadow: false,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/strive.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.white.withValues(alpha: 0.16),
                  child: const Icon(Icons.person_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Systrom',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'gbennerth@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Buyer workspace synced across mobile, tablet, and desktop.',
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavPanel extends StatelessWidget {
  const _SettingsNavPanel({
    required this.sections,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_SettingsSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sections',
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Jump between settings groups on larger screens.',
            style: TextStyle(
              color: secondaryText,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          ...List<Widget>.generate(
            sections.length,
            (index) {
              final section = sections[index];
              final isSelected = index == selectedIndex;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => onSelected(index),
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? section.accent.withValues(alpha: 0.12)
                          : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? section.accent.withValues(alpha: 0.16)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(section.icon, color: section.accent),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section.title,
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                section.description,
                                style: TextStyle(
                                  color: secondaryText,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionCard extends StatelessWidget {
  const _SettingsSectionCard({required this.section});

  final _SettingsSection section;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: section.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(section.icon, color: section.accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section.description,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Column(
            children: List<Widget>.generate(
              section.children.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == section.children.length - 1 ? 0 : 12,
                ),
                child: section.children[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  const _SettingsSwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsValueTile extends StatelessWidget {
  const _SettingsValueTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF8B5CF6)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.chevron_right_rounded, color: secondaryText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.labelColor,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color? labelColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryText = labelColor ?? (isDark ? Colors.white : const Color(0xFF0F172A));
    final secondaryText = isDark
        ? Colors.white.withValues(alpha: 0.58)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          trailing ?? Icon(Icons.chevron_right_rounded, color: secondaryText),
        ],
      ),
    );
  }
}

class _SettingsSection {
  const _SettingsSection({
    required this.title,
    required this.description,
    required this.icon,
    required this.accent,
    required this.children,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color accent;
  final List<Widget> children;
}
