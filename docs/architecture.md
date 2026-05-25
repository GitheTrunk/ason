# Project Structure Planned
```
ason_app/
│
├── lib/
│   ├── main.dart
│   ├── app.dart
│
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_spacing.dart
│   │   │   └── app_constants.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── light_theme.dart
│   │   │   ├── dark_theme.dart
│   │   │   └── text_theme.dart
│   │   │
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   │
│   │   └── utils/
│   │       ├── validators.dart
│   │       └── extensions.dart
│
│   ├── models/
│   │   ├── emergency_service.dart
│   │   ├── review.dart
│   │   ├── booking.dart
│   │   ├── contact.dart
│   │   └── promotion.dart
│
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── storage_service.dart
│   │   └── launcher_service.dart
│
│   ├── repositories/
│   │   ├── emergency_repository.dart
│   │   ├── mock_repository.dart
│   │   └── supabase_repository.dart
│
│   ├── providers/
│   │   ├── emergency_provider.dart
│   │   ├── booking_provider.dart
│   │   ├── favorite_provider.dart
│   │   └── settings_provider.dart
│
│   ├── features/
│   │   ├── onboarding/
│   │   ├── home/
│   │   ├── nearby/
│   │   ├── detail/
│   │   ├── favorites/
│   │   ├── booking/
│   │   ├── reviews/
│   │   ├── map/
│   │   ├── gallery/
│   │   ├── chat/
│   │   └── settings/
│
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── shimmer_loader.dart
│       ├── empty_state.dart
│       └── error_placeholder.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── mock/
│       ├── emergency_services.json
│       ├── reviews.json
│       └── promotions.json
│
├── docs/
│   ├── setup.md
│   ├── git_workflow.md
│   └── architecture.md
│
├── README.md
└── pubspec.yaml
```

## Git branch
```
main
dev

feature/emergency-services
feature/personal-booking
feature/discovery-community
```

## Workflow:
```
feature branch
↓
Pull Request
↓
Review by team lead
↓
Merge → develop
↓
Stable release → main
```