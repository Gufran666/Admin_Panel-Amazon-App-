import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:amazon_clone_admin/presentation/theme/theme.dart';
import 'package:amazon_clone_admin/presentation/screens/login_screen.dart';
import 'package:amazon_clone_admin/presentation/screens/dashboard_screen.dart';
import 'package:amazon_clone_admin/presentation/screens/user_management_screen.dart';
import 'package:amazon_clone_admin/presentation/screens/product_management_screen.dart';
import 'package:amazon_clone_admin/presentation/screens/order_management_screen.dart';
import 'package:amazon_clone_admin/presentation/screens/interactive_charts_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const ProviderScope(child: AdminPanelApp()));
}

class AdminPanelApp extends HookWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/user-management': (context) => const UserManagementScreen(),
        '/product-management': (context) => const ProductManagementScreen(),
        '/order-management': (context) => const OrderManagementScreen(),
        '/charts': (context) => const InteractiveChartsScreen(),
      },
      initialRoute: '/',
    );
  }
}

class MainScreen extends HookWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final screenTitles = [
      'Dashboard',
      'User Management',
      'Product Management',
      'Order Management',
      'Charts',
    ];
    final screens = [
      const DashboardScreen(),
      const UserManagementScreen(),
      const ProductManagementScreen(),
      const OrderManagementScreen(),
      const InteractiveChartsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitles[selectedIndex.value]),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: screens[selectedIndex.value],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          selectedIndex.value = index;
        },
        selectedIndex: selectedIndex.value,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.production_quantity_limits), label: 'Products'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Charts'),
        ],
      ),
    );
  }
}