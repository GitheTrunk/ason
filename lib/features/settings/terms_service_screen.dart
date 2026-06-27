import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_provider.dart';

bool _isKh(String lang) => lang == 'km' || lang == 'kh';

class TermsOfServiceScreen extends ConsumerWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang =
        ref.watch(settingsProvider).whenOrNull(data: (s) => s.language) ?? 'en';
    final kh = _isKh(lang);

    final pageTitle = kh ? 'លក្ខខណ្ឌប្រើប្រាស់' : 'Terms of Service';
    final introTitle = kh ? 'ការប្រើប្រាស់ ASON' : 'Using ASON';
    final introBody = kh
        ? 'ដោយប្រើ ASON អ្នកយល់ព្រមប្រើកម្មវិធីដោយទំនួលខុសត្រូវ និងរក្សាព័ត៌មានប្រវត្តិរូប និងព័ត៌មានបន្ទាន់ឲ្យបានត្រឹមត្រូវ។'
        : 'By using ASON, you agree to use the app responsibly and keep your profile and emergency information accurate.';

    final responsibilitiesTitle = kh
        ? 'ការទទួលខុសត្រូវរបស់អ្នក'
        : 'Your responsibilities';
    final responsibilitiesBullets = kh
        ? const [
            'ផ្តល់ព័ត៌មានប្រវត្តិរូប និងព័ត៌មានវេជ្ជសាស្ត្រឲ្យបានត្រឹមត្រូវ។',
            'កុំប្រើប្រាស់ខុសគោលបំណងទំនាក់ទំនងបន្ទាន់ ឬទិន្នន័យសេវាកម្ម។',
            'រក្សាគណនីរបស់អ្នកឲ្យមានសុវត្ថិភាព និងចាកចេញនៅលើឧបករណ៍រួមប្រើ។',
          ]
        : const [
            'Provide accurate profile and medical information.',
            'Do not misuse emergency contacts or service data.',
            'Keep your account secure and sign out on shared devices.',
          ];

    final availabilityTitle = kh
        ? 'ភាពអាចប្រើបាននៃសេវា'
        : 'Service availability';
    final availabilityBullets = kh
        ? const [
            'មុខងារអាចផ្លាស់ប្តូរទៅតាមការអភិវឌ្ឍន៍របស់កម្មវិធី។',
            'ទិន្នន័យខ្លះអាស្រ័យលើការតភ្ជាប់បណ្តាញ ឬស្ថានភាព backend។',
            'យើងអាចបង្កើន ឬដកមុខងារខ្លះនៅពេលដែលចាំបាច់។',
          ]
        : const [
            'Features may change over time as the app evolves.',
            'Some data may depend on network connectivity or backend availability.',
            'We may improve or remove features when needed.',
          ];

    final liabilityTitle = kh
        ? 'ដែនកំណត់នៃការទទួលខុសត្រូវ'
        : 'Limits of liability';
    final liabilityBody = kh
        ? 'ASON ជាឧបករណ៍គាំទ្រ ហើយមិនជំនួសការណែនាំ វិនិច្ឆ័យ ឬសេវាបន្ទាន់ជាវិជ្ជាជីវៈបានទេ។'
        : 'ASON is a support tool and does not replace professional medical advice, diagnosis, or emergency services.';

    final changesTitle = kh
        ? 'ការផ្លាស់ប្តូរលក្ខខណ្ឌទាំងនេះ'
        : 'Changes to these terms';
    final changesBody = kh
        ? 'យើងអាចធ្វើបច្ចុប្បន្នភាពលក្ខខណ្ឌទាំងនេះនៅពេលកម្មវិធី ឬ backend ផ្លាស់ប្តូរ។ ការប្រើប្រាស់បន្តមានន័យថាអ្នកទទួលយកលក្ខខណ្ឌដែលបានធ្វើបច្ចុប្បន្នភាព។'
        : 'We may update these terms when the app or backend changes. Continued use of the app means you accept the updated terms.';

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _IntroCard(theme: theme, title: introTitle, body: introBody),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: responsibilitiesTitle,
            bullets: responsibilitiesBullets,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: availabilityTitle,
            bullets: availabilityBullets,
          ),
          const SizedBox(height: 16),
          _SectionCard(
            theme: theme,
            title: liabilityTitle,
            body: liabilityBody,
          ),
          const SizedBox(height: 16),
          _SectionCard(theme: theme, title: changesTitle, body: changesBody),
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
