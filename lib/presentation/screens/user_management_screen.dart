import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:amazon_clone_admin/core/design_system/app_theme.dart';
import 'package:amazon_clone_admin/core/models/user.dart';
import 'package:amazon_clone_admin/core/providers/admin_providers.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class UserManagementScreen extends HookConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchController = useTextEditingController();
    final selectedRoleFilter = useState<String?>(null);
    final selectedDateRange = useState<DateRange?>(null);
    final isFilterPanelOpen = useState<bool>(false);

    final isAdminLoading = ref.watch(userAdminProvider).isLoading;
    final users = ref.watch(filteredUsersProvider(
        selectedRoleFilter.value,
        userSearchController.text,
        selectedDateRange.value
    ));

    useEffect(() {
      return () {
        // Cleanup any lingering focus nodes
        userSearchController.dispose();
      };
    }, []);

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
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'User Management',
            style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isFilterPanelOpen.value ? Icons.filter_list_off : Icons.filter_list),
              color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
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
                curve: Curves.easeInOut,
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
                child: isAdminLoading
                    ? const Center(child: CircularProgressIndicator())
                    : users.isEmpty
                    ? const Center(child: Text('No users found'))
                    : _buildUserList(users),
              ),
            ],
          ),
        ),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TypeAheadField(
                    debounceDuration: const Duration(milliseconds: 300),
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search users',
                        labelStyle: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                        ),
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onChanged: (value) => ref
                          .read(filteredUsersProvider.notifier)
                          .updateSearchQuery(value),
                    ),
                    suggestionsCallback: (pattern) async {
                      if (pattern.length < 2) return [];
                      return ref.read(userAdminProvider.notifier).searchUsers(pattern);
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
                    onSuggestionSelected: (User suggestion) {
                      searchController.text = suggestion.name;
                      ref
                          .read(filteredUsersProvider.notifier)
                          .updateSearchQuery(suggestion.name);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: selectedRole.value,
                    onChanged: (value) {
                      selectedRole.value = value;
                      ref
                          .read(filteredUsersProvider.notifier)
                          .updateRoleFilter(value);
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
                        color: AppTheme.darkTheme.textTheme.bodyMedium!.color,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.darkTheme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.darkTheme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DateRangePicker(
                    initialDateRange: selectedDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    onChanged: (range) {
                      selectedDate.value = range;
                      ref
                          .read(filteredUsersProvider.notifier)
                          .updateDateRangeFilter(range);
                    },
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
            FutureBuilder<List<FilterPreset>>(
              future: ref.read(filterPresetsProvider.future),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: snapshot.data!
                      .map(
                        (preset) => ListTile(
                      leading: const Icon(Icons.save),
                      title: Text(preset.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => ref
                            .read(filterPresetsProvider.notifier)
                            .deletePreset(preset.id),
                      ),
                      onTap: () => _applyPreset(
                        preset,
                        searchController,
                        selectedRole,
                        selectedDate,
                        ref,
                      ),
                    ),
                  )
                      .toList(),
                );
              },
            ),
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
    final _presetNameController = TextEditingController();

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
                validator: (value) =>
                value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.read(filterPresetsProvider.notifier).savePreset(
                      FilterPreset(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _presetNameController.text,
                        searchTerm: searchTerm,
                        role: role,
                        dateRange: dateRange,
                      ),
                    );
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
    ref.read(filteredUsersProvider.notifier).resetFilters();
  }

  void _applyPreset(
      FilterPreset preset,
      TextEditingController searchController,
      ValueNotifier<String?> selectedRole,
      ValueNotifier<DateRange?> selectedDate,
      WidgetRef ref,
      ) {
    searchController.text = preset.searchTerm;
    selectedRole.value = preset.role;
    selectedDate.value = preset.dateRange;
    ref.read(filteredUsersProvider.notifier).applyPreset(preset);
  }

  Widget _buildUserList(List<User> users) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(user);
      },
    );
  }

  Widget _buildUserListItem(User user) {
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
      onTap: () => _showUserDetailsDialog(user),
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

  void _showUserDetailsDialog(User user) {
    showDialog(
      context: navigatorKey.currentContext!,
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEditScreen(user: user),
                ),
              ),
            ),
          ],
        ),
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

final filterPresetsProvider = AsyncNotifierProvider<FilterPresetsNotifier, List<FilterPreset>>(
  FilterPresetsNotifier.new,
);

class FilterPresetsNotifier extends AsyncNotifier<List<FilterPreset>> {
  @override
  Future<List<FilterPreset>> build() async {
    // Replace with actual storage solution
    return mockPresets;
  }

  Future<void> savePreset(FilterPreset preset) async {
    state = await AsyncValue.guard(() async {
      final currentPresets = await build();
      return [...currentPresets, preset];
    });
  }

  Future<void> deletePreset(String presetId) async {
    state = await AsyncValue.guard(() async {
      final currentPresets = await build();
      return currentPresets.where((p) => p.id != presetId).toList();
    });
  }
}

final filteredUsersProvider = StateNotifierProvider<FilteredUsersNotifier, List<User>>((ref) {
  return FilteredUsersNotifier(ref.watch(userAdminProvider));
});

class FilteredUsersNotifier extends StateNotifier<List<User>> {
  final UserAdminNotifier _userAdminNotifier;

  FilteredUsersNotifier(this._userAdminNotifier) : super([]);

  void updateSearchQuery(String query) {
    state = _userAdminNotifier.users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void updateRoleFilter(String? role) {
    if (role == null) {
      state = _userAdminNotifier.users;
      return;
    }

    state = _userAdminNotifier.users.where((user) => user.role == role).toList();
  }

  void updateDateRangeFilter(DateRange? range) {
    if (range == null) {
      state = _userAdminNotifier.users;
      return;
    }

    state = _userAdminNotifier.users.where((user) {
      return user.registrationDate.isAfter(range.start) &&
          user.registrationDate.isBefore(range.end.add(const Duration(days: 1)));
    }).toList();
  }

  void applyPreset(FilterPreset preset) {
    List<User> filteredUsers = _userAdminNotifier.users;

    if (preset.searchTerm.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        return user.name.toLowerCase().contains(preset.searchTerm.toLowerCase()) ||
            user.email.toLowerCase().contains(preset.searchTerm.toLowerCase());
      }).toList();
    }

    if (preset.role != null) {
      filteredUsers = filteredUsers.where((user) => user.role == preset.role).toList();
    }

    if (preset.dateRange != null) {
      filteredUsers = filteredUsers.where((user) {
        return user.registrationDate.isAfter(preset.dateRange!.start) &&
            user.registrationDate.isBefore(preset.dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    state = filteredUsers;
  }

  void resetFilters() {
    state = _userAdminNotifier.users;
  }
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