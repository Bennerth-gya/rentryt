import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MobileSettingsScreen extends StatefulWidget {
  const MobileSettingsScreen({super.key});

  @override
  State<MobileSettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<MobileSettingsScreen>
    with SingleTickerProviderStateMixin {
  // ── Toggle states ──────────────────────────────────────────────────────────
  bool _pushNotifications  = true;
  bool _emailNotifications = false;
  bool _orderUpdates       = true;
  bool _promoAlerts        = false;
  bool _newArrivals        = true;
  bool _biometricLogin     = false;
  bool _twoFactorAuth      = true;
  bool _savePaymentInfo    = false;
  bool _darkMode           = true;
  bool _compactView        = false;
  bool _autoPlayVideos     = true;
  bool _dataSaver          = false;

  String _selectedCurrency = 'GHS (₵)';
  String _selectedLanguage = 'English';

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  final List<String> _currencies = [
    'GHS (₵)', 'USD (\$)', 'EUR (€)', 'GBP (£)', 'NGN (₦)',
  ];
  final List<String> _languages = [
    'English', 'French', 'Twi', 'Hausa', 'Yoruba',
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _showPicker({
    required BuildContext ctx,
    required String title,
    required List<String> options,
    required String selected,
    required ValueChanged<String> onSelect,
    required Color primaryText,
    required Color secondaryText,
    required Color surfaceColor,
    required Color borderColor,
    required bool isDark,
  }) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(title,
              style: TextStyle(
                color: primaryText,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map((opt) {
              final isSelected = opt == selected;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelect(opt);
                  Navigator.pop(ctx);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF8B5CF6).withOpacity(0.12)
                        : isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF8B5CF6).withOpacity(0.4)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(opt,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF8B5CF6)
                                : primaryText,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF8B5CF6), size: 20),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showSaveSnackbar(BuildContext ctx, bool isDark) {
    ScaffoldMessenger.of(ctx).clearSnackBars();
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF34D399), size: 18),
            ),
            const SizedBox(width: 12),
            Text('Settings saved successfully',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark        = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg        = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF64748B);
    const accent        = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                color: primaryText, size: 16),
          ),
        ),
        title: Text('Settings',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showSaveSnackbar(context, isDark);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text('Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── Profile Banner ─────────────────────────────────────────
                _ProfileBanner(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),

                const SizedBox(height: 28),

                // ── APPEARANCE ─────────────────────────────────────────────
                _SectionLabel(label: 'Appearance', color: secondaryText),
                const SizedBox(height: 10),
                _SettingsCard(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  children: [
                    _ToggleTile(
                      icon: LineAwesomeIcons.moon,
                      iconBg: const Color(0xFF7C3AED),
                      label: 'Dark Mode',
                      subtitle: 'Switch to dark interface',
                      value: _darkMode,
                      onChanged: (v) => setState(() => _darkMode = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.th_large_solid,
                      iconBg: const Color(0xFF0284C7),
                      label: 'Compact View',
                      subtitle: 'Denser product grid layout',
                      value: _compactView,
                      onChanged: (v) => setState(() => _compactView = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.play_circle,
                      iconBg: const Color(0xFFE83A8A),
                      label: 'Auto-play Videos',
                      subtitle: 'Play product videos automatically',
                      value: _autoPlayVideos,
                      onChanged: (v) => setState(() => _autoPlayVideos = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── NOTIFICATIONS ──────────────────────────────────────────
                _SectionLabel(label: 'Notifications', color: secondaryText),
                const SizedBox(height: 10),
                _SettingsCard(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  children: [
                    _ToggleTile(
                      icon: LineAwesomeIcons.bell,
                      iconBg: const Color(0xFFF59E0B),
                      label: 'Push Notifications',
                      subtitle: 'Receive alerts on your device',
                      value: _pushNotifications,
                      onChanged: (v) => setState(() => _pushNotifications = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.envelope,
                      iconBg: const Color(0xFF059669),
                      label: 'Email Notifications',
                      subtitle: 'Get updates in your inbox',
                      value: _emailNotifications,
                      onChanged: (v) => setState(() => _emailNotifications = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.box_solid,
                      iconBg: const Color(0xFF0284C7),
                      label: 'Order Updates',
                      subtitle: 'Track your deliveries in real-time',
                      value: _orderUpdates,
                      onChanged: (v) => setState(() => _orderUpdates = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.tag_solid,
                      iconBg: const Color(0xFFEF4444),
                      label: 'Promo & Deals',
                      subtitle: 'Flash sales and discount alerts',
                      value: _promoAlerts,
                      onChanged: (v) => setState(() => _promoAlerts = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.star,
                      iconBg: const Color(0xFF8B5CF6),
                      label: 'New Arrivals',
                      subtitle: 'Be first to know about new stock',
                      value: _newArrivals,
                      onChanged: (v) => setState(() => _newArrivals = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── SECURITY ───────────────────────────────────────────────
                _SectionLabel(label: 'Security', color: secondaryText),
                const SizedBox(height: 10),
                _SettingsCard(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  children: [
                    _ToggleTile(
                      icon: LineAwesomeIcons.fingerprint_solid,
                      iconBg: const Color(0xFF059669),
                      label: 'Biometric Login',
                      subtitle: 'Use fingerprint or face ID',
                      value: _biometricLogin,
                      onChanged: (v) => setState(() => _biometricLogin = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.shield_alt_solid,
                      iconBg: const Color(0xFF0284C7),
                      label: 'Two-Factor Auth',
                      subtitle: 'Add an extra layer of protection',
                      value: _twoFactorAuth,
                      onChanged: (v) => setState(() => _twoFactorAuth = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.credit_card,
                      iconBg: const Color(0xFFF59E0B),
                      label: 'Save Payment Info',
                      subtitle: 'Remember cards for faster checkout',
                      value: _savePaymentInfo,
                      onChanged: (v) => setState(() => _savePaymentInfo = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── PREFERENCES ────────────────────────────────────────────
                _SectionLabel(label: 'Preferences', color: secondaryText),
                const SizedBox(height: 10),
                _SettingsCard(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  children: [
                    _PickerTile(
                      icon: LineAwesomeIcons.money_bill_wave_solid,
                      iconBg: const Color(0xFF059669),
                      label: 'Currency',
                      subtitle: 'Display prices in your currency',
                      value: _selectedCurrency,
                      onTap: () => _showPicker(
                        ctx: context,
                        title: 'Select Currency',
                        options: _currencies,
                        selected: _selectedCurrency,
                        onSelect: (v) => setState(() => _selectedCurrency = v),
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        isDark: isDark,
                      ),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _PickerTile(
                      icon: LineAwesomeIcons.language_solid,
                      iconBg: const Color(0xFF8B5CF6),
                      label: 'Language',
                      subtitle: 'Choose your preferred language',
                      value: _selectedLanguage,
                      onTap: () => _showPicker(
                        ctx: context,
                        title: 'Select Language',
                        options: _languages,
                        selected: _selectedLanguage,
                        onSelect: (v) => setState(() => _selectedLanguage = v),
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        isDark: isDark,
                      ),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _ToggleTile(
                      icon: LineAwesomeIcons.tachometer_alt_solid,
                      iconBg: const Color(0xFF0284C7),
                      label: 'Data Saver',
                      subtitle: 'Reduce image quality to save data',
                      value: _dataSaver,
                      onChanged: (v) => setState(() => _dataSaver = v),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showDivider: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── PRIVACY ────────────────────────────────────────────────
                _SectionLabel(label: 'Privacy', color: secondaryText),
                const SizedBox(height: 10),
                _SettingsCard(
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  children: [
                    _NavTile(
                      icon: LineAwesomeIcons.user_shield_solid,
                      iconBg: const Color(0xFF8B5CF6),
                      label: 'Privacy Policy',
                      subtitle: 'How we handle your data',
                      onTap: () {},
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _NavTile(
                      icon: LineAwesomeIcons.file_alt_solid,
                      iconBg: const Color(0xFF0284C7),
                      label: 'Terms of Service',
                      subtitle: 'Read our terms & conditions',
                      onTap: () {},
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                    ),
                    _Divider(color: borderColor),
                    _NavTile(
                      icon: LineAwesomeIcons.trash_alt_solid,
                      iconBg: const Color(0xFFEF4444),
                      label: 'Clear Cache',
                      subtitle: 'Free up storage space',
                      labelColor: const Color(0xFFEF4444),
                      onTap: () => _confirmClearCache(
                        context, isDark, primaryText, surfaceColor, borderColor,
                      ),
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      showArrow: false,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── STORAGE INFO CARD ──────────────────────────────────────
                _StorageCard(
                  isDark: isDark,
                  cardBg: cardBg,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text('Comfi v1.0.0',
                    style: TextStyle(
                      color: secondaryText.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmClearCache(
    BuildContext ctx,
    bool isDark,
    Color primaryText,
    Color surfaceColor,
    Color borderColor,
  ) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LineAwesomeIcons.trash_alt_solid,
                  color: Color(0xFFEF4444), size: 24),
            ),
            const SizedBox(height: 16),
            Text('Clear Cache?',
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text('This will free up 45.2 MB of storage.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFEEF1FB),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: Text('Cancel',
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showSaveSnackbar(ctx, isDark);
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.3),
                        ),
                      ),
                      child: const Center(
                        child: Text('Clear',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile Banner ────────────────────────────────────────────────────────────
class _ProfileBanner extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryText;
  final Color secondaryText;

  const _ProfileBanner({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative orb
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30, left: 60,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Row(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage('assets/images/strive.jpg'),
                    width: 56, height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: _avatarFallback,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Systrom',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('gbennerth@gmail.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Text('Premium Member',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Edit icon
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(LineAwesomeIcons.pencil_alt_solid,
                    color: Colors.white, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _avatarFallback(BuildContext _, Object __, StackTrace? ___) {
    return Container(
      width: 56, height: 56,
      color: const Color(0xFF7C3AED),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
    );
  }
}

// ── Storage Info Card ─────────────────────────────────────────────────────────
class _StorageCard extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color primaryText;
  final Color secondaryText;

  const _StorageCard({
    required this.isDark,
    required this.cardBg,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LineAwesomeIcons.hdd,
                    color: Color(0xFF8B5CF6), size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Storage Used',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('45.2 MB of 500 MB',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text('9%',
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.09,
              minHeight: 6,
              backgroundColor: isDark
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StorageDot(color: const Color(0xFF8B5CF6), label: 'Cache'),
              const SizedBox(width: 16),
              _StorageDot(color: const Color(0xFF34D399), label: 'Images'),
              const SizedBox(width: 16),
              _StorageDot(color: const Color(0xFF0284C7), label: 'Data'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StorageDot extends StatelessWidget {
  final Color color;
  final String label;
  const _StorageDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
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

// ── Settings Card ─────────────────────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.children,
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
      child: Column(children: children),
    );
  }
}

// ── Toggle Tile ───────────────────────────────────────────────────────────────
class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color primaryText;
  final Color secondaryText;
  final bool showDivider;

  const _ToggleTile({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.primaryText,
    required this.secondaryText,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: iconBg.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconBg, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                  style: TextStyle(fontSize: 12, color: secondaryText),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
            activeColor: const Color(0xFF8B5CF6),
            trackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

// ── Picker Tile ───────────────────────────────────────────────────────────────
class _PickerTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String subtitle;
  final String value;
  final VoidCallback onTap;
  final Color primaryText;
  final Color secondaryText;

  const _PickerTile({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onTap,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconBg, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(value,
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: secondaryText),
          ],
        ),
      ),
    );
  }
}

// ── Nav Tile ──────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color primaryText;
  final Color secondaryText;
  final Color? labelColor;
  final bool showArrow;

  const _NavTile({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.primaryText,
    required this.secondaryText,
    this.labelColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconBg, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor ?? primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                    style: TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: secondaryText),
          ],
        ),
      ),
    );
  }
}

// ── Divider ───────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: color, indent: 72);
  }
}
