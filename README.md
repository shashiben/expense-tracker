# Expense Tracker

Minimal expense tracker app built with Flutter.

## Features
- Add, edit, delete expenses
- Search by title/category
- Filter by category; sort by date/category (asc/desc)
- Grouped list by date or category
- Tags (max 5 per expense)
- Google Fonts theme (Material 3)
- Bottom sheet for add/edit; dialog for filters

## Tech & Libraries
- Flutter
- Stacked + stacked_services
- Hive (hive_ce, hive_ce_flutter, hive_ce_generator)
- build_runner, json_serializable, json_annotation
- google_fonts

## Structure (short)
- lib/app → theme, constants
- lib/core/services → init, sheet/dialog setup
- lib/data → models, repository impl
- lib/domain → repository interfaces
- lib/ui → screens, dialogs, bottom_sheets, components, utils