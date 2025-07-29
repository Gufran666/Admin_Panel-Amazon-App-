import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:amazon_clone_admin/core/models/user.dart';

import 'admin_providers.dart';

class UserManagementScreen extends HookConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchController = useTextEditingController();
    final selectedRoleFilter = useState<String?>(null);
    final selectedDateRange = useState<DateRange?>(null);
    final isFilterPanelOpen = useState<bool>(false);

    final userAsync = ref.watch(userAdminProvider);
    userAsync.when(
      data: (data) => data,
      loading: () => [],
      error: (error, stackTrace) => [],
    );

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
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Visibility(
                visible: isFilterPanelOpen.value,
                maintainState: true,
                child: _buildFilterSection(
                  context,
                  userSearchController,
                  selectedRoleFilter,
                  selectedDateRange,
                  ref,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: userAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  return _buildUserList(data);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddUserDialog(context, ref),
        label: const Text('Add User'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context,
      TextEditingController searchController,
      ValueNotifier<String?> selectedRole,
      ValueNotifier<DateRange?> selectedDate,
      WidgetRef ref,
      ) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TypeAheadField<User>(
                    debounceDuration: const Duration(milliseconds: 300),
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Search users',
                          labelStyle: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColor,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: textColor?.withAlpha(128) ?? Colors.grey,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged: (value) async {
                          // Implement filtering based on search results
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
                      searchController.text = suggestion.name;
                      // Implement selected user handling
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole.value,
                  onChanged: (value) {
                    selectedRole.value = value;
                    // Implement role filter
                  },
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Roles'),
                    ),
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Admin'),
                    ),
                    DropdownMenuItem(
                      value: 'user',
                      child: Text('User'),
                    ),
                    DropdownMenuItem(
                      value: 'guest',
                      child: Text('Guest'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textColor,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: textColor?.withAlpha(128) ?? Colors.grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: selectedDate.value == null
                            ? null
                            : DateTimeRange(start: selectedDate.value!.start, end: selectedDate.value!.end),
                      );
                      if (range != null) {
                        selectedDate.value = DateRange(range.start, range.end);
                        // Implement date filter
                      }
                    },
                    child: Text(
                      selectedDate.value == null
                          ? 'Select Date Range'
                          : '${DateFormat.yMd().format(selectedDate.value!.start)} - '
                          '${DateFormat.yMd().format(selectedDate.value!.end)}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Preset'),
                      onPressed: () => _showSavePresetDialog(
                        context,
                        searchController.text,
                        selectedRole.value,
                        selectedDate.value,
                        ref,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.restore),
                      label: const Text('Reset Filters'),
                      onPressed: () => _resetFilters(
                        searchController,
                        selectedRole,
                        selectedDate,
                        ref,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Placeholder for filter presets
            const SizedBox(height: 100),
          ],
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
    final _presetNameController = useTextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Filter Preset'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _presetNameController,
                decoration: const InputDecoration(labelText: 'Preset Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
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

  Widget _buildUserList(List<User> users) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user, context);
      },
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
        ),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w500,
          fontSize: 14,
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
        return Colors.blue;
      case 'user':
        return Colors.green;
      case 'guest':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showUserDetailsDialog(User user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Details: ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}'),
            Text('Role: ${user.role ?? 'Guest'}'),
            Text('Registered: ${DateFormat.yMMMd().format(user.registrationDate)}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit User'),
              onPressed: () {
                // Implement edit user logic
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = useTextEditingController();
    final _emailController = useTextEditingController();
    final _roleController = useState<String>('user');
    final _obscurePassword = useState<bool>(true);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              ),
              DropdownButtonFormField<String>(
                value: _roleController.value,
                onChanged: (value) => _roleController.value = value!,
                items: const [
                  DropdownMenuItem(
                    value: 'admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem(
                    value: 'user',
                    child: Text('User'),
                  ),
                  DropdownMenuItem(
                    value: 'guest',
                    child: Text('Guest'),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => _obscurePassword.value = !_obscurePassword.value,
                  ),
                ),
                obscureText: _obscurePassword.value,
                validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Implement add user logic
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

class FilterPreset {
  final String id;
  final String name;
  final String searchTerm;
  final String? role;
  final DateRange? dateRange;

  FilterPreset({
    required this.id,
    required this.name,
    required this.searchTerm,
    this.role,
    this.dateRange,
  });
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);
}

final List<FilterPreset> mockPresets = [
  FilterPreset(
    id: 'PST-001',
    name: 'New Users',
    searchTerm: '',
    role: null,
    dateRange: DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()),
  ),
  FilterPreset(
    id: 'PST-002',
    name: 'Admin Team',
    searchTerm: '',
    role: 'admin',
    dateRange: null,
  ),
];