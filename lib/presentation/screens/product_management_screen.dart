import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';
import 'package:amazon_clone_admin/core/models/product.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> with SingleTickerProviderStateMixin {
  late AnimationController _dragController;
  late List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 99.99,
      category: 'Electronics',
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 149.99,
      category: 'Electronics',
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 79.99,
      category: 'Electronics',
    ),
  ];
  late List<Product> _filteredProducts;
  late TextEditingController _searchController;
  Product? _draggedProduct;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _filteredProducts = products;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _dragController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleDragStart(DraggableDetails details, Product product) {
    setState(() {
      _draggedProduct = product;
    });
  }

  void _handleDragEnd(DraggableDetails details) {
    setState(() {
      _draggedProduct = null;
    });
  }

  void _handleDrop(Product product, int targetIndex) {
    final oldIndex = products.indexOf(product);
    if (oldIndex != targetIndex) {
      setState(() {
        final updatedProducts = List<Product>.from(products);
        updatedProducts.removeAt(oldIndex);
        updatedProducts.insert(targetIndex, product);
        products = updatedProducts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Scaffold(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Product Management',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () {
                // Show add product dialog
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildProductList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search products',
        labelStyle: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.darkTheme.primaryColor,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          onPressed: () {
            _searchController.clear();
          },
        ),
      ),
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
      ),
      onChanged: (value) {
        setState(() {
          _filteredProducts = products.where((product) {
            return product.name.toLowerCase().contains(value.toLowerCase());
          }).toList();
        });
      },
    );
  }

  Widget _buildProductList() {
    return Flexible(
      child: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          final isDragged = _draggedProduct == product;

          return DragTarget<Product>(
            onWillAccept: (data) => data == product,
            onAccept: (data) {
              _handleDrop(data, index);
            },
            builder: (context, candidates, rejects) {
              return Draggable<Product>(
                data: product,
                feedback: _buildDragFeedback(product),
                onDragStarted: () => _handleDragStart(null, product),
                onDragEnd: _handleDragEnd,
                childWhenDragging: Opacity(
                  opacity: isDragged ? 0.5 : 1.0,
                  child: _buildProductCard(product),
                ),
                child: _buildProductCard(product),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDragFeedback(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.cube,
              color: AppTheme.darkTheme.primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.darkTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          Icons.cube,
          color: AppTheme.darkTheme.primaryColor,
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppTheme.darkTheme.textTheme.bodyLarge!.color,
          ),
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)} - ${product.category}',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
              onPressed: () {
                // Show edit product dialog
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                // Handle delete
              },
            ),
          ],
        ),
      ),
    );
  }
}