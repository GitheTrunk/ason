import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/location_data.dart';
import '../../providers/profile_provider.dart';
import '../../providers/repository_providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _infoController = TextEditingController();
  final _allergiesController = TextEditingController();

  static const _bloodGroups = [
    'A+',
    'A−',
    'B+',
    'B−',
    'AB+',
    'AB−',
    'O+',
    'O−',
  ];

  bool _isEditing = false;
  bool _isSaving = false;
  bool _isUploadingImage = false;
  String? _email;
  String? _bloodGroup;
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedCommune;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value;
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _phoneController.text = profile.phone ?? '';
      _infoController.text = profile.importantInfo ?? '';
      _allergiesController.text = profile.allergies ?? '';
      _bloodGroup = profile.bloodGroup;
      _email = profile.email;

      if (profile.address != null && profile.address!.isNotEmpty) {
        final parts = profile.address!.split(', ');
        if (parts.length == 3) {
          _selectedCommune = parts[0];
          _selectedDistrict = parts[1];
          _selectedProvince = parts[2];
        } else if (parts.length == 1) {
          _selectedProvince = kCambodiaLocations.containsKey(parts[0])
              ? parts[0]
              : null;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _infoController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image == null) return;

    setState(() => _isUploadingImage = true);
    try {
      await ref.read(profileProvider.notifier).uploadAvatar(image);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile photo updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error uploading photo: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? true)) return;
    setState(() => _isSaving = true);

    final addressParts = [
      if (_selectedCommune != null) _selectedCommune!,
      if (_selectedDistrict != null) _selectedDistrict!,
      if (_selectedProvince != null) _selectedProvince!,
    ];
    final fullAddress = addressParts.isEmpty ? null : addressParts.join(', ');

    try {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            address: fullAddress,
            phone: _phoneController.text.trim(),
            importantInfo: _infoController.text.trim(),
            bloodGroup: _bloodGroup,
            allergies: _allergiesController.text.trim().isEmpty
                ? null
                : _allergiesController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        setState(() => _isEditing = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _changePassword() async {
    final passwordController = TextEditingController();
    bool changing = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(),
              helperText: 'Minimum 6 characters',
            ),
          ),
          actions: [
            TextButton(
              onPressed: changing ? null : () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: changing
                  ? null
                  : () async {
                      if (passwordController.text.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password must be at least 6 characters',
                            ),
                          ),
                        );
                        return;
                      }
                      setStateDialog(() => changing = true);
                      try {
                        await ref
                            .read(authRepositoryProvider)
                            .updatePassword(passwordController.text);
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password changed successfully!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      } finally {
                        if (context.mounted) {
                          setStateDialog(() => changing = false);
                        }
                      }
                    },
              child: changing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_isEditing) {
              setState(() => _isEditing = false);
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ── Avatar ────────────────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        backgroundImage: profile?.avatarUrl != null
                            ? NetworkImage(profile!.avatarUrl!)
                            : null,
                        child: _isUploadingImage
                            ? const CircularProgressIndicator()
                            : profile?.avatarUrl == null
                            ? Icon(
                                Icons.person_rounded,
                                size: 52,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUploadingImage
                                ? null
                                : _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (!_isEditing) ...[
                  Text(
                    profile?.name ?? 'No Name',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profile?.email ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                // ── Info Card ────────────────────────────────────
                _buildCard(
                  theme: theme,
                  children: [
                    _buildField(
                      theme: theme,
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: profile?.name,
                      controller: _nameController,
                      isEditing: _isEditing,
                    ),
                    _divider(theme),
                    _buildField(
                      theme: theme,
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: _email,
                      isEditing: false, // always read-only
                    ),
                    _divider(theme),
                    _buildField(
                      theme: theme,
                      icon: Icons.phone_outlined,
                      label: 'Phone Number',
                      value: profile?.phone,
                      controller: _phoneController,
                      isEditing: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    _divider(theme),
                    // Address
                    _isEditing
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                // Province Dropdown
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    8,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedProvince,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'Province / City',
                                      prefixIcon: const Icon(
                                        Icons.location_city_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: kCambodiaLocations.keys
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p,
                                            child: Text(p),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        _selectedProvince = v;
                                        _selectedDistrict = null;
                                        _selectedCommune = null;
                                      });
                                    },
                                  ),
                                ),
                                // District Dropdown
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    8,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedDistrict,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'District / Khan',
                                      prefixIcon: const Icon(
                                        Icons.map_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: _selectedProvince == null
                                        ? []
                                        : (kCambodiaLocations[_selectedProvince]
                                                      ?.keys
                                                      .toList() ??
                                                  [])
                                              .map(
                                                (d) => DropdownMenuItem(
                                                  value: d,
                                                  child: Text(d),
                                                ),
                                              )
                                              .toList(),
                                    onChanged: _selectedProvince == null
                                        ? null
                                        : (v) {
                                            setState(() {
                                              _selectedDistrict = v;
                                              _selectedCommune = null;
                                            });
                                          },
                                  ),
                                ),
                                // Commune Dropdown
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    8,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedCommune,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'Commune / Sangkat',
                                      prefixIcon: const Icon(
                                        Icons.pin_drop_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items:
                                        _selectedDistrict == null ||
                                            _selectedProvince == null
                                        ? []
                                        : (kCambodiaLocations[_selectedProvince]?[_selectedDistrict] ??
                                                  [])
                                              .map(
                                                (c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(c),
                                                ),
                                              )
                                              .toList(),
                                    onChanged: _selectedDistrict == null
                                        ? null
                                        : (v) {
                                            setState(() {
                                              _selectedCommune = v;
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _buildReadOnlyRow(
                            theme: theme,
                            icon: Icons.location_on_outlined,
                            label: 'Full Address',
                            value: profile?.address,
                          ),
                    _divider(theme),
                    _buildField(
                      theme: theme,
                      icon: Icons.info_outline,
                      label: 'Important Info',
                      value: profile?.importantInfo,
                      controller: _infoController,
                      isEditing: _isEditing,
                      maxLines: 3,
                    ),
                    _divider(theme),
                    _isEditing
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    8,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _bloodGroup,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: 'Blood Group',
                                      prefixIcon: const Icon(
                                        Icons.bloodtype_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: _bloodGroups
                                        .map(
                                          (group) => DropdownMenuItem(
                                            value: group,
                                            child: Text(group),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) =>
                                        setState(() => _bloodGroup = value),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    8,
                                  ),
                                  child: TextFormField(
                                    controller: _allergiesController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      labelText: 'Allergies',
                                      prefixIcon: const Icon(
                                        Icons.warning_amber_outlined,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              _buildReadOnlyRow(
                                theme: theme,
                                icon: Icons.bloodtype_outlined,
                                label: 'Blood Group',
                                value: profile?.bloodGroup,
                              ),
                              _divider(theme),
                              _buildReadOnlyRow(
                                theme: theme,
                                icon: Icons.warning_amber_outlined,
                                label: 'Allergies',
                                value: profile?.allergies,
                              ),
                            ],
                          ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Security Card ────────────────────────────────
                _buildCard(
                  theme: theme,
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.orange.shade600,
                          size: 20,
                        ),
                      ),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _changePassword,
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(ThemeData theme) =>
      Divider(height: 1, indent: 56, color: theme.dividerColor);

  Widget _buildField({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required bool isEditing,
    String? value,
    TextEditingController? controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    if (!isEditing) {
      return _buildReadOnlyRow(
        theme: theme,
        icon: icon,
        label: label,
        value: value,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildReadOnlyRow({
    required ThemeData theme,
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value?.isNotEmpty == true ? value! : '—',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: value?.isNotEmpty == true
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
