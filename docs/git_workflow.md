# Git Rules

1. Never push directly to main

2. Create branch:
```
git checkout develop
git pull
git checkout -b feature/your-task
```
3. Commit style:
```
feat:
fix:
ui:
refactor:
docs:

Examples:

feat: add onboarding screen

fix: booking form validation

ui: improve emergency card layout
```
4. Pull latest develop before PR

5. PR title format:
```
[FEATURE] Home Screen
[FIX] Navigation issue
```
6. Resolve conflicts before merge