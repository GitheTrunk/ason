import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/repository_providers.dart';
import '../../providers/settings_provider.dart';
import '../../providers/profile_provider.dart';

bool _isKh(String lang) => lang == 'km' || lang == 'kh';

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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
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
            _SectionHeader(
              title: _isKh(settings.language) ? 'គណនី' : 'Profile',
            ),
            _ProfileCard(theme: theme),
            const SizedBox(height: 24),

            // Appearance
            _SectionHeader(
              title: _isKh(settings.language) ? 'រូបរាង' : 'Appearance',
            ),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.dark_mode_outlined,
                  iconColor: Colors.indigo.shade400,
                  title: _isKh(settings.language) ? 'របៀបងងឹត' : 'Dark Mode',
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .setThemeMode(v ? ThemeMode.dark : ThemeMode.light),
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _LanguageRow(
                  theme: theme,
                  selected: settings.language,
                  label: _isKh(settings.language) ? 'ភាសា' : 'Language',
                  onChanged: (lang) =>
                      ref.read(settingsProvider.notifier).setLanguage(lang),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Medical Info
            _SectionHeader(
              title: _isKh(settings.language)
                  ? 'ព័ត៌មានវេជ្ជសាស្ត្រ'
                  : 'Medical Info',
            ),
            _MedicalInfoCard(theme: theme),
            const SizedBox(height: 24),

            // Notifications
            _SectionHeader(
              title: _isKh(settings.language) ? 'ការជូនដំណឹង' : 'Notifications',
            ),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.notifications_outlined,
                  iconColor: Colors.blue.shade400,
                  title: _isKh(settings.language)
                      ? 'ការជូនដំណឹងជំរុញ'
                      : 'Push Notifications',
                  subtitle: _isKh(settings.language)
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
              title: _isKh(settings.language) ? 'ឯកជនភាព' : 'Privacy',
            ),
            _SettingsCard(
              theme: theme,
              children: [
                _SwitchTile(
                  theme: theme,
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.green.shade400,
                  title: _isKh(settings.language)
                      ? 'ការចូលទីតាំង'
                      : 'Location Access',
                  subtitle: _isKh(settings.language)
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
              title: _isKh(settings.language)
                  ? 'ទំនាក់ទំនងបន្ទាន់'
                  : 'Emergency Contacts',
            ),
            _SettingsCard(
              theme: theme,
              children: [
                _NavTile(
                  theme: theme,
                  icon: Icons.people_outline_rounded,
                  iconColor: Colors.orange.shade400,
                  title: _isKh(settings.language)
                      ? 'ទំនាក់ទំនងបន្ទាន់'
                      : 'Emergency Contacts',
                  subtitle: _isKh(settings.language)
                      ? 'បន្ថែម ឬ លុបទំនាក់ទំនងបន្ទាន់'
                      : 'Add or remove emergency contact',
                  onTap: () => context.go('/contacts'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // About
            _SectionHeader(title: _isKh(settings.language) ? 'អំពី' : 'About'),
            _SettingsCard(
              theme: theme,
              children: [
                _InfoTile(
                  theme: theme,
                  icon: Icons.info_outline_rounded,
                  iconColor: Colors.grey.shade500,
                  title: _isKh(settings.language) ? 'កំណែ' : 'App Version',
                  value: '1.0.0',
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _NavTile(
                  theme: theme,
                  icon: Icons.shield_outlined,
                  iconColor: Colors.grey.shade500,
                  title: _isKh(settings.language)
                      ? 'គោលការណ៍ភាពឯកជន'
                      : 'Privacy Policy',
                  onTap: () => context.go('/privacy-policy'),
                ),
                Divider(height: 1, indent: 56, color: theme.dividerColor),
                _NavTile(
                  theme: theme,
                  icon: Icons.description_outlined,
                  iconColor: Colors.grey.shade500,
                  title: _isKh(settings.language)
                      ? 'លក្ខខណ្ឌប្រើប្រាស់'
                      : 'Terms of Service',
                  onTap: () => context.go('/terms-of-service'),
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
                  title: _isKh(settings.language) ? 'ចាកចេញ' : 'Sign Out',
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
        title: Text(_isKh(lang) ? 'ចាកចេញ' : 'Sign Out'),
        content: Text(
          _isKh(lang)
              ? 'តើអ្នកពិតជាចង់ចាកចេញ?'
              : 'Are you sure you want to sign out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(_isKh(lang) ? 'បោះបង់' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authRepositoryProvider).signOut();
            },
            child: Text(
              _isKh(lang) ? 'ចាកចេញ' : 'Sign Out',
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
            child: Icon(
              Icons.language_rounded,
              color: Colors.teal.shade400,
              size: 20,
            ),
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
          _LanguageToggle(
            theme: theme,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({
    required this.theme,
    required this.selected,
    required this.onChanged,
  });

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
            label: 'EN',
            value: 'en',
            selected: selected,
            onTap: onChanged,
          ),
          _LangChip(
            label: 'ខ្មែរ',
            value: 'km',
            selected: selected,
            onTap: onChanged,
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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

class _MedicalInfoCard extends ConsumerWidget {
  const _MedicalInfoCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';

    return profileAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Text('Error loading medical info: $e'),
      ),
      data: (profile) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              theme: theme,
              icon: Icons.bloodtype_outlined,
              label: _isKh(lang) ? 'ក្រុមឈាម' : 'Blood Group',
              value: profile?.bloodGroup,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              theme: theme,
              icon: Icons.warning_amber_outlined,
              label: _isKh(lang) ? 'អាឡែស៊ី' : 'Allergies',
              value: profile?.allergies,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/edit-profile'),
                icon: const Icon(Icons.edit_outlined),
                label: Text(_isKh(lang) ? 'កែសម្រួល' : 'Edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.theme,
    required this.icon,
    required this.label,
    required this.value,
  });

  final ThemeData theme;
  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withAlpha(120),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value?.isNotEmpty == true ? value! : '—',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
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

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error loading profile: $e'),
        data: (profile) => InkWell(
          onTap: () => context.push('/edit-profile'),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: profile?.avatarUrl != null
                    ? NetworkImage(profile!.avatarUrl!)
                    : null,
                child: profile?.avatarUrl == null
                    ? Icon(
                        Icons.person_rounded,
                        size: 34,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? 'No Name Provided',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.email ?? 'Unknown Email',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
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
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
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
