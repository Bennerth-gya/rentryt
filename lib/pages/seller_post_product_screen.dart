// lib/pages/seller/seller_post_product_screen.dart
import 'dart:io';

import 'package:comfi/consts/colors.dart';
import 'package:comfi/models/cart.dart';
import 'package:comfi/models/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SellerPostProductScreen extends StatefulWidget {
  final Products? productToEdit; // null = new product, non-null = edit mode

  const SellerPostProductScreen({super.key, this.productToEdit});

  @override
  State<SellerPostProductScreen> createState() =>
      _SellerPostProductScreenState();
}

class _SellerPostProductScreenState extends State<SellerPostProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  // Selections
  String? _selectedCategory;
  final List<String> _selectedColors = [];
  final List<String> _selectedSizes = [];
  final List<XFile> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  // ── Options ────────────────────────────────────────────────
  final List<String> _categories = [
    'Electronics',
    'Education',
    'Men',
    'Ladies',
    'Furniture',
    'Home & Living',
    'Beauty',
    'Other',
  ];

  final List<String> _availableColors = [
    'Black',
    'White',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Purple',
    'Pink',
    'Grey',
    'Brown',
  ];

  final List<String> _availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'One Size',
    '30',
    '32',
    '34',
    '36',
    '38',
    '40',
    '42',
  ];

  @override
  void initState() {
    super.initState();

    // If editing an existing product → fill all fields
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameController.text = p.name;
      _descriptionController.text = p.description;
      _priceController.text = p.price.toStringAsFixed(2);
      _selectedCategory = p.category;
      _selectedColors.addAll(p.colors);
      _selectedSizes.addAll(p.sizes);

      // Note: We don't auto-load old images here (because XFile is temporary).
      // If you want to show old images, you would need to:
      // 1. Store remote URLs in Products model
      // 2. Show network images + allow adding new ones
      // For now we assume user re-uploads if they want to change image
    }
  }

  // ── Pick multiple images ───────────────────────────────────
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (images.isNotEmpty && mounted) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking images: $e")));
    }
  }

  // ── Remove image ───────────────────────────────────────────
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // ── Submit (Create or Update) ──────────────────────────────
  void _submitProduct() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a category")));
      return;
    }

    // Optional: require at least one image (can be relaxed when editing)
    if (_selectedImages.isEmpty && widget.productToEdit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one image")),
      );
      return;
    }

    final newProduct = Products(
      name: _nameController.text.trim(),
      imagePath: _selectedImages.isNotEmpty
          ? _selectedImages.first.path
          : (widget.productToEdit?.imagePath ??
                "assets/images/placeholder.jpg"),
      description: _descriptionController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      colors: List.from(_selectedColors),
      sizes: List.from(_selectedSizes),
      category: _selectedCategory!,
    );

    final cart = Provider.of<Cart>(context, listen: false);

    if (widget.productToEdit != null) {
      // Update existing
      cart.updateProduct(widget.productToEdit!, newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Add new
      cart.addNewProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product posted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Clear form / go back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.productToEdit != null;
    final title = isEditMode ? "Edit Product" : "Post Your Product";

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: cardColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Product Title ────────────────────────────────────────
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Product Title',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'e.g. Galaxy Boho Earrings',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: cardColor.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4EFF),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                prefixIcon: const Icon(
                  Icons.title_rounded,
                  color: Color(0xFF6B4EFF),
                ),
              ),
              validator: (v) => v?.trim().isEmpty ?? true
                  ? 'Product title is required'
                  : null,
            ),
            const SizedBox(height: 24),

            // ── Category Dropdown ────────────────────────────────────
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              style: const TextStyle(color: Colors.white),
              dropdownColor: cardColor,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6B4EFF)),
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: cardColor.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4EFF),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                prefixIcon: const Icon(
                  Icons.category_rounded,
                  color: Color(0xFF6B4EFF),
                ),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (v) => v == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 24),

            // ── Price Field ──────────────────────────────────────────
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'e.g. 280.00',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: cardColor.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4EFF),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Text(
                    'GHS ',
                    style: TextStyle(
                      color: Color(0xFF6B4EFF),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Price is required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                if (double.parse(v) <= 0) return 'Price must be greater than 0';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Description ──────────────────────────────────────────
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 5,
              minLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Product Description',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText:
                    'Describe your product... features, materials, care instructions, etc.',
                hintStyle: const TextStyle(color: Colors.white38),
                alignLabelWithHint: true,
                filled: true,
                fillColor: cardColor.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4EFF),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                  child: Icon(
                    Icons.description_rounded,
                    color: Color(0xFF6B4EFF),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
