import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:amazon_clone_admin/core/models/user.dart';
import 'package:amazon_clone_admin/core/models/admin_providers.dart';

class UserManagementScreen extends HookConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchController = useTextEditingController();
    final selectedRoleFilter = useState<String?>(null);
    final selectedDateRange = useState<DateRange?>(null);
    final isFilterPanelOpen = useState<bool>(false);

    final userAsync = ref.watch(userAdminProvider);

    useEffect(() {
      return () {
        userSearchController.dispose();
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: Icon(isFilterPanelOpen.value ? Icons.filter_list_off : Icons.filter_list),
            onPressed: () => isFilterPanelOpen.value = !isFilterPanelOpen.value,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                    visible: isFilterPanelOpen.value,
                    maintainState: true,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 400),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                        ),
                        color: const Color(0xFFF5F5F5),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxHeight: 60),
                                        child: TypeAheadField<User>(
                                          debounceDuration: const Duration(milliseconds: 300),
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                labelText: 'Search users',
                                                labelStyle: const TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Color(0xFF555555),
                                                ),
                                                enabledBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                                                ),
                                                focusedBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFF2196F3)),
                                                ),
                                                prefixIcon: const Icon(Icons.search, color: Color(0xFF555555)),
                                              ),
                                              onChanged: (value) async {
                                                // Use the results for filtering if needed
                                              },
                                            );
                                          },
                                          suggestionsCallback: (pattern) async {
                                            if (pattern.length < 2) return [];
                                            return await ref
                                                .read(userAdminProvider.notifier)
                                                .searchUsers(pattern);
                                          },
                                          itemBuilder: (context, User suggestion) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.grey[300],
                                                child: Text(
                                                  suggestion.name[0],
                                                  style: const TextStyle(color: Colors.black),
                                                ),
                                              ),
                                              title: Text(suggestion.name),
                                              subtitle: Text(suggestion.email),
                                            );
                                          },
                                          onSelected: (User suggestion) {
                                            userSearchController.text = suggestion.name;
                                            // Implement selected user handling
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 1,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(maxHeight: 60),
                                        child: DropdownButtonFormField<String>(
                                          value: selectedRoleFilter.value,
                                          onChanged: (value) {
                                            selectedRoleFilter.value = value;
                                            // Implement role filter
                                          },
                                          items: const [
                                            DropdownMenuItem(
                                              value: null,
                                              child: Text('All Roles', style: TextStyle(color: Color(0xFF555555))),
                                            ),
                                            DropdownMenuItem(
                                              value: 'admin',
                                              child: Text('Admin', style: TextStyle(color: Color(0xFF555555))),
                                            ),
                                            DropdownMenuItem(
                                              value: 'user',
                                              child: Text('User', style: TextStyle(color: Color(0xFF555555))),
                                            ),
                                            DropdownMenuItem(
                                              value: 'guest',
                                              child: Text('Guest', style: TextStyle(color: Color(0xFF555555))),
                                            ),
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Role',
                                            labelStyle: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xFF555555),
                                            ),
                                            enabledBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                                            ),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xFF2196F3)),
                                            ),
                                          ),
                                          style: const TextStyle(color: Color(0xFF333333)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: TextButton(
                                        onPressed: () async {
                                          final range = await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime.now(),
                                            initialDateRange: selectedDateRange.value == null
                                                ? null
                                                : DateTimeRange(start: selectedDateRange.value!.start, end: selectedDateRange.value!.end),
                                          );
                                          if (range != null) {
                                            selectedDateRange.value = DateRange(range.start, range.end);
                                            // Implement date filter
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(0xFF333333),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        child: Text(
                                          selectedDateRange.value == null
                                              ? 'Select Date Range'
                                              : '${DateFormat.yMd().format(selectedDateRange.value!.start)} - '
                                              '${DateFormat.yMd().format(selectedDateRange.value!.end)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextButton.icon(
                                            icon: const Icon(Icons.save, color: Color(0xFF2196F3)),
                                            label: const Text(
                                              'Save Preset',
                                              style: TextStyle(color: Color(0xFF333333)),
                                            ),
                                            onPressed: () => _showSavePresetDialog(
                                              context,
                                              userSearchController.text,
                                              selectedRoleFilter.value,
                                              selectedDateRange.value,
                                              ref,
                                            ),
                                          ),
                                          TextButton.icon(
                                            icon: const Icon(Icons.restore, color: Color(0xFF2196F3)),
                                            label: const Text(
                                              'Reset Filters',
                                              style: TextStyle(color: Color(0xFF333333)),
                                            ),
                                            onPressed: () => _resetFilters(
                                              userSearchController,
                                              selectedRoleFilter,
                                              selectedDateRange,
                                              ref,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Filter presets section
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  color: const Color(0xFFF5F5F5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: userAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(child: Text('No users found'));
                        }
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 500),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: data.length,
                            separatorBuilder: (context, index) => const Divider(color: Color(0xFFE0E0E0)),
                            itemBuilder: (context, index) {
                              final user = data[index];
                              return ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 72),
                                child: _buildUserListItem(user, context),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) => Center(child: Text('Error: $error')),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showAddUserDialog(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Add User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserListItem(User user, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Text(
          user.name[0],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color(0xFF333333),
        ),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color(0xFF555555),
        ),
      ),
      trailing: Text(
        user.role ?? 'Guest',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: _getRoleColor(user.role),
        ),
      ),
      onTap: () => _showUserDetailsDialog(user, context),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'admin':
        return const Color(0xFF2196F3);
      case 'user':
        return const Color(0xFF4CAF50);
      case 'guest':
        return const Color(0xFFFFC107);
      default:
        return Colors.grey;
    }
  }

  void _showUserDetailsDialog(User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        title: Text(
          'User Details: ${user.name}',
          style: const TextStyle(color: Color(0xFF333333)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email: ${user.email}',
                style: const TextStyle(color: Color(0xFF555555)),
              ),
              Text(
                'Role: ${user.role ?? 'Guest'}',
                style: const TextStyle(color: Color(0xFF555555)),
              ),
              Text(
                'Registered: ${DateFormat.yMMMd().format(user.registrationDate)}',
                style: const TextStyle(color: Color(0xFF555555)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.edit),
                label: const Text('Edit User'),
                onPressed: () {
                  // Implement edit user logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavePresetDialog(
      BuildContext context,
      String searchTerm,
      String? role,
      DateRange? dateRange,
      WidgetRef ref,
      ) {
    final _formKey = GlobalKey<FormState>();
    final _presetNameController = TextEditingController();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
          'Save Filter Preset',
          style: TextStyle(color: Color(0xFF333333)),
        ),
        content: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _presetNameController,
                    decoration: const InputDecoration(
                      labelText: 'Preset Name',
                      labelStyle: TextStyle(color: Color(0xFF555555)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2196F3)),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    style: const TextStyle(color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Implement saving preset logic
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Preset'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetFilters(
      TextEditingController searchController,
      ValueNotifier<String?> selectedRole,
      ValueNotifier<DateRange?> selectedDate,
      WidgetRef ref,
      ) {
    searchController.text = '';
    selectedRole.value = null;
    selectedDate.value = null;
    // Implement resetting filters logic
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    String _role = 'user';
    bool _obscurePassword = true;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        title: const Text(
          'Add New User',
          style: TextStyle(color: Color(0xFF333333)),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Color(0xFF555555)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2196F3)),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                    style: const TextStyle(color: Color(0xFF333333)),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Color(0xFF555555)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2196F3)),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                    style: const TextStyle(color: Color(0xFF333333)),
                  ),
                  DropdownButtonFormField<String>(
                    value: _role,
                    onChanged: (value) => _role = value!,
                    items: const [
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Admin', style: TextStyle(color: Color(0xFF333333))),
                      ),
                      DropdownMenuItem(
                        value: 'user',
                        child: Text('User', style: TextStyle(color: Color(0xFF333333))),
                      ),
                      DropdownMenuItem(
                        value: 'guest',
                        child: Text('Guest', style: TextStyle(color: Color(0xFF333333))),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: Color(0xFF555555)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2196F3)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF333333)),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Color(0xFF555555)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF555555),
                        ),
                        onPressed: () => _obscurePassword = !_obscurePassword,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFAAAAAA)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF2196F3)),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                    style: const TextStyle(color: Color(0xFF333333)),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2196F3),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newUser = User(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  email: _emailController.text,
                  role: _role,
                  registrationDate: DateTime.now(),
                  lastLogin: DateTime.now(),
                  orderCount: 0,
                );
                ref.read(userAdminProvider.notifier).addUser(newUser);
                Navigator.pop(context);
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}