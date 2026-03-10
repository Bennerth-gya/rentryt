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
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: cardColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Product Title',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
              validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintStyle: TextStyle(color: Colors.white54),

                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCategory = val),
              validator: (v) => v == null ? 'Required' : null,
            ),
            const SizedBox(height: 20),

            // Price
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Price (GHS)',
                labelStyle: TextStyle(color: Colors.white),
                prefixText: 'GHS ',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Invalid number';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Description
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 28),

            // Images
            const Text(
              "Product Images",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text("Add Images (multiple allowed)"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 24,
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    final file = _selectedImages[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(file.path),
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "No images selected yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 28),

            // Colors
            const Text(
              "Available Colors",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final selected = _selectedColors.contains(color);
                return FilterChip(
                  label: Text(color),
                  selected: selected,
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _selectedColors.add(color);
                      } else {
                        _selectedColors.remove(color);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF6B4EFF),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // Sizes
            const Text(
              "Available Sizes",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableSizes.map((size) {
                final selected = _selectedSizes.contains(size);
                return FilterChip(
                  label: Text(size),
                  selected: selected,
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _selectedSizes.add(size);
                      } else {
                        _selectedSizes.remove(size);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF6B4EFF),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            // Submit Button
            FilledButton(
              onPressed: _submitProduct,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6B4EFF),
                padding: const EdgeInsets.symmetric(vertical: 24),
              ),
              child: Text(
                isEditMode ? "Update Product" : "Post Product",
                style: const TextStyle(fontSize: 17),
              ),
            ),

            const SizedBox(height: 40),
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
