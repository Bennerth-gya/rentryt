import 'dart:io';
import 'package:comfi/core/constants/app_routes.dart';
import 'package:comfi/presentation/state/seller_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellerVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const SellerVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen>
    with TickerProviderStateMixin {
  // ── Step state ───────────────────────────────────────────────────────────
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // ── Animation ────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Step 1 – Identity ────────────────────────────────────────────────────
  final _idFormKey = GlobalKey<FormState>();
  final _idNumberCtrl = TextEditingController();
  final _idExpiryCtrl = TextEditingController();
  XFile? _idFrontPhoto;
  XFile? _idBackPhoto;

  // ── Step 2 – Phone OTP ───────────────────────────────────────────────────
  final List<TextEditingController> _otpCtrl =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocus = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _sendingOtp = false;
  bool _verifyingOtp = false;
  int _resendCountdown = 0;

  // ── Step 3 – Tier ────────────────────────────────────────────────────────
  int _selectedTier = -1;

  // ── Step 4 – Submitting ──────────────────────────────────────────────────
  bool _isSubmitting = false;

  // ── Misc ─────────────────────────────────────────────────────────────────
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.04, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _idNumberCtrl.dispose();
    _idExpiryCtrl.dispose();
    for (final c in _otpCtrl) c.dispose();
    for (final f in _otpFocus) f.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String get _phoneNumber {
    final submittedPhone =
        context.read<SellerOnboardingController>().lastSubmittedPhoneNumber;
    if (widget.phoneNumber.trim().isNotEmpty) {
      return widget.phoneNumber.trim();
    }
    return submittedPhone?.trim() ?? '';
  }

  void _animateToNextStep() {
    _fadeCtrl.reverse().then((_) {
      setState(() => _currentStep++);
      _fadeCtrl.forward();
    });
  }

  void _animateToPrevStep() {
    _fadeCtrl.reverse().then((_) {
      setState(() => _currentStep--);
      _fadeCtrl.forward();
    });
  }

  Future<void> _pickPhoto({
    required bool isIdFront,
    required bool isIdBack,
  }) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      if (isIdFront) _idFrontPhoto = file;
      if (isIdBack) _idBackPhoto = file;
    });
  }

  Future<void> _sendOtp() async {
    setState(() {
      _sendingOtp = true;
      _otpSent = false;
    });
    final message =
        await context.read<SellerOnboardingController>().sendOtp(_phoneNumber);
    if (!mounted) return;

    if (message != null) {
      setState(() => _sendingOtp = false);
      _showError(message);
      return;
    }

    setState(() {
      _sendingOtp = false;
      _otpSent = true;
      _resendCountdown = 60;
    });
    _startResendCountdown();
  }

  void _startResendCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendCountdown--);
      return _resendCountdown > 0;
    });
  }

  Future<void> _verifyOtp() async {
    final code = _otpCtrl.map((c) => c.text).join();
    if (code.length < 6) {
      _showError('Please enter the full 6-digit code.');
      return;
    }
    setState(() => _verifyingOtp = true);
    final message = await context.read<SellerOnboardingController>().verifyOtp(
          phoneNumber: _phoneNumber,
          code: code,
        );
    if (!mounted) return;

    if (message != null) {
      setState(() => _verifyingOtp = false);
      _showError(message);
      return;
    }

    setState(() {
      _verifyingOtp = false;
      _otpVerified = true;
    });
  }

  Future<void> _submitVerification() async {
    setState(() => _isSubmitting = true);
    final message =
        await context.read<SellerOnboardingController>().submitVerification(
              phoneNumber: _phoneNumber,
              idNumber: _idNumberCtrl.text.trim(),
              idExpiry: _idExpiryCtrl.text.trim(),
              selectedTier: _selectedTier,
            );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (message != null) {
      _showError(message);
      return;
    }

    _showPendingDialog();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFFEF4444),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  void _showPendingDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: Color(0xFF8B5CF6),
                size: 34,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Under Review',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your application has been submitted and is being reviewed. '
              'This usually takes 1–2 business days.\n\n'
              'You\'ll receive an SMS on $_phoneNumber once approved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.55)
                    : const Color(0xFF64748B),
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.sellerMain);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Can advance? ──────────────────────────────────────────────────────────
  bool get _canAdvance {
    switch (_currentStep) {
      case 0: // identity
        return _idFrontPhoto != null && _idBackPhoto != null;
      case 1: // otp
        return _otpVerified;
      case 2: // tier
        return _selectedTier >= 0;
      case 3: // review – submit button handles it
        return true;
      default:
        return false;
    }
  }

  // ── Step meta ─────────────────────────────────────────────────────────────
  static const _stepTitles = [
    'Identity',
    'Phone OTP',
    'Seller Tier',
    'Review',
  ];

  static const _stepIcons = [
    Icons.badge_rounded,
    Icons.sms_rounded,
    Icons.workspace_premium_rounded,
    Icons.fact_check_rounded,
  ];

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg =
        isDark ? const Color(0xFF080C14) : const Color(0xFFF5F7FF);
    final surfaceColor = isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvoked: (didPop) {
        if (!didPop && _currentStep > 0) _animateToPrevStep();
      },
      child: Scaffold(
        backgroundColor: scaffoldBg,
        body: Column(
          children: [
            _buildHeader(
                isDark, surfaceColor, borderColor, primaryText, secondaryText),
            _buildStepIndicator(isDark, borderColor),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    physics: const BouncingScrollPhysics(),
                    child: _buildCurrentStep(
                        isDark, surfaceColor, borderColor, primaryText, secondaryText),
                  ),
                ),
              ),
            ),
            _buildBottomCta(isDark, surfaceColor, borderColor),
          ],
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Row(
            children: [
              if (_currentStep > 0)
                GestureDetector(
                  onTap: _animateToPrevStep,
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _stepTitles[_currentStep],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Icon(_stepIcons[_currentStep],
                    color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── STEP INDICATOR ────────────────────────────────────────────────────────
  Widget _buildStepIndicator(bool isDark, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: List.generate(_totalSteps * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            final passed = stepIdx < _currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 3,
                decoration: BoxDecoration(
                  color: passed
                      ? const Color(0xFF8B5CF6)
                      : isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final isActive = stepIdx == _currentStep;
          final isDone = stepIdx < _currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 32 : 28,
            height: isActive ? 32 : 28,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFF8B5CF6)
                  : isActive
                      ? const Color(0xFF8B5CF6)
                      : isDark
                          ? Colors.white.withOpacity(0.07)
                          : const Color(0xFFEEF1FB),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive || isDone
                    ? const Color(0xFF8B5CF6)
                    : isDark
                        ? Colors.white.withOpacity(0.12)
                        : const Color(0xFFE2E8F0),
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : Text(
                      '${stepIdx + 1}',
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : isDark
                                ? Colors.white.withOpacity(0.3)
                                : const Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  // ── CURRENT STEP ─────────────────────────────────────────────────────────
  Widget _buildCurrentStep(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    switch (_currentStep) {
      case 0:
        return _buildIdentityStep(
            isDark, surfaceColor, borderColor, primaryText, secondaryText);
      case 1:
        return _buildOtpStep(
            isDark, surfaceColor, borderColor, primaryText, secondaryText);
      case 2:
        return _buildTierStep(
            isDark, surfaceColor, borderColor, primaryText, secondaryText);
      case 3:
        return _buildReviewStep(
            isDark, surfaceColor, borderColor, primaryText, secondaryText);
      default:
        return const SizedBox.shrink();
    }
  }

  // ── STEP 1: IDENTITY ──────────────────────────────────────────────────────
  Widget _buildIdentityStep(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    final cardBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
    final hintColor =
        isDark ? Colors.white.withOpacity(0.25) : const Color(0xFFADB5C7);
    final iconColor = const Color(0xFF8B5CF6);

    return Form(
      key: _idFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoBanner(
            isDark: isDark,
            message:
                'We use your Ghana Card to verify your identity. '
                'Your information is encrypted and never shared.',
          ),
          const SizedBox(height: 24),
          _FieldLabel(label: 'Ghana Card Number', isDark: isDark),
          const SizedBox(height: 8),
          TextFormField(
            controller: _idNumberCtrl,
            style: TextStyle(
                color: primaryText, fontSize: 15, letterSpacing: 1.2),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
              LengthLimitingTextInputFormatter(15),
              _GhanaCardFormatter(),
            ],
            decoration: _inputDecoration(
              hint: 'GHA-XXXXXXXXX-X',
              icon: Icons.credit_card_rounded,
              cardBg: cardBg,
              borderColor: borderColor,
              hintColor: hintColor,
              iconColor: iconColor,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ghana Card number is required';
              final re = RegExp(r'^GHA-\d{9}-\d$');
              if (!re.hasMatch(v)) return 'Format must be GHA-XXXXXXXXX-X';
              return null;
            },
          ),
          const SizedBox(height: 18),
          _FieldLabel(label: 'Card Expiry Date', isDark: isDark),
          const SizedBox(height: 8),
          TextFormField(
            controller: _idExpiryCtrl,
            style: TextStyle(color: primaryText, fontSize: 15),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              _ExpiryFormatter(),
            ],
            decoration: _inputDecoration(
              hint: 'MM/YY',
              icon: Icons.calendar_today_rounded,
              cardBg: cardBg,
              borderColor: borderColor,
              hintColor: hintColor,
              iconColor: iconColor,
            ),
            validator: (v) {
              if (v == null || v.length < 5) return 'Enter a valid expiry date';
              return null;
            },
          ),
          const SizedBox(height: 28),
          _SectionTitle(label: 'Upload ID Photos', primaryText: primaryText),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _PhotoUploadCard(
                  label: 'Front of Card',
                  icon: Icons.flip_to_front_rounded,
                  photo: _idFrontPhoto,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  onTap: () =>
                      _pickPhoto(isIdFront: true, isIdBack: false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PhotoUploadCard(
                  label: 'Back of Card',
                  icon: Icons.flip_to_back_rounded,
                  photo: _idBackPhoto,
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  onTap: () =>
                      _pickPhoto(isIdFront: false, isIdBack: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TipsCard(
            isDark: isDark,
            tips: const [
              'Make sure the card is fully visible',
              'Avoid glare and shadows',
              'Use a dark background for contrast',
            ],
          ),
        ],
      ),
    );
  }

  // ── STEP 2: OTP ───────────────────────────────────────────────────────────
  Widget _buildOtpStep(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          isDark: isDark,
          message:
              'We\'ll send a 6-digit code to $_phoneNumber to confirm ownership.',
        ),
        const SizedBox(height: 28),
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sms_rounded,
                    color: Color(0xFF8B5CF6), size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                _otpVerified
                    ? 'Phone Verified ✓'
                    : _otpSent
                        ? 'Enter the code sent to'
                        : 'Verify your phone number',
                style: TextStyle(
                    color: primaryText,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              if (_otpSent && !_otpVerified) ...[
                const SizedBox(height: 4),
                Text(
                  _phoneNumber,
                  style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        if (!_otpSent && !_otpVerified)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _sendingOtp ? null : _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                disabledBackgroundColor:
                    const Color(0xFF7C3AED).withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: _sendingOtp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
              label: Text(
                _sendingOtp ? 'Sending...' : 'Send OTP',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        if (_otpSent && !_otpVerified) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              final boxBg =
                  isDark ? const Color(0xFF1F2937) : const Color(0xFFEEF1FB);
              return SizedBox(
                width: 46,
                height: 56,
                child: TextField(
                  controller: _otpCtrl[i],
                  focusNode: _otpFocus[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                      color: primaryText,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: boxBg,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF8B5CF6), width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) _otpFocus[i + 1].requestFocus();
                    if (v.isEmpty && i > 0) _otpFocus[i - 1].requestFocus();
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _verifyingOtp ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                disabledBackgroundColor:
                    const Color(0xFF7C3AED).withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: _verifyingOtp
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text(
                      'Verify Code',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: _resendCountdown > 0
                ? Text('Resend code in ${_resendCountdown}s',
                    style: TextStyle(color: secondaryText, fontSize: 13))
                : TextButton(
                    onPressed: _sendOtp,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                          color: Color(0xFF8B5CF6),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
          ),
        ],
        if (_otpVerified) ...[
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF34D399).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: const Color(0xFF34D399).withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Color(0xFF34D399), size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Phone number verified',
                    style: TextStyle(
                        color: Color(0xFF34D399),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ── STEP 3: TIER ──────────────────────────────────────────────────────────
  Widget _buildTierStep(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    final tiers = [
      _TierInfo(
        tier: 1,
        title: 'Starter',
        subtitle: 'Phone verified only',
        color: const Color(0xFF06B6D4),
        icon: Icons.rocket_launch_rounded,
        limits: const [
          'Up to 10 product listings',
          '7-day payout holding period',
          'Standard seller badge',
        ],
        requirement: 'Phone number only — already done!',
      ),
      _TierInfo(
        tier: 2,
        title: 'Verified Individual',
        subtitle: 'Ghana Card verified',
        color: const Color(0xFF8B5CF6),
        icon: Icons.verified_rounded,
        limits: const [
          'Up to 50 product listings',
          '3-day payout holding period',
          'Verified seller badge',
        ],
        requirement: 'Ghana Card ID verification (this flow)',
      ),
      _TierInfo(
        tier: 3,
        title: 'Verified Business',
        subtitle: 'GRA TIN or business registration',
        color: const Color(0xFFF59E0B),
        icon: Icons.workspace_premium_rounded,
        limits: const [
          'Unlimited product listings',
          'Same-day payouts',
          'Premium business badge',
          'Priority customer support',
        ],
        requirement: 'Submit GRA TIN or business certificate',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          isDark: isDark,
          message:
              'Choose the tier that fits your business. '
              'You can always upgrade later.',
        ),
        const SizedBox(height: 24),
        ...tiers.map((t) {
          final selected = _selectedTier == t.tier;
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _selectedTier = t.tier);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: selected
                    ? t.color.withOpacity(0.07)
                    : isDark
                        ? const Color(0xFF111827)
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? t.color
                      : isDark
                          ? Colors.white.withOpacity(0.06)
                          : const Color(0xFFE2E8F0),
                  width: selected ? 2 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: t.color.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: t.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(t.icon, color: t.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tier ${t.tier} — ${t.title}',
                              style: TextStyle(
                                  color: primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(t.subtitle,
                                style: TextStyle(
                                    color: secondaryText, fontSize: 12)),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected ? t.color : Colors.transparent,
                          border: Border.all(
                            color: selected
                                ? t.color
                                : isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : const Color(0xFFCBD5E1),
                            width: 2,
                          ),
                        ),
                        child: selected
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 13)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...t.limits.map(
                    (l) => Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              color: t.color, size: 14),
                          const SizedBox(width: 8),
                          Text(l,
                              style: TextStyle(
                                  color: secondaryText, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: t.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: t.color, size: 13),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            t.requirement,
                            style: TextStyle(
                                color: t.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── STEP 4: REVIEW ────────────────────────────────────────────────────────
  Widget _buildReviewStep(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryText,
    Color secondaryText,
  ) {
    final tierNames = {
      1: 'Starter',
      2: 'Verified Individual',
      3: 'Verified Business',
    };
    final tierColors = {
      1: const Color(0xFF06B6D4),
      2: const Color(0xFF8B5CF6),
      3: const Color(0xFFF59E0B),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoBanner(
          isDark: isDark,
          message:
              'Please review your information before submitting. '
              'Once submitted, changes require contacting support.',
        ),
        const SizedBox(height: 24),
        _SectionTitle(label: 'Submitted Information', primaryText: primaryText),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _ReviewRow(
                label: 'Phone Number',
                value: _phoneNumber,
                icon: Icons.phone_rounded,
                verified: true,
                isDark: isDark,
                secondaryText: secondaryText,
                primaryText: primaryText,
              ),
              _divider(isDark),
              _ReviewRow(
                label: 'Ghana Card',
                value: _idNumberCtrl.text.isEmpty ? '—' : _idNumberCtrl.text,
                icon: Icons.credit_card_rounded,
                verified: _idFrontPhoto != null && _idBackPhoto != null,
                isDark: isDark,
                secondaryText: secondaryText,
                primaryText: primaryText,
              ),
              _divider(isDark),
              _ReviewRow(
                label: 'Selected Tier',
                value: _selectedTier >= 0
                    ? 'Tier $_selectedTier — ${tierNames[_selectedTier]}'
                    : '—',
                icon: Icons.workspace_premium_rounded,
                verified: _selectedTier >= 0,
                isDark: isDark,
                secondaryText: secondaryText,
                primaryText: primaryText,
                accentColor:
                    _selectedTier >= 0 ? tierColors[_selectedTier] : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (_idFrontPhoto != null || _idBackPhoto != null) ...[
          _SectionTitle(label: 'ID Card Photos', primaryText: primaryText),
          const SizedBox(height: 14),
          Row(
            children: [
              if (_idFrontPhoto != null)
                Expanded(
                  child: _PhotoPreview(
                      file: _idFrontPhoto!, label: 'Front', isDark: isDark),
                ),
              if (_idFrontPhoto != null && _idBackPhoto != null)
                const SizedBox(width: 12),
              if (_idBackPhoto != null)
                Expanded(
                  child: _PhotoPreview(
                      file: _idBackPhoto!, label: 'Back', isDark: isDark),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withOpacity(0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFF8B5CF6).withOpacity(0.18)),
          ),
          child: Text(
            'By submitting, you confirm that all information provided is '
            'accurate and you agree to Comfi\'s Seller Terms of Service '
            'and Privacy Policy.',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withOpacity(0.55)
                  : const Color(0xFF64748B),
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _divider(bool isDark) => Divider(
        height: 24,
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFE2E8F0),
      );

  // ── BOTTOM CTA ────────────────────────────────────────────────────────────
  Widget _buildBottomCta(bool isDark, Color surfaceColor, Color borderColor) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final isOtpStep = _currentStep == 1;
    final canContinueOnOtp = !isOtpStep || _otpVerified;
    final enabled = _canAdvance && canContinueOnOtp && !_isSubmitting;

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled
              ? () {
                  if (isLastStep) {
                    _submitVerification();
                  } else if (_currentStep == 0) {
                    if (_idFormKey.currentState!.validate()) {
                      _idFormKey.currentState!.save();
                      _animateToNextStep();
                    }
                  } else {
                    _animateToNextStep();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            disabledBackgroundColor: isDark
                ? Colors.white.withOpacity(0.07)
                : const Color(0xFFE2E8F0),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2.5))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastStep ? 'Submit for Review' : 'Continue',
                      style: TextStyle(
                        color: enabled
                            ? Colors.white
                            : isDark
                                ? Colors.white.withOpacity(0.25)
                                : const Color(0xFFCBD5E1),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!isLastStep) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: enabled
                            ? Colors.white
                            : isDark
                                ? Colors.white.withOpacity(0.25)
                                : const Color(0xFFCBD5E1),
                        size: 18,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  // ── Input decoration helper ───────────────────────────────────────────────
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required Color cardBg,
    required Color borderColor,
    required Color hintColor,
    required Color iconColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColor, fontSize: 14),
      prefixIcon: Icon(icon, color: iconColor, size: 20),
      filled: true,
      fillColor: cardBg,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF8B5CF6), width: 1.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFEF4444), width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFEF4444), width: 1.8)),
      errorStyle:
          const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Sub-widgets (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final bool isDark;
  final String message;
  const _InfoBanner({required this.isDark, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF8B5CF6), size: 17),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFA78BFA)
                    : const Color(0xFF6D28D9),
                fontSize: 12.5,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final Color primaryText;
  const _SectionTitle({required this.label, required this.primaryText});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _FieldLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isDark
            ? Colors.white.withOpacity(0.75)
            : const Color(0xFF374151),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _PhotoUploadCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final XFile? photo;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _PhotoUploadCard({
    required this.label,
    required this.icon,
    required this.photo,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photo != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: hasPhoto
              ? Colors.transparent
              : isDark
                  ? const Color(0xFF1F2937)
                  : const Color(0xFFEEF1FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasPhoto
                ? const Color(0xFF34D399)
                : const Color(0xFF8B5CF6).withOpacity(0.3),
            width: hasPhoto ? 2 : 1.5,
          ),
        ),
        child: hasPhoto
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(photo!.path), fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34D399),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: const Color(0xFF8B5CF6), size: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : const Color(0xFF475569),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to upload',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.3)
                          : const Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  final bool isDark;
  final List<String> tips;
  const _TipsCard({required this.isDark, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF34D399).withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF34D399).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates_rounded,
                  color: Color(0xFF34D399), size: 15),
              SizedBox(width: 6),
              Text(
                'Tips',
                style: TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...tips.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: Color(0xFF34D399), fontSize: 11)),
                  Expanded(
                    child: Text(
                      t,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.55)
                            : const Color(0xFF64748B),
                        fontSize: 11.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool verified;
  final bool isDark;
  final Color secondaryText;
  final Color primaryText;
  final Color? accentColor;

  const _ReviewRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.verified,
    required this.isDark,
    required this.secondaryText,
    required this.primaryText,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color:
                (accentColor ?? const Color(0xFF8B5CF6)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: accentColor ?? const Color(0xFF8B5CF6), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: secondaryText, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      color: primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: verified
                ? const Color(0xFF34D399).withOpacity(0.1)
                : const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            verified ? 'Ready' : 'Missing',
            style: TextStyle(
              color: verified
                  ? const Color(0xFF34D399)
                  : const Color(0xFFF59E0B),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  final XFile file;
  final String label;
  final bool isDark;
  const _PhotoPreview(
      {required this.file, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(File(file.path),
              height: 100, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? Colors.white.withOpacity(0.5)
                : const Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Tier data model
// ─────────────────────────────────────────────────────────────────────────────
class _TierInfo {
  final int tier;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final List<String> limits;
  final String requirement;

  const _TierInfo({
    required this.tier,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.limits,
    required this.requirement,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
//  Text input formatters
// ─────────────────────────────────────────────────────────────────────────────

class _GhanaCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length && i < 13; i++) {
      if (i == 3 || i == 12) buffer.write('-');
      buffer.write(raw[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = digits;
    if (digits.length >= 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
