import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amazon_clone_admin/core/models/product.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _dragController;
  late List<Product> products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      price: 99.99,
      category: 'Electronics',
      stock: 50,
      reorderThreshold: 20,
      rating: 4.5,
      reviewsCount: 250,
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      price: 149.99,
      category: 'Electronics',
      stock: 30,
      reorderThreshold: 15,
      rating: 4.2,
      reviewsCount: 180,
    ),
    Product(
      id: '3',
      name: 'Bluetooth Speaker',
      price: 79.99,
      category: 'Electronics',
      stock: 45,
      reorderThreshold: 10,
      rating: 4.7,
      reviewsCount: 310,
    ),
  ];
  late List<Product> _filteredProducts;
  late TextEditingController _searchController;
  Product? _draggedProduct;
  bool _isProcessing = false;

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

  void _handleDragStart(Product product) {
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

  void _showAddProductDialog() async {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _priceController = TextEditingController();
    final _categoryController = TextEditingController();
    final _stockController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Product'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a quantity' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
              if (_formKey.currentState!.validate()) {
                setState(() => _isProcessing = true);
                // Simulate async operation (e.g., API call)
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                setState(() {
                  final newProduct = Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text,
                    price: double.parse(_priceController.text),
                    category: _categoryController.text,
                    stock: int.parse(_stockController.text),
                    rating: 4.5,
                    reorderThreshold: 20,
                    reviewsCount: 100,
                  );
                  products.insert(0, newProduct);
                  _filteredProducts = [...products];
                  _isProcessing = false;
                });
                Navigator.pop(context);
                _nameController.clear();
                _priceController.clear();
                _categoryController.clear();
                _stockController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully')),
                );
              }
            },
            child: _isProcessing
                ? const CircularProgressIndicator()
                : const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Product product) async {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: product.name);
    final _priceController = TextEditingController(text: product.price.toString());
    final _categoryController = TextEditingController(text: product.category);
    final _stockController = TextEditingController(text: product.stock.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) => value!.isEmpty ? 'Please enter a category' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a quantity' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
              if (_formKey.currentState!.validate()) {
                setState(() => _isProcessing = true);
                // Simulate async operation
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                setState(() {
                  final updatedProduct = product.copyWith(
                    name: _nameController.text,
                    price: double.parse(_priceController.text),
                    category: _categoryController.text,
                    stock: int.parse(_stockController.text),
                  );
                  final index = products.indexOf(product);
                  products[index] = updatedProduct;
                  _filteredProducts = [...products];
                  _isProcessing = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product updated successfully')),
                );
              }
            },
            child: _isProcessing
                ? const CircularProgressIndicator()
                : const Text('Update Product'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: _isProcessing ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
              setState(() => _isProcessing = true);
              // Simulate async operation
              await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              setState(() {
                products.remove(product);
                _filteredProducts = [...products];
                _isProcessing = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${product.name} deleted')),
              );
            },
            child: _isProcessing
                ? const CircularProgressIndicator()
                : const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).textTheme.bodyMedium!.color,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Management',
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Theme.of(context).textTheme.bodyMedium!.color,
            onPressed: _isProcessing ? null : _showAddProductDialog,
          ),
          IconButton(
            icon: _isProcessing
                ? const CircularProgressIndicator()
                : const Icon(Icons.refresh),
            color: Theme.of(context).textTheme.bodyMedium!.color,
            onPressed: _isProcessing
                ? null
                : () async {
              setState(() => _isProcessing = true);
              await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              setState(() {
                _filteredProducts = [...products];
                _isProcessing = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Products refreshed')),
              );
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
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isProcessing ? null : _showAddProductDialog,
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
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
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).textTheme.bodyMedium!.color!.withAlpha(128),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          color: Theme.of(context).textTheme.bodyMedium!.color,
          onPressed: () => _searchController.clear(),
        ),
      ),
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      onChanged: (value) => setState(() {
        _filteredProducts = products
            .where((product) => product.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final isDragged = _draggedProduct == product;

        return DragTarget<Product>(
          onWillAcceptWithDetails: (details) => details.data == product,
          onAcceptWithDetails: (details) => _handleDrop(details.data, index),
          builder: (context, candidates, rejects) {
            return Draggable<Product>(
              data: product,
              feedback: _buildDragFeedback(product),
              onDragStarted: () => _handleDragStart(product),
              onDragEnd: (details) => _handleDragEnd(details),
              childWhenDragging: Opacity(
                opacity: isDragged ? 0.5 : 1.0,
                child: _buildProductCard(product),
              ),
              child: _buildProductCard(product),
            );
          },
        );
      },
    );
  }


  Widget _buildDragFeedback(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.local_shipping,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
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
                color: Theme.of(context).primaryColor,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          Icons.inventory_2,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)} - ${product.category} | Stock: ${product.stock}',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).textTheme.bodyMedium!.color,
              onPressed: _isProcessing ? null : () => _showEditProductDialog(product),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: _isProcessing ? null : () => _deleteProduct(product),
            ),
          ],
        ),
        onTap: () {
          if (!_isProcessing) {
            HapticFeedback.lightImpact();
            _showEditProductDialog(product);
          }
        },
      ),
    );
  }
}