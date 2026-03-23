
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../consts/theme_toggle_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Theme-aware tokens ──────────────────────────────────
    final scaffoldBg    = isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor  = isDark ? const Color(0xFF111827) : Colors.white;
    final inputFill     = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final borderColor   = isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFE2E8F0);
    final primaryText   = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF64748B);
    final labelColor    = isDark ? Colors.white.withOpacity(0.4) : const Color(0xFF94A3B8);
    final inputText     = isDark ? Colors.white : const Color(0xFF0F172A);
    final prefixColor   = isDark ? Colors.white.withOpacity(0.4) : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: surfaceColor,
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
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,

        // ✅ Theme toggle in AppBar actions
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16, top: 8, bottom: 8),
            child: ThemeToggleButton(
              surfaceColor: surfaceColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Avatar section ────────────────────────────
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFF8B5CF6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6)
                                .withOpacity(0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(100),
                        child: const Image(
                          image: AssetImage(
                              'assets/images/strive.jpg'),
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
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
                              color: const Color(0xFF8B5CF6)
                                  .withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          LineAwesomeIcons.camera_solid,
                          color: Colors.white,
                          size: 16,
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

              // ── Personal Info section ─────────────────────
              _FormSectionLabel(
                  label: 'Personal Info',
                  color: secondaryText),
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
                keyboardType: TextInputType.emailAddress,
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

              // ── Security section ──────────────────────────
              _FormSectionLabel(
                  label: 'Security', color: secondaryText),
              const SizedBox(height: 14),

              // Password field
              TextFormField(
                obscureText: _obscurePassword,
                style:
                    TextStyle(color: inputText, fontSize: 15),
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
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: prefixColor,
                      size: 20,
                    ),
                    onPressed: () => setState(() =>
                        _obscurePassword = !_obscurePassword),
                  ),
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
                      color: Color(0xFF8B5CF6),
                      width: 1.8,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Save Button ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Joined date + Delete ──────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6)
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFF8B5CF6),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Member since',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '2 February, 2026',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444)
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
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
}

// ── Form section label ────────────────────────────────────────────────────────
class _FormSectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _FormSectionLabel(
      {required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
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
        prefixIcon: Icon(icon, color: prefixColor, size: 20),
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
          borderSide:
              const BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}