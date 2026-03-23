
import 'package:comfi/consts/theme_toggle_button.dart' show ThemeToggleButton;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SellerUpdateProfileScreen extends StatefulWidget {
  const SellerUpdateProfileScreen({super.key});

  @override
  State<SellerUpdateProfileScreen> createState() =>
      _SellerUpdateProfileScreenState();
}

class _SellerUpdateProfileScreenState
    extends State<SellerUpdateProfileScreen> {
  bool _obscurePassword = true;

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
    final inputFill = isDark
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
    final labelColor = isDark
        ? Colors.white.withOpacity(0.4)
        : const Color(0xFF94A3B8);
    final inputText =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final prefixColor = isDark
        ? Colors.white.withOpacity(0.4)
        : const Color(0xFF94A3B8);

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
              LineAwesomeIcons.angle_double_left_solid,
              color: primaryText,
              size: 18,
            ),
          ),
        ),
        title: Text('Edit Seller Profile',
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ── Avatar section ──────────────────
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Gradient ring + photo
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
                          begin: Alignment.topLeft,
                          end:
                              Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                                    0xFF8B5CF6)
                                .withOpacity(0.45),
                            blurRadius: 24,
                            offset:
                                const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/strive.jpg',
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Camera button
                    Positioned(
                      bottom: 2, right: 2,
                      child: GestureDetector(
                        onTap: () =>
                            HapticFeedback
                                .lightImpact(),
                        child: Container(
                          width: 36, height: 36,
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
                              color: scaffoldBg,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                        0xFF8B5CF6)
                                    .withOpacity(
                                        0.4),
                                blurRadius: 10,
                                offset:
                                    const Offset(
                                        0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LineAwesomeIcons
                                .camera_solid,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),

                    // Verified seller badge
                    Positioned(
                      top: -4, right: -4,
                      child: Container(
                        padding:
                            const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF34D399),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: scaffoldBg,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white,
                          size: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Tap camera to change photo',
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Personal info ───────────────────
              _FormSectionLabel(
                label: 'Personal Info',
                color: secondaryText,
              ),
              const SizedBox(height: 14),

              _ThemedField(
                label: 'Full Name',
                icon: Icons.person_outline_rounded,
                keyboardType: TextInputType.name,
                inputFill: inputFill,
                borderColor: borderColor,
                inputText: inputText,
                labelColor: labelColor,
                prefixColor: prefixColor,
              ),
              const SizedBox(height: 14),

              _ThemedField(
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType:
                    TextInputType.emailAddress,
                inputFill: inputFill,
                borderColor: borderColor,
                inputText: inputText,
                labelColor: labelColor,
                prefixColor: prefixColor,
              ),
              const SizedBox(height: 14),

              _ThemedField(
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                inputFill: inputFill,
                borderColor: borderColor,
                inputText: inputText,
                labelColor: labelColor,
                prefixColor: prefixColor,
              ),

              const SizedBox(height: 28),

              // ── Business info ───────────────────
              _FormSectionLabel(
                label: 'Business Info',
                color: secondaryText,
              ),
              const SizedBox(height: 14),

              _ThemedField(
                label: 'Business Name',
                icon: Icons.storefront_rounded,
                keyboardType: TextInputType.name,
                inputFill: inputFill,
                borderColor: borderColor,
                inputText: inputText,
                labelColor: labelColor,
                prefixColor: prefixColor,
              ),
              const SizedBox(height: 14),

              _ThemedField(
                label: 'Business Location',
                icon: Icons.location_on_rounded,
                keyboardType: TextInputType.text,
                inputFill: inputFill,
                borderColor: borderColor,
                inputText: inputText,
                labelColor: labelColor,
                prefixColor: prefixColor,
              ),
              const SizedBox(height: 14),

              // Business category dropdown
              Container(
                decoration: BoxDecoration(
                  color: inputFill,
                  borderRadius:
                      BorderRadius.circular(14),
                  border:
                      Border.all(color: borderColor),
                ),
                child: DropdownButtonFormField<String>(
                  value: 'Fashion & Clothing',
                  style: TextStyle(
                      color: inputText, fontSize: 15),
                  dropdownColor: isDark
                      ? const Color(0xFF1F2937)
                      : Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF8B5CF6),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Business Category',
                    labelStyle: TextStyle(
                      color: labelColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.category_rounded,
                      color: const Color(0xFF8B5CF6),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: [
                    'Fashion & Clothing',
                    'Electronics',
                    'Food & Beverages',
                    'Health & Beauty',
                    'Home & Living',
                    'Education',
                    'Other',
                  ].map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat,
                      style: TextStyle(
                          color: inputText,
                          fontSize: 14),
                    ),
                  )).toList(),
                  onChanged: (_) {},
                ),
              ),

              const SizedBox(height: 28),

              // ── Security ────────────────────────
              _FormSectionLabel(
                label: 'Security',
                color: secondaryText,
              ),
              const SizedBox(height: 14),

              // Password field
              TextFormField(
                obscureText: _obscurePassword,
                style: TextStyle(
                    color: inputText, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: labelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: prefixColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: prefixColor,
                      size: 20,
                    ),
                    onPressed: () => setState(() =>
                        _obscurePassword =
                            !_obscurePassword),
                  ),
                  filled: true,
                  fillColor: inputFill,
                  contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 1.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Save button ─────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
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
                          BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                                  0xFF8B5CF6)
                              .withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded,
                              color: Colors.white,
                              size: 20),
                          SizedBox(width: 8),
                          Text('Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Member since + delete ───────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius:
                      BorderRadius.circular(16),
                  border:
                      Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                            Icons
                                .calendar_today_rounded,
                            color: Color(0xFF8B5CF6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text('Seller since',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text('2 February, 2026',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () =>
                          _showDeleteSheet(
                        context,
                        isDark,
                        surfaceColor,
                        borderColor,
                        primaryText,
                        secondaryText,
                      ),
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                                  0xFFEF4444)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(
                                  20),
                          border: Border.all(
                            color: const Color(
                                    0xFFEF4444)
                                .withOpacity(0.2),
                          ),
                        ),
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteSheet(
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
                Icons.delete_forever_rounded,
                color: Color(0xFFEF4444),
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text('Delete Account?',
              style: TextStyle(
                color: primaryText,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will permanently delete your seller\naccount and all your products.\nThis action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
                height: 1.6,
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
                    onPressed: () =>
                        Navigator.pop(context),
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
                    child: const Text('Yes, Delete',
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

// ── Form section label ────────────────────────────────────────────────────────
class _FormSectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _FormSectionLabel({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(label.toUpperCase(),
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ── Reusable themed text field ────────────────────────────────────────────────
class _ThemedField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final Color inputFill;
  final Color borderColor;
  final Color inputText;
  final Color labelColor;
  final Color prefixColor;

  const _ThemedField({
    required this.label,
    required this.icon,
    required this.inputFill,
    required this.borderColor,
    required this.inputText,
    required this.labelColor,
    required this.prefixColor,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      style: TextStyle(color: inputText, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon,
            color: const Color(0xFF8B5CF6), size: 20),
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFF8B5CF6), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}