import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (settings) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            // Profile
            _SectionHeader(title: settings.language == 'kh' ? 'គណនី' : 'Profile'),
            _ProfileCard(theme: theme),
            const SizedBox(height: 24),

            // Appearance
            _SectionHeader(title: settings.language == 'kh' ? 'រូបរាង' : 'Appearance'),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.dark_mode_outlined,
                  iconColor: Colors.indigo.shade400,
                  title: settings.language == 'kh' ? 'របៀបងងឹត' : 'Dark Mode',
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _LanguageRow(
                  theme: theme,
                  selected: settings.language,
                  label: settings.language == 'kh' ? 'ភាសា' : 'Language',
                  onChanged: (lang) =>
                      ref.read(settingsProvider.notifier).setLanguage(lang),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Medical Info
            _SectionHeader(
                title: settings.language == 'kh'
                    ? 'ព័ត៌មានវេជ្ជសាស្ត្រ'
                    : 'Medical Info'),
            _MedicalInfoCard(settings: settings, theme: theme),
            const SizedBox(height: 24),

            // Notifications
            _SectionHeader(
                title: settings.language == 'kh' ? 'ការជូនដំណឹង' : 'Notifications'),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.notifications_outlined,
                  iconColor: Colors.blue.shade400,
                  title: settings.language == 'kh'
                      ? 'ការជូនដំណឹងជំរុញ'
                      : 'Push Notifications',
                  subtitle: settings.language == 'kh'
                      ? 'ទទួលការជូនដំណឹងអំពីអាសន្ន'
                      : 'Receive alerts for nearby emergencies',
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Privacy
            _SectionHeader(
                title: settings.language == 'kh' ? 'ឯកជនភាព' : 'Privacy'),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.green.shade400,
                  title: settings.language == 'kh'
                      ? 'ការចូលទីតាំង'
                      : 'Location Access',
                  subtitle: settings.language == 'kh'
                      ? 'ប្រើដើម្បីស្វែងរកសេវាដែលនៅជិត'
                      : 'Used to find services near you',
                  value: _locationEnabled,
                  onChanged: (v) => setState(() => _locationEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Emergency Contacts
            _SectionHeader(
                title: settings.language == 'kh'
                    ? 'ទំនាក់ទំនងបន្ទាន់'
                    : 'Emergency Contacts'),
            _SettingsCard(
              theme: theme,
              children: [
                _NavTile(
                  theme: theme,
                  icon: Icons.people_outline_rounded,
                  iconColor: Colors.orange.shade400,
                  title: settings.language == 'kh'
                      ? 'គ្រប់គ្រងទំនាក់ទំនង'
                      : 'Manage Contacts',
                  subtitle: settings.language == 'kh'
                      ? 'បន្ថែម ឬ លុបទំនាក់ទំនងបន្ទាន់'
                      : 'Add or remove emergency contacts',
                  onTap: () => context.push('/contacts'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About
            _SectionHeader(title: settings.language == 'kh' ? 'អំពី' : 'About'),
            _SettingsCard(
              theme: theme,
              children: [
                _InfoTile(
                  theme: theme,
                  icon: Icons.info_outline_rounded,
                  iconColor: Colors.grey.shade500,
                  title: settings.language == 'kh' ? 'កំណែ' : 'App Version',
                  value: '1.0.0',
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _NavTile(
                  theme: theme,
                  icon: Icons.shield_outlined,
                  iconColor: Colors.grey.shade500,
                  title: settings.language == 'kh'
                      ? 'គោលការណ៍ភាពឯកជន'
                      : 'Privacy Policy',
                  onTap: () {},
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _NavTile(
                  theme: theme,
                  icon: Icons.description_outlined,
                  iconColor: Colors.grey.shade500,
                  title: settings.language == 'kh'
                      ? 'លក្ខខណ្ឌប្រើប្រាស់'
                      : 'Terms of Service',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            _SettingsCard(
              theme: theme,
              children: [
                _NavTile(
                  theme: theme,
                  icon: Icons.logout_rounded,
                  iconColor: Colors.red.shade400,
                  title: settings.language == 'kh' ? 'ចាកចេញ' : 'Sign Out',
                  titleColor: Colors.red.shade400,
                  onTap: () => _confirmSignOut(context, settings.language),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'kh' ? 'ចាកចេញ' : 'Sign Out'),
        content: Text(lang == 'kh'
            ? 'តើអ្នកពិតជាចង់ចាកចេញ?'
            : 'Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'kh' ? 'បោះបង់' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              lang == 'kh' ? 'ចាកចេញ' : 'Sign Out',
              style: TextStyle(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language Row ─────────────────────────────────────────────────────────────

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.theme,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final ThemeData theme;
  final String selected;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.teal.shade400.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.language_rounded,
                color: Colors.teal.shade400, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          _LanguageToggle(theme: theme, selected: selected, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle(
      {required this.theme, required this.selected, required this.onChanged});

  final ThemeData theme;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
              label: 'EN', value: 'en', selected: selected, onTap: onChanged),
          _LangChip(
              label: 'ខ្មែរ', value: 'kh', selected: selected, onTap: onChanged),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? Colors.teal.shade500 : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive
                ? Colors.white
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Medical Info Card ────────────────────────────────────────────────────────

class _MedicalInfoCard extends ConsumerStatefulWidget {
  const _MedicalInfoCard({required this.settings, required this.theme});

  final AppSettings settings;
  final ThemeData theme;

  @override
  ConsumerState<_MedicalInfoCard> createState() => _MedicalInfoCardState();
}

class _MedicalInfoCardState extends ConsumerState<_MedicalInfoCard> {
  static const _bloodGroups = [
    'A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'
  ];

  late String? _bloodGroup;
  late final TextEditingController _allergiesController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bloodGroup = widget.settings.bloodGroup;
    _allergiesController =
        TextEditingController(text: widget.settings.allergies ?? '');
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(settingsProvider.notifier).saveMedicalInfo(
          bloodGroup: _bloodGroup,
          allergies: _allergiesController.text.trim().isEmpty
              ? null
              : _allergiesController.text.trim(),
        );
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              widget.settings.language == 'kh' ? 'បានរក្សាទុក' : 'Saved'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final lang = widget.settings.language;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Blood Group label
          Text(
            lang == 'kh' ? 'ក្រុមឈាម' : 'Blood Group',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bloodGroups.map((group) {
              final isSelected = _bloodGroup == group;
              return GestureDetector(
                onTap: () => setState(() => _bloodGroup = group),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.red.shade600
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.red.shade600
                          : theme.dividerColor,
                    ),
                  ),
                  child: Text(
                    group,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          Text(
            lang == 'kh' ? 'អាឡែស៊ី' : 'Allergies',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _allergiesController,
            maxLines: 3,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: lang == 'kh'
                  ? 'ឧ. ប៉េនីស៊ីលីន ប្រូហ្វេន...'
                  : 'e.g. Penicillin, Ibuprofen...',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      lang == 'kh' ? 'រក្សាទុក' : 'Save',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children, required this.theme});

  final List<Widget> children;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.person_rounded,
                size: 34, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ASON User',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@ason.app',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final ThemeData theme;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.titleColor,
  });

  final ThemeData theme;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.theme,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final ThemeData theme;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
