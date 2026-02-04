import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel / Furniture Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        primaryColor: const Color(0xFF6B4EFF), // accent purple
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B4EFF)),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        useMaterial3: true,
      ),
      home: const CategoriesScreen(),
    );
  }
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Education',
    'Men',
    'Ladies',
  ];

  // Sample category preview items (you can replace with real assets / models)
  final List<Map<String, dynamic>> _featuredItems = [
    {'name': 'PPEs', 'price': 321, 'image': 'lib/images/fada.jpeg'},
    {'name': 'Study Lamp', 'price': 19, 'image': 'lib/images/study_lamp.jpg'},
    {'name': 'Men shoe', 'price': 30, 'image': 'lib/images/men_shoe.jpg'},
    {'name': 'Hp Laptop', 'price': 450, 'image': 'lib/images/laptops.jpg'},
    {'name': 'Heels', 'price': 40, 'image': 'lib/images/heels1.jpg'},
    {
      'name': 'Ladies africa dress',
      'price': 20,
      'image': 'lib/images/ladies_african_dress.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Categories",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Horizontal category chips
            SizedBox(
              height: 48,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final bool isSelected = index == _selectedCategoryIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(_categories[index]),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      backgroundColor: isSelected
                          ? const Color(0xFF6B4EFF)
                          : Colors.grey.shade200,
                      selectedColor: const Color(0xFF6B4EFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      showCheckmark: false,
                      onSelected: (value) {
                        setState(() => _selectedCategoryIndex = index);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Greeting or title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _selectedCategoryIndex == 0
                    ? "Explore Our Collection"
                    : "Best ${_categories[_selectedCategoryIndex]}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const SizedBox(height: 16),

            // Grid of category items / products
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        0.68, // taller cards like in furniture apps
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _featuredItems.length,
                  itemBuilder: (context, index) {
                    final item = _featuredItems[index];
                    return _buildCategoryCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Navigate to product detail or filtered list
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${item['price']}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
