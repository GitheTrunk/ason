import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/settings_provider.dart';

bool _isKh(String lang) => lang == 'km' || lang == 'kh';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    final kh = _isKh(lang);

    final pageTitle = kh ? 'គោលការណ៍ឯកជនភាព' : 'Privacy Policy';
    final introTitle = kh
        ? 'ឯកជនភាពរបស់អ្នកមានសារៈសំខាន់'
        : 'Your privacy matters';
    final introBody = kh
        ? 'ASON រក្សាទុកព័ត៌មានប្រវត្តិរូប និងព័ត៌មានបន្ទាន់ ដើម្បីផ្តល់មុខងារដូចជា ការចែករំលែកទំនាក់ទំនង ព័ត៌មានវេជ្ជសាស្ត្រ និងការកំណត់ផ្ទាល់ខ្លួន។'
        : 'ASON stores profile and emergency information to provide app features such as contact sharing, medical details, and personalized settings.';

    final collectedTitle = kh
        ? 'ព័ត៌មានដែលយើងប្រមូល'
        : 'Information we collect';
    final collectedBullets = kh
        ? const [
            'ព័ត៌មានគណនី ដូចជា ឈ្មោះ អ៊ីមែល លេខទូរស័ព្ទ អាសយដ្ឋាន និងរូបភាពប្រវត្តិរូប។',
            'ព័ត៌មានវេជ្ជសាស្ត្រដែលអ្នករក្សាទុកក្នុងប្រវត្តិរូប ដូចជា ក្រុមឈាម និងអាឡែស៊ី។',
            'ទិន្នន័យការប្រើប្រាស់ដែលចាំបាច់សម្រាប់ឲ្យមុខងារកម្មវិធីដំណើរការបានត្រឹមត្រូវ។',
          ]
        : const [
            'Account details such as name, email, phone, address, and avatar.',
            'Medical info you save in your profile, such as blood group and allergies.',
            'Usage data needed to keep app features working correctly.',
          ];

    final useTitle = kh ? 'របៀបដែលយើងប្រើវា' : 'How we use it';
    final useBullets = kh
        ? const [
            'បង្ហាញប្រវត្តិរូប និងព័ត៌មានវេជ្ជសាស្ត្ររបស់អ្នកនៅក្នុងកម្មវិធី។',
            'ជួយអ្នកកែសម្រួល និងធ្វើបច្ចុប្បន្នភាពព័ត៌មានដែលបានរក្សាទុក។',
            'គាំទ្រមុខងារដែលពាក់ព័ន្ធនឹងសេវាបន្ទាន់ និងជំនួយដំបូង។',
          ]
        : const [
            'Show your profile and medical details inside the app.',
            'Help you edit and update your saved information.',
            'Support emergency and first-aid related features.',
          ];

    final sharingTitle = kh ? 'ការចែករំលែកទិន្នន័យ' : 'Data sharing';
    final sharingBullets = kh
        ? const [
            'យើងមិនលក់ទិន្នន័យផ្ទាល់ខ្លួន។',
            'ប្រវត្តិរូបរបស់អ្នកត្រូវបានរក្សាទុកនៅ backend នៃកម្មវិធី ហើយប្រើតែសម្រាប់មុខងារកម្មវិធីប៉ុណ្ណោះ។',
            'ការចែករំលែកនៅពេលក្រោយត្រូវមានការពន្យល់ច្បាស់លាស់មុនពេលអនុវត្ត។',
          ]
        : const [
            'We do not sell personal data.',
            'Your profile is stored in the app backend and only used for app functionality.',
            'Any future sharing should be clearly explained before it happens.',
          ];

    final contactTitle = kh ? 'ទាក់ទងមកយើង' : 'Contact us';
    final contactBody = kh
        ? 'ប្រសិនបើអ្នកមានសំណួរអំពីឯកជនភាព ឬទិន្នន័យប្រវត្តិរូបដែលបានរក្សាទុក សូមប្រើផ្លូវគាំទ្រកម្មវិធីដែលបានផ្តល់ដោយអង្គភាពរបស់អ្នក។'
        : 'If you have questions about privacy or your stored profile data, use the app support channel provided by your organization.';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
        ),
        title: Text(pageTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _IntroCard(theme: theme, title: introTitle, body: introBody),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: collectedTitle,
            bullets: collectedBullets,
          ),
          const SizedBox(height: 16),
          _SectionCard(theme: theme, title: useTitle, bullets: useBullets),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: sharingTitle,
            bullets: sharingBullets,
          ),
          const SizedBox(height: 16),
          _SectionCard(theme: theme, title: contactTitle, body: contactBody),
        ],
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({
    required this.theme,
    required this.title,
    required this.body,
  });

  final ThemeData theme;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.theme,
    required this.title,
    this.body,
    this.bullets = const [],
  });

  final ThemeData theme;
  final String title;
  final String? body;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (body != null) ...[
            const SizedBox(height: 10),
            Text(
              body!,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...bullets.map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bullet,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.theme, required this.child});

  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: child,
    );
  }
}
