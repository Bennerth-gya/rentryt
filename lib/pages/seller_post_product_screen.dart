import 'dart:io';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../consts/theme_toggle_button.dart';

class SellerPostProductScreen extends StatefulWidget {
  final Products? productToEdit;
  const SellerPostProductScreen({super.key, this.productToEdit});

  @override
  State<SellerPostProductScreen> createState() =>
      _SellerPostProductScreenState();
}

class _SellerPostProductScreenState
    extends State<SellerPostProductScreen>
    with SingleTickerProviderStateMixin {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _descCtrl  = TextEditingController();
  final _priceCtrl = TextEditingController();

  String?            _selectedCategory;
  final List<String> _selectedColors = [];
  final List<String> _selectedSizes  = [];
  final List<XFile>  _selectedImages = [];
  bool _isSubmitting = false;

  late AnimationController _animController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Electronics', 'Education', 'Men', 'Ladies',
    'Furniture', 'Home & Living', 'Beauty', 'Other',
  ];

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Black',  'color': Colors.black},
    {'name': 'White',  'color': Colors.white},
    {'name': 'Red',    'color': const Color(0xFFEF4444)},
    {'name': 'Blue',   'color': const Color(0xFF3B82F6)},
    {'name': 'Green',  'color': const Color(0xFF22C55E)},
    {'name': 'Yellow', 'color': const Color(0xFFEAB308)},
    {'name': 'Purple', 'color': const Color(0xFF8B5CF6)},
    {'name': 'Pink',   'color': const Color(0xFFEC4899)},
    {'name': 'Grey',   'color': Colors.grey},
    {'name': 'Brown',  'color': const Color(0xFF92400E)},
  ];

  final List<String> _availableSizes = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL',
    'One Size', '30', '32', '34', '36', '38', '40', '42',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
        parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameCtrl.text  = p.name;
      _descCtrl.text  = p.description;
      _priceCtrl.text = p.price.toStringAsFixed(2);
      _selectedCategory = p.category;
      _selectedColors.addAll(p.colors);
      _selectedSizes.addAll(p.sizes);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85, maxWidth: 1200,
      );
      if (images.isNotEmpty && mounted) {
        setState(() => _selectedImages.addAll(images));
      }
    } catch (e) {
      _showError('Error picking images: $e');
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, maxWidth: 1200,
      );
      if (image != null && mounted) {
        setState(() => _selectedImages.add(image));
      }
    } catch (e) {
      _showError('Error capturing image: $e');
    }
  }

  void _showError(String msg) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFEF4444), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg,
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess(String msg) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? const Color(0xFF1E1B2E) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color:
                    const Color(0xFF34D399).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF34D399), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(msg,
                style: TextStyle(
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError('Please select a category');
      return;
    }
    if (_selectedImages.isEmpty &&
        widget.productToEdit == null) {
      _showError('Please add at least one image');
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final newProduct = Products(
  name: _nameCtrl.text.trim(),
  imagePath: _selectedImages.isNotEmpty
      ? _selectedImages.first.path
      : (widget.productToEdit?.imagePath ?? 'assets/images/placeholder.jpg'),
  imagePaths: _selectedImages.isNotEmpty          // ← add this
      ? _selectedImages.map((x) => x.path).toList()
      : (widget.productToEdit?.imagePaths ?? ['assets/images/placeholder.jpg']),
  description: _descCtrl.text.trim(),
  price: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
  colors: List.from(_selectedColors),
  sizes: List.from(_selectedSizes),
  category: _selectedCategory!,
);
    final cart =
        Provider.of<Cart>(context, listen: false);
    if (widget.productToEdit != null) {
      cart.updateProduct(widget.productToEdit!, newProduct);
      _showSuccess('Product updated successfully!');
    } else {
      cart.addNewProduct(newProduct);
      _showSuccess('Product posted successfully!');
    }

    setState(() => _isSubmitting = false);
    Navigator.pop(context);
  }

  void _showImagePicker(
      BuildContext context, bool isDark) {
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final borderColor = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFE2E8F0);
    final primaryText =
        isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Add photo',
              style: TextStyle(
                color: primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _PickerOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      _pickFromCamera();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    isDark: isDark,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImages();
                    },
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

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final isEditMode   = widget.productToEdit != null;
    final scaffoldBg   = isDark
        ? const Color(0xFF080C14)
        : const Color(0xFFF5F7FF);
    final surfaceColor =
        isDark ? const Color(0xFF111827) : Colors.white;
    final cardBg       = isDark
        ? const Color(0xFF1F2937)
        : const Color(0xFFEEF1FB);
    final borderColor  = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color(0xFFE2E8F0);
    final primaryText  =
        isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = isDark
        ? Colors.white.withOpacity(0.45)
        : const Color(0xFF64748B);
    final hintColor    = isDark
        ? Colors.white.withOpacity(0.25)
        : const Color(0xFFADB5C7);
    final labelColor   = isDark
        ? Colors.white.withOpacity(0.6)
        : const Color(0xFF374151);
    final inputColor   =
        isDark ? Colors.white : const Color(0xFF0F172A);
    const iconColor    = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape:
            Border(bottom: BorderSide(color: borderColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: primaryText, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? 'Edit Product' : 'Post Product',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [

          // ✅ Theme toggle button
          ThemeToggleButton(
            surfaceColor: surfaceColor,
            borderColor: borderColor,
            size: 38,
          ),
          const SizedBox(width: 8),

          // Mode badge
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEditMode ? 'Edit mode' : 'New listing',
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                // ── IMAGE PICKER ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 20, 16, 0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(
                          label: 'Product photos',
                          subtitle: 'Add up to 6 photos',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Add button
                              GestureDetector(
                                onTap: () =>
                                    _showImagePicker(
                                        context, isDark),
                                child: Container(
                                  width: 100, height: 100,
                                  margin: const EdgeInsets
                                      .only(right: 10),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius:
                                        BorderRadius.circular(
                                            16),
                                    border: Border.all(
                                      color: const Color(
                                              0xFF8B5CF6)
                                          .withOpacity(0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration:
                                            BoxDecoration(
                                          color: const Color(
                                                  0xFF8B5CF6)
                                              .withOpacity(
                                                  0.12),
                                          shape:
                                              BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          color: Color(
                                              0xFF8B5CF6),
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 6),
                                      const Text('Add photo',
                                        style: TextStyle(
                                          color: Color(
                                              0xFF8B5CF6),
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Selected images
                              ..._selectedImages
                                  .asMap()
                                  .entries
                                  .map((e) => Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        margin:
                                            const EdgeInsets
                                                .only(
                                                    right: 10),
                                        decoration:
                                            BoxDecoration(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      16),
                                          border: Border.all(
                                            color: e.key == 0
                                                ? const Color(
                                                    0xFF8B5CF6)
                                                : borderColor,
                                            width: e.key == 0
                                                ? 2
                                                : 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      15),
                                          child: Image.file(
                                            File(e.value.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      if (e.key == 0)
                                        Positioned(
                                          bottom: 6,
                                          left: 6,
                                          child: Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration:
                                                BoxDecoration(
                                              color: const Color(
                                                  0xFF8B5CF6),
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                          6),
                                            ),
                                            child: const Text(
                                              'Cover',
                                              style: TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 9,
                                                fontWeight:
                                                    FontWeight
                                                        .w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        top: 4,
                                        right: 14,
                                        child: GestureDetector(
                                          onTap: () => setState(
                                              () =>
                                                  _selectedImages
                                                      .removeAt(
                                                          e.key)),
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            decoration:
                                                const BoxDecoration(
                                              color: Color(
                                                  0xFFEF4444),
                                              shape: BoxShape
                                                  .circle,
                                            ),
                                            child: const Icon(
                                              Icons
                                                  .close_rounded,
                                              color:
                                                  Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── BASIC INFO ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 28, 16, 0),
                    child: _SectionLabel(
                      label: 'Basic information',
                      subtitle: 'Name, category & price',
                      isDark: isDark,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 14, 16, 0),
                    child: Column(
                      children: [

                        // Product name
                        _FormField(
                          controller: _nameCtrl,
                          label: 'Product title',
                          hint: 'e.g. Galaxy Boho Earrings',
                          icon: Icons.title_rounded,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          inputColor: inputColor,
                          hintColor: hintColor,
                          labelColor: labelColor,
                          isDark: isDark,
                          textCapitalization:
                              TextCapitalization.words,
                          validator: (v) =>
                              v?.trim().isEmpty ?? true
                                  ? 'Product title is required'
                                  : null,
                        ),

                        const SizedBox(height: 14),

                        // Category dropdown
                        Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                                color: borderColor),
                          ),
                          child:
                              DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            style: TextStyle(
                                color: inputColor,
                                fontSize: 15),
                            dropdownColor: isDark
                                ? const Color(0xFF1F2937)
                                : Colors.white,
                            icon: Icon(
                                Icons
                                    .keyboard_arrow_down_rounded,
                                color: iconColor),
                            decoration: InputDecoration(
                              hintText: 'Select category',
                              hintStyle: TextStyle(
                                  color: hintColor,
                                  fontSize: 14),
                              prefixIcon: Icon(
                                  Icons.category_rounded,
                                  color: iconColor,
                                  size: 20),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16),
                            ),
                            items: _categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat,
                                  style: TextStyle(
                                    color: inputColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => setState(
                                () =>
                                    _selectedCategory = val),
                            validator: (v) => v == null
                                ? 'Please select a category'
                                : null,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Price
                        _FormField(
                          controller: _priceCtrl,
                          label: 'Price',
                          hint: '0.00',
                          icon: null,
                          prefixText: 'GHS ',
                          cardBg: cardBg,
                          borderColor: borderColor,
                          inputColor: inputColor,
                          hintColor: hintColor,
                          labelColor: labelColor,
                          isDark: isDark,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                                      decimal: true),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Price is required';
                            if (double.tryParse(v) == null)
                              return 'Enter a valid number';
                            if (double.parse(v) <= 0)
                              return 'Price must be greater than 0';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ── DESCRIPTION ───────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 28, 16, 0),
                    child: _SectionLabel(
                      label: 'Description',
                      subtitle:
                          'Help buyers understand your product',
                      isDark: isDark,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 14, 16, 0),
                    child: _FormField(
                      controller: _descCtrl,
                      label: 'Product description',
                      hint:
                          'Describe features, materials, care instructions...',
                      icon: Icons.description_rounded,
                      maxLines: 5,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      inputColor: inputColor,
                      hintColor: hintColor,
                      labelColor: labelColor,
                      isDark: isDark,
                      textCapitalization:
                          TextCapitalization.sentences,
                    ),
                  ),
                ),

                // ── COLORS ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 28, 16, 0),
                    child: _SectionLabel(
                      label: 'Available colors',
                      subtitle: 'Tap to select',
                      isDark: isDark,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 14, 16, 0),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _colorOptions.map((c) {
                        final name  = c['name'] as String;
                        final color = c['color'] as Color;
                        final selected =
                            _selectedColors.contains(name);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              selected
                                  ? _selectedColors
                                      .remove(name)
                                  : _selectedColors.add(name);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 200),
                            padding: const EdgeInsets
                                .symmetric(
                                    horizontal: 12,
                                    vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? color.withOpacity(0.15)
                                  : cardBg,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? color
                                    : borderColor,
                                width: selected ? 1.8 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white
                                              .withOpacity(0.2)
                                          : Colors.black
                                              .withOpacity(
                                                  0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Text(name,
                                  style: TextStyle(
                                    color: selected
                                        ? (isDark
                                            ? Colors.white
                                            : const Color(
                                                0xFF0F172A))
                                        : secondaryText,
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (selected) ...[
                                  const SizedBox(width: 4),
                                  Icon(Icons.check_rounded,
                                      color: color, size: 12),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ── SIZES ─────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 28, 16, 0),
                    child: _SectionLabel(
                      label: 'Available sizes',
                      subtitle: 'Tap to select',
                      isDark: isDark,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 14, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _availableSizes.map((size) {
                        final selected =
                            _selectedSizes.contains(size);
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              selected
                                  ? _selectedSizes
                                      .remove(size)
                                  : _selectedSizes.add(size);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 200),
                            width: 54, height: 44,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF8B5CF6)
                                      .withOpacity(0.15)
                                  : cardBg,
                              borderRadius:
                                  BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF8B5CF6)
                                    : borderColor,
                                width: selected ? 1.8 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(size,
                                style: TextStyle(
                                  color: selected
                                      ? const Color(
                                          0xFF8B5CF6)
                                      : secondaryText,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ── SUBMIT ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        16, 32, 16, 48),
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : _submitProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF7C3AED),
                          disabledBackgroundColor:
                              const Color(0xFF7C3AED)
                                  .withOpacity(0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 22, height: 22,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isEditMode
                                        ? Icons.save_rounded
                                        : Icons
                                            .upload_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isEditMode
                                        ? 'Save Changes'
                                        : 'Post Product',
                                    style: const TextStyle(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isDark;

  const _SectionLabel({
    required this.label,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3, height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF0F172A),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Text(subtitle,
              style: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.4)
                    : const Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Reusable form field ───────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final String? prefixText;
  final int maxLines;
  final Color cardBg;
  final Color borderColor;
  final Color inputColor;
  final Color hintColor;
  final Color labelColor;
  final bool isDark;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.cardBg,
    required this.borderColor,
    required this.inputColor,
    required this.hintColor,
    required this.labelColor,
    required this.isDark,
    this.prefixText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: TextStyle(color: inputColor, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: hintColor, fontSize: 14),
        filled: true,
        fillColor: cardBg,
        prefixIcon: icon != null
            ? Icon(icon,
                color: const Color(0xFF8B5CF6), size: 20)
            : null,
        prefix: prefixText != null
            ? Text(prefixText!,
                style: const TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ))
            : null,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: borderColor, width: 1),
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
            color: Color(0xFFEF4444), fontSize: 12),
      ),
      validator: validator,
    );
  }
}

// ── Image picker option ───────────────────────────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color:
              const Color(0xFF8B5CF6).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8B5CF6)
                .withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6)
                    .withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: const Color(0xFF8B5CF6),
                  size: 22),
            ),
            const SizedBox(height: 8),
            Text(label,
              style: TextStyle(
                color: isDark
                    ? Colors.white
                    : const Color(0xFF0F172A),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}