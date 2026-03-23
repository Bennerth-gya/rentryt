import 'package:comfi/consts/app_theme.dart';
import 'package:flutter/material.dart';
import 'seller_section/sellers_main_screen.dart';

class BecomeSellerScreen extends StatefulWidget {
  const BecomeSellerScreen({super.key});

  @override
  State<BecomeSellerScreen> createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  String shopName    = '';
  String phone       = '';
  String location    = 'Tarkwa, Ghana';
  String description = '';
  bool _isSubmitting = false;

  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF34D399), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Seller account created! Welcome aboard.',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SellerMainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Theme tokens ──────────────────────────────────────
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg        = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.45) : const Color(0xFF64748B);
    final labelColor    = isDark ? Colors.white.withOpacity(0.4)  : const Color(0xFF6B7280);
    final inputTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final hintColor     = isDark ? Colors.white.withOpacity(0.25) : const Color(0xFFADB5C7);
    final iconColor     = isDark ? const Color(0xFF8B5CF6) : const Color(0xFF7C3AED);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ── SLIVER APP BAR ──────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF6D28D9),
            elevation: 0,
            leading: IconButton(
              icon: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4C1D95),
                          Color(0xFF6D28D9),
                          Color(0xFF8B5CF6),
                        ],
                      ),
                    ),
                  ),

                  // Decorative orbs
                  Positioned(
                    top: -40, right: -40,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20, left: -30,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),

                  // Content
                  Positioned.fill(
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 32),

                          // Store icon badge
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4C1D95)
                                      .withOpacity(0.5),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              size: 40, color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            'Become a Seller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Start selling your products on Comfi',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Feature badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _HeroBadge(label: 'Free Setup'),
                              const SizedBox(width: 8),
                              _HeroBadge(label: 'Fast Review'),
                              const SizedBox(width: 8),
                              _HeroBadge(label: 'Secure'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── FORM BODY ────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 4),

                        // ── Section label ─────────────────
                        Text('Shop details',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Tell us about your shop',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Shop Name ─────────────────────
                        _FieldLabel(
                            label: 'Shop name', isDark: isDark),
                        const SizedBox(height: 8),
                        _InputField(
                          hintText: 'e.g. Bennerth Fashion Hub',
                          icon: Icons.store_rounded,
                          keyboardType: TextInputType.text,
                          surfaceColor: surfaceColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          labelColor: labelColor,
                          inputTextColor: inputTextColor,
                          hintColor: hintColor,
                          iconColor: iconColor,
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Shop name is required'
                                  : null,
                          onSaved: (v) => shopName = v!.trim(),
                        ),

                        const SizedBox(height: 18),

                        // ── Phone ─────────────────────────
                        _FieldLabel(
                            label: 'Phone number', isDark: isDark),
                        const SizedBox(height: 8),
                        _InputField(
                          hintText: '+233 24 123 4567',
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          surfaceColor: surfaceColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          labelColor: labelColor,
                          inputTextColor: inputTextColor,
                          hintColor: hintColor,
                          iconColor: iconColor,
                          validator: (v) =>
                              v == null || v.length < 9
                                  ? 'Enter a valid phone number'
                                  : null,
                          onSaved: (v) => phone = v!.trim(),
                        ),

                        const SizedBox(height: 18),

                        // ── Location ──────────────────────
                        _FieldLabel(
                            label: 'Location', isDark: isDark),
                        const SizedBox(height: 8),
                        _InputField(
                          hintText: 'Market Street, Tarkwa',
                          icon: Icons.location_on_rounded,
                          keyboardType: TextInputType.streetAddress,
                          surfaceColor: surfaceColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          labelColor: labelColor,
                          inputTextColor: inputTextColor,
                          hintColor: hintColor,
                          iconColor: iconColor,
                          onSaved: (v) =>
                              location = v?.trim() ?? location,
                        ),

                        const SizedBox(height: 18),

                        // ── Description ───────────────────
                        _FieldLabel(
                            label: 'About your shop',
                            isDark: isDark),
                        const SizedBox(height: 8),
                        _InputField(
                          hintText: 'Tell customers what you sell...',
                          icon: Icons.info_outline_rounded,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          surfaceColor: surfaceColor,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          labelColor: labelColor,
                          inputTextColor: inputTextColor,
                          hintColor: hintColor,
                          iconColor: iconColor,
                          onSaved: (v) =>
                              description = v?.trim() ?? '',
                        ),

                        const SizedBox(height: 32),

                        // ── Info card ─────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6)
                                .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6)
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF8B5CF6),
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your application will be reviewed shortly. You can start adding products once approved.',
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFA78BFA)
                                        : const Color(0xFF6D28D9),
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Submit button ─────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              disabledBackgroundColor:
                                  const Color(0xFF7C3AED).withOpacity(0.5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.storefront_rounded,
                                          color: Colors.white, size: 18),
                                      SizedBox(width: 10),
                                      Text(
                                        'Create Seller Account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero badge ────────────────────────────────────────────────────────────────
class _HeroBadge extends StatelessWidget {
  final String label;
  const _HeroBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Field label ───────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _FieldLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isDark ? Colors.white.withOpacity(0.75) : const Color(0xFF374151),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

// ── Input field ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;
  final Color surfaceColor;
  final Color cardBg;
  final Color borderColor;
  final Color labelColor;
  final Color inputTextColor;
  final Color hintColor;
  final Color iconColor;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const _InputField({
    required this.hintText,
    required this.icon,
    required this.keyboardType,
    required this.surfaceColor,
    required this.cardBg,
    required this.borderColor,
    required this.labelColor,
    required this.inputTextColor,
    required this.hintColor,
    required this.iconColor,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: inputTextColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        prefixIcon: Icon(icon, color: iconColor, size: 20),
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFF8B5CF6), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFEF4444), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFEF4444), width: 1.8),
        ),
        errorStyle: const TextStyle(
          color: Color(0xFFEF4444),
          fontSize: 12,
        ),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}