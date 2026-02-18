# tisini Mobile App — Technical Specification

> **Version:** 1.0.0
> **Last updated:** 2026-02-18
> **Status:** Implementation-ready
> **Audience:** Flutter developers, QA engineers, backend engineers (for API contract alignment)

---

## Table of Contents

1. [Project Overview & Tech Stack](#1-project-overview--tech-stack)
2. [Flutter Project Structure](#2-flutter-project-structure)
3. [Design System](#3-design-system)
4. [Navigation & Routing](#4-navigation--routing)
5. [State Management Architecture](#5-state-management-architecture)
6. [Data Models](#6-data-models)
7. [API Contract Definitions](#7-api-contract-definitions)
8. [Screen-by-Screen Specifications](#8-screen-by-screen-specifications)
9. [Shared Components](#9-shared-components)
10. [Authentication & Security](#10-authentication--security)
11. [Local Storage Strategy](#11-local-storage-strategy)
12. [Error Handling](#12-error-handling)
13. [Testing Strategy](#13-testing-strategy)
14. [Performance Considerations](#14-performance-considerations)
- [Appendix A: Feature Flag Registry](#appendix-a-feature-flag-registry)
- [Appendix B: Localization Strategy](#appendix-b-localization-strategy)
- [Appendix C: Analytics Event Catalog](#appendix-c-analytics-event-catalog)
- [Appendix D: Push Notification Types & Deep Links](#appendix-d-push-notification-types--deep-links)
- [Appendix E: Screen-to-Provider Mapping Matrix](#appendix-e-screen-to-provider-mapping-matrix)
- [Appendix F: Implementation Sprint Sequencing](#appendix-f-implementation-sprint-sequencing)

---

## 1. Project Overview & Tech Stack

### 1.1 Product Summary

tisini is a **mobile wallet + payments app** for African SMEs and gig workers, following a familiar PayPal/MoMo pattern. Three differentiators:

1. **Pia (AI co-pilot)** — turns payment behaviour and business signals into simple "what's due / what's happening / what to do next" guidance, shown as cards (not chat-first).
2. **Pension & compliance integration** — a core differentiator, not a side menu item. Compliance events feed the intelligence engine and anchor trust.
3. **Low/zero cost intent** — costs are transparent inside confirmation screens (quiet, not promotional).

### 1.2 Target Users (MVP)

- SMEs + gig workers / sole traders
- English may be a second language
- Many businesses are mixed activity (one business may do multiple things)

### 1.3 Design Philosophy

| Principle | Description |
|---|---|
| **Payments first** | Familiar and fast |
| **Compliance is visible** | Pension and statutory obligations surfaced in Pay, Dashboard, and Pia |
| **Intelligence second** | Pia explains what to do next, with short details |
| **Trust always** | Confirmation screens show route + cost + total; KYC and security are explicit |

### 1.4 Banned Language

Never use these terms anywhere in the app UI, copy, or code-facing strings:

> credit score, rating, underwriting, risk, flag, insights, proof, full picture, monitoring

tisini is a **business operations + compliance readiness** product that happens to use payments.

### 1.5 MVP Scope

- **72 mobile screens** (iOS + Android)
- No admin dashboard (web, separate project)
- Stablecoin rails deferred to Phase 2 (UI is rails-ready via feature flag)
- Pension, categorisation, and bulk import are included in MVP

### 1.6 Dependency Table

| Package | Version | Purpose |
|---|---|---|
| `flutter` | `>=3.24.0` | Framework |
| `flutter_riverpod` | `^2.6.1` | State management |
| `riverpod_annotation` | `^2.6.1` | Code-gen for providers |
| `go_router` | `^14.6.0` | Declarative routing with deep links |
| `dio` | `^5.7.0` | HTTP client with interceptors |
| `drift` | `^2.22.0` | SQLite ORM for local cache |
| `flutter_secure_storage` | `^9.2.3` | Encrypted token/PIN storage |
| `freezed_annotation` | `^2.4.6` | Immutable data classes |
| `json_annotation` | `^4.9.0` | JSON serialization |
| `local_auth` | `^2.3.0` | Biometric authentication |
| `camera` | `^0.11.0` | KYC document capture / QR scan |
| `mobile_scanner` | `^6.0.0` | QR/barcode scanning |
| `file_picker` | `^8.1.0` | CSV file selection for bulk import |
| `csv` | `^6.0.0` | CSV parsing |
| `fl_chart` | `^0.69.0` | Ring chart + bar indicators |
| `share_plus` | `^10.1.0` | Share receipts / payment requests |
| `url_launcher` | `^6.3.1` | External links (help, legal) |
| `connectivity_plus` | `^6.1.0` | Network state monitoring |
| `firebase_messaging` | `^15.1.0` | Push notifications |
| `firebase_analytics` | `^11.3.0` | Analytics |
| `phosphor_flutter` | `^2.1.0` | Icon set |
| `intl` | `^0.19.0` | Localization + number/date formatting |
| `shared_preferences` | `^2.3.3` | Simple key-value flags |
| `path_provider` | `^2.1.5` | File system paths |
| `flutter_native_splash` | `^2.4.2` | Native splash screen |
| `envied` | `^1.0.0` | Environment variable injection |

**Dev dependencies:**

| Package | Version | Purpose |
|---|---|---|
| `build_runner` | `^2.4.13` | Code generation |
| `freezed` | `^2.5.7` | Data class codegen |
| `json_serializable` | `^6.8.0` | JSON codegen |
| `riverpod_generator` | `^2.6.2` | Provider codegen |
| `drift_dev` | `^2.22.0` | Drift codegen |
| `mockito` | `^5.4.4` | Test mocking |
| `mocktail` | `^1.0.4` | Lightweight mocks |
| `golden_toolkit` | `^0.15.0` | Golden tests |
| `patrol` | `^3.13.0` | Integration tests |
| `very_good_analysis` | `^6.0.0` | Lint rules |

---

## 2. Flutter Project Structure

### 2.1 Architecture: Feature-First Clean Architecture

```
presentation → domain ← data
```

- **Domain** is the center; it has zero dependencies on Flutter or external packages.
- **Data** implements domain contracts (repositories, datasources).
- **Presentation** depends on domain entities and providers, never on data layer directly.

### 2.2 Complete Folder Tree

```
lib/
├── main.dart
├── app.dart                          # MaterialApp.router + ProviderScope
├── bootstrap.dart                    # Pre-runApp initialization
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radii.dart
│   │   └── api_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart            # ThemeData construction
│   │   └── color_extensions.dart
│   ├── network/
│   │   ├── dio_client.dart           # Dio instance + interceptors
│   │   ├── auth_interceptor.dart     # Token attach + refresh
│   │   ├── error_interceptor.dart
│   │   └── connectivity_interceptor.dart
│   ├── errors/
│   │   ├── exceptions.dart           # Exception hierarchy
│   │   ├── failures.dart             # Failure sealed class
│   │   └── error_handler.dart
│   ├── storage/
│   │   ├── secure_storage.dart       # FlutterSecureStorage wrapper
│   │   ├── preferences.dart          # SharedPreferences wrapper
│   │   └── database/
│   │       ├── app_database.dart     # Drift database definition
│   │       ├── app_database.g.dart
│   │       └── daos/                 # Data access objects per table
│   ├── router/
│   │   ├── app_router.dart           # GoRouter configuration
│   │   ├── route_names.dart          # Route name constants
│   │   └── guards/
│   │       ├── auth_guard.dart
│   │       ├── kyc_guard.dart
│   │       └── step_up_guard.dart
│   ├── providers/
│   │   ├── core_providers.dart       # Dio, DB, SecureStorage providers
│   │   ├── auth_state_provider.dart
│   │   ├── connectivity_provider.dart
│   │   └── user_provider.dart
│   └── utils/
│       ├── formatters.dart           # Currency, date, phone formatters
│       ├── validators.dart
│       └── debouncer.dart
│
├── shared/
│   ├── widgets/
│   │   ├── payee_card.dart
│   │   ├── route_chip.dart
│   │   ├── cost_line.dart
│   │   ├── pia_card_widget.dart
│   │   ├── tisini_index_ring.dart
│   │   ├── dashboard_bar_indicator.dart
│   │   ├── badge_chip.dart
│   │   ├── transaction_row.dart
│   │   ├── category_tag.dart
│   │   ├── pin_merchant_control.dart
│   │   ├── receipt_template.dart
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── app_card.dart
│   │   ├── loading_overlay.dart
│   │   ├── error_view.dart
│   │   ├── empty_state.dart
│   │   └── bottom_nav_scaffold.dart
│   └── extensions/
│       ├── context_extensions.dart
│       └── string_extensions.dart
│
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │
│   ├── onboarding/
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── onboarding_page.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── onboarding_screen.dart
│   │       │   └── permissions_screen.dart
│   │       ├── widgets/
│   │       │   ├── onboarding_page_view.dart
│   │       │   └── dot_indicator.dart
│   │       └── providers/
│   │           └── onboarding_provider.dart
│   │
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── auth_token.dart
│   │   │   │   └── user.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart          # abstract
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── auth_token_model.dart
│   │   │   │   └── user_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── otp_screen.dart
│   │       │   └── create_pin_screen.dart
│   │       ├── widgets/
│   │       │   ├── phone_input.dart
│   │       │   ├── otp_input.dart
│   │       │   └── pin_pad.dart
│   │       └── providers/
│   │           ├── auth_provider.dart
│   │           ├── login_controller.dart
│   │           └── pin_controller.dart
│   │
│   ├── home/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── tisini_index.dart
│   │   │   │   ├── dashboard_indicator.dart
│   │   │   │   ├── attention_item.dart
│   │   │   │   └── badge.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── tisini_index_model.dart
│   │   │   │   └── attention_item_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── dashboard_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── dashboard_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── home_screen.dart
│   │       │   ├── dashboard_screen.dart
│   │       │   ├── attention_list_screen.dart
│   │       │   └── insight_detail_screen.dart
│   │       ├── widgets/
│   │       │   ├── welcome_header.dart
│   │       │   ├── index_ring_section.dart
│   │       │   ├── indicators_section.dart
│   │       │   ├── badges_row.dart
│   │       │   └── pia_guidance_card.dart
│   │       └── providers/
│   │           ├── dashboard_provider.dart
│   │           └── attention_provider.dart
│   │
│   ├── pay/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── payee.dart
│   │   │   │   ├── payment.dart
│   │   │   │   ├── payment_receipt.dart
│   │   │   │   ├── payment_route.dart
│   │   │   │   ├── payment_request.dart
│   │   │   │   └── top_up.dart
│   │   │   └── repositories/
│   │   │       ├── payment_repository.dart
│   │   │       └── payee_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── payee_model.dart
│   │   │   │   ├── payment_model.dart
│   │   │   │   ├── payment_receipt_model.dart
│   │   │   │   └── payment_request_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── payment_remote_datasource.dart
│   │   │   │   └── payee_local_datasource.dart
│   │   │   └── repositories/
│   │   │       ├── payment_repository_impl.dart
│   │   │       └── payee_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── pay_hub_screen.dart
│   │       │   ├── send/
│   │       │   │   ├── send_recipient_screen.dart
│   │       │   │   ├── send_details_screen.dart
│   │       │   │   ├── send_amount_screen.dart
│   │       │   │   ├── send_confirm_screen.dart
│   │       │   │   ├── send_receipt_screen.dart
│   │       │   │   └── send_failed_screen.dart
│   │       │   ├── request/
│   │       │   │   ├── request_create_screen.dart
│   │       │   │   ├── request_share_screen.dart
│   │       │   │   └── request_status_screen.dart
│   │       │   ├── scan/
│   │       │   │   ├── scan_screen.dart
│   │       │   │   ├── scan_manual_entry_screen.dart
│   │       │   │   ├── scan_confirm_screen.dart
│   │       │   │   └── scan_receipt_screen.dart
│   │       │   ├── business/
│   │       │   │   ├── business_category_screen.dart
│   │       │   │   ├── business_payee_screen.dart
│   │       │   │   ├── business_confirm_screen.dart
│   │       │   │   └── business_receipt_screen.dart
│   │       │   └── topup/
│   │       │       ├── topup_source_screen.dart
│   │       │       ├── topup_amount_screen.dart
│   │       │       ├── topup_confirm_screen.dart
│   │       │       └── topup_receipt_screen.dart
│   │       ├── widgets/
│   │       │   ├── pay_category_tile.dart
│   │       │   ├── amount_input.dart
│   │       │   ├── route_selector.dart
│   │       │   └── confirmation_summary.dart
│   │       └── providers/
│   │           ├── pay_hub_provider.dart
│   │           ├── send_controller.dart
│   │           ├── request_controller.dart
│   │           ├── scan_controller.dart
│   │           ├── business_pay_controller.dart
│   │           └── topup_controller.dart
│   │
│   ├── pensions/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── pension_status.dart
│   │   │   │   ├── pension_contribution.dart
│   │   │   │   └── pension_reminder.dart
│   │   │   └── repositories/
│   │   │       └── pension_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── pension_status_model.dart
│   │   │   │   └── pension_contribution_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── pension_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── pension_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── pension_hub_screen.dart
│   │       │   ├── pension_contribute_screen.dart
│   │       │   ├── pension_confirm_screen.dart
│   │       │   ├── pension_receipt_screen.dart
│   │       │   └── pension_history_screen.dart
│   │       ├── widgets/
│   │       │   ├── pension_status_card.dart
│   │       │   ├── next_due_banner.dart
│   │       │   └── contribution_row.dart
│   │       └── providers/
│   │           ├── pension_provider.dart
│   │           └── pension_contribute_controller.dart
│   │
│   ├── pia/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── pia_card.dart
│   │   │   │   └── pia_action.dart
│   │   │   └── repositories/
│   │   │       └── pia_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── pia_card_model.dart
│   │   │   │   └── pia_action_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── pia_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── pia_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── pia_feed_screen.dart
│   │       │   ├── pia_empty_screen.dart
│   │       │   ├── pia_card_detail_screen.dart
│   │       │   └── pia_pinned_items_screen.dart
│   │       ├── widgets/
│   │       │   ├── pia_action_reminder_modal.dart
│   │       │   ├── pia_action_schedule_modal.dart
│   │       │   └── pia_feed_list.dart
│   │       └── providers/
│   │           ├── pia_feed_provider.dart
│   │           └── pia_action_controller.dart
│   │
│   ├── activity/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── transaction.dart
│   │   │   │   └── export_job.dart
│   │   │   └── repositories/
│   │   │       └── transaction_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── transaction_model.dart
│   │   │   │   └── export_job_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── transaction_remote_datasource.dart
│   │   │   │   └── transaction_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── transaction_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── activity_list_screen.dart
│   │       │   ├── activity_filters_screen.dart
│   │       │   ├── transaction_detail_screen.dart
│   │       │   ├── export_period_screen.dart
│   │       │   ├── export_confirm_screen.dart
│   │       │   └── export_success_screen.dart
│   │       ├── widgets/
│   │       │   ├── transaction_list.dart
│   │       │   ├── filter_chips.dart
│   │       │   └── category_edit_sheet.dart
│   │       └── providers/
│   │           ├── activity_provider.dart
│   │           ├── transaction_detail_provider.dart
│   │           └── export_controller.dart
│   │
│   ├── more/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── connected_account.dart
│   │   │   │   ├── pinned_merchant.dart
│   │   │   │   └── user_profile.dart
│   │   │   └── repositories/
│   │   │       ├── settings_repository.dart
│   │   │       └── merchant_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── connected_account_model.dart
│   │   │   │   └── pinned_merchant_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── settings_remote_datasource.dart
│   │   │   │   └── merchant_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       ├── settings_repository_impl.dart
│   │   │       └── merchant_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── more_hub_screen.dart
│   │       │   ├── profile_screen.dart
│   │       │   ├── connected_accounts_screen.dart
│   │       │   ├── connect_account_screen.dart
│   │       │   ├── security_settings_screen.dart
│   │       │   ├── notification_settings_screen.dart
│   │       │   ├── pinned_merchants_screen.dart
│   │       │   ├── help_support_screen.dart
│   │       │   └── legal_about_screen.dart
│   │       ├── widgets/
│   │       │   ├── settings_tile.dart
│   │       │   └── merchant_role_editor.dart
│   │       └── providers/
│   │           ├── profile_provider.dart
│   │           ├── connected_accounts_provider.dart
│   │           ├── security_provider.dart
│   │           └── merchants_provider.dart
│   │
│   ├── bulk_import/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── import_job.dart
│   │   │   │   ├── import_mapping.dart
│   │   │   │   └── import_result.dart
│   │   │   └── repositories/
│   │   │       └── import_repository.dart
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── import_job_model.dart
│   │   │   │   └── import_result_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── import_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── import_repository_impl.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── import_source_screen.dart
│   │       │   ├── import_upload_screen.dart
│   │       │   ├── import_review_screen.dart
│   │       │   ├── import_progress_screen.dart
│   │       │   └── import_result_screen.dart
│   │       ├── widgets/
│   │       │   ├── field_mapping_row.dart
│   │       │   ├── sample_preview_table.dart
│   │       │   └── import_progress_indicator.dart
│   │       └── providers/
│   │           └── import_controller.dart
│   │
│   └── kyc/
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── kyc_submission.dart
│       │   │   └── kyc_document.dart
│       │   └── repositories/
│       │       └── kyc_repository.dart
│       ├── data/
│       │   ├── models/
│       │   │   ├── kyc_submission_model.dart
│       │   │   └── kyc_document_model.dart
│       │   ├── datasources/
│       │   │   └── kyc_remote_datasource.dart
│       │   └── repositories/
│       │       └── kyc_repository_impl.dart
│       └── presentation/
│           ├── screens/
│           │   ├── kyc_entry_screen.dart
│           │   ├── kyc_account_type_screen.dart
│           │   ├── kyc_checklist_screen.dart
│           │   ├── kyc_capture_id_front_screen.dart
│           │   ├── kyc_capture_id_back_screen.dart
│           │   ├── kyc_selfie_screen.dart
│           │   ├── kyc_review_screen.dart
│           │   ├── kyc_pending_screen.dart
│           │   ├── kyc_approved_screen.dart
│           │   └── kyc_failed_screen.dart
│           ├── widgets/
│           │   ├── document_capture_frame.dart
│           │   ├── kyc_progress_stepper.dart
│           │   └── kyc_status_card.dart
│           └── providers/
│               ├── kyc_provider.dart
│               └── kyc_capture_controller.dart
│
├── l10n/
│   ├── app_en.arb                    # Default locale (en_UG)
│   └── arb_dir.yaml
│
└── gen/                              # Generated code (build_runner)
    └── ...
```

---

## 3. Design System

### 3.1 Color Tokens

```dart
// lib/core/constants/app_colors.dart
import 'dart:ui';

abstract final class AppColors {
  // Brand Primary
  static const darkBlue    = Color(0xFF243452);
  static const green       = Color(0xFF0AF5B4);
  static const cyan        = Color(0xFF0098FF);
  static const red         = Color(0xFFFF005C);

  // Neutrals
  static const grey        = Color(0xFFA3AAB6);
  static const background  = Color(0xFFF7F8FA);
  static const cardWhite   = Color(0xFFFFFFFF);
  static const black       = Color(0xFF1A1A1A);
  static const white       = Color(0xFFFFFFFF);

  // Semantic
  static const success     = green;
  static const error       = red;
  static const info        = cyan;
  static const warning     = Color(0xFFFFA726); // amber for 31-60 zone

  // Card border
  static const cardBorder  = Color(0xFFE8EAED);

  // tisini index zones
  static const zoneRed     = red;         // 0-30
  static const zoneAmber   = Color(0xFFFFA726); // 31-60
  static const zoneGreen   = green;       // 61-90

  // Opacity variants
  static Color darkBlue10  = darkBlue.withValues(alpha: 0.1);
  static Color darkBlue50  = darkBlue.withValues(alpha: 0.5);
  static Color grey40      = grey.withValues(alpha: 0.4);
}
```

### 3.2 Typography Scale

```dart
// lib/core/constants/app_typography.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const _fontFamily = 'Inter';

  // Display
  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,          // 40px line height
    letterSpacing: -0.5,
    color: AppColors.darkBlue,
  );

  // Headings
  static const headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,          // 32px
    letterSpacing: -0.25,
    color: AppColors.darkBlue,
  );

  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,           // 28px
    color: AppColors.darkBlue,
  );

  static const headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,          // 24px
    color: AppColors.darkBlue,
  );

  // Titles
  static const titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,           // 24px
    color: AppColors.darkBlue,
  );

  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,          // 20px
    color: AppColors.darkBlue,
  );

  // Body
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,           // 24px
    color: AppColors.darkBlue,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,          // 20px
    color: AppColors.darkBlue,
  );

  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,          // 16px
    color: AppColors.grey,
  );

  // Labels
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,          // 20px
    color: AppColors.darkBlue,
  );

  static const labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,          // 16px
    color: AppColors.darkBlue,
  );

  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.2,           // 12px
    color: AppColors.grey,
  );

  // Currency / amounts
  static const amountLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,          // 36px
    letterSpacing: -0.5,
    color: AppColors.darkBlue,
  );

  static const amountMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,           // 28px
    color: AppColors.darkBlue,
  );
}
```

### 3.3 Spacing System (8pt Grid)

```dart
// lib/core/constants/app_spacing.dart
abstract final class AppSpacing {
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 16;
  static const double lg   = 24;
  static const double xl   = 32;
  static const double xxl  = 40;
  static const double xxxl = 48;

  // Semantic aliases
  static const double cardPadding     = md;   // 16
  static const double sectionGap      = lg;   // 24
  static const double screenPadding   = md;   // 16
  static const double listItemSpacing = sm;   // 8
  static const double inputSpacing    = md;   // 16
}
```

### 3.4 Radii, Shadows, Borders

```dart
// lib/core/constants/app_radii.dart
import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const double card    = 16;
  static const double cardSm  = 14;
  static const double cardLg  = 18;
  static const double pill    = 999;
  static const double input   = 12;
  static const double button  = 12;
  static const double chip    = 999;
  static const double modal   = 24;

  static final BorderRadius cardBorder   = BorderRadius.circular(card);
  static final BorderRadius pillBorder   = BorderRadius.circular(pill);
  static final BorderRadius inputBorder  = BorderRadius.circular(input);
  static final BorderRadius buttonBorder = BorderRadius.circular(button);
  static final BorderRadius modalBorder  = BorderRadius.circular(modal);
}
```

```dart
// Shadows and borders (inline with theme)
abstract final class AppShadows {
  static const cardShadow = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}

abstract final class AppBorders {
  static const cardBorder = BorderSide(
    color: Color(0xFFE8EAED),
    width: 1,
  );
}
```

### 3.5 Icon Set

Use **Phosphor Icons** (`phosphor_flutter`) for all icons. They provide a consistent, modern line icon set that matches the minimal fintech aesthetic.

Key icon mappings:

| Usage | Icon |
|---|---|
| Home tab | `PhosphorIconsBold.house` |
| Pay tab | `PhosphorIconsBold.arrowsLeftRight` |
| Pia tab | `PhosphorIconsBold.sparkle` |
| Activity tab | `PhosphorIconsBold.clockCounterClockwise` |
| More tab | `PhosphorIconsBold.dotsThreeOutline` |
| Send | `PhosphorIconsRegular.paperPlaneTilt` |
| Request | `PhosphorIconsRegular.arrowDown` |
| Scan | `PhosphorIconsRegular.qrCode` |
| Pension | `PhosphorIconsRegular.shieldCheck` |
| Top up | `PhosphorIconsRegular.plus` |
| Back | `PhosphorIconsRegular.arrowLeft` |
| Close | `PhosphorIconsRegular.x` |
| Filter | `PhosphorIconsRegular.funnel` |
| Export | `PhosphorIconsRegular.export` |
| Pin merchant | `PhosphorIconsRegular.pushPin` |
| Category | `PhosphorIconsRegular.tag` |
| Security | `PhosphorIconsRegular.lock` |
| Notification | `PhosphorIconsRegular.bell` |
| Help | `PhosphorIconsRegular.question` |

### 3.6 ThemeData Construction

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_radii.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Inter',

    // Colors
    colorScheme: const ColorScheme.light(
      primary: AppColors.darkBlue,
      secondary: AppColors.green,
      tertiary: AppColors.cyan,
      error: AppColors.red,
      surface: AppColors.cardWhite,
      onPrimary: AppColors.white,
      onSecondary: AppColors.darkBlue,
      onSurface: AppColors.darkBlue,
      onError: AppColors.white,
      outline: AppColors.cardBorder,
    ),
    scaffoldBackgroundColor: AppColors.background,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.darkBlue,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.titleLarge,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Bottom Nav
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.darkBlue,
      unselectedItemColor: AppColors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: AppTypography.labelSmall,
      unselectedLabelStyle: AppTypography.labelSmall,
    ),

    // Cards
    cardTheme: CardThemeData(
      color: AppColors.cardWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
        side: AppBorders.cardBorder,
      ),
      margin: EdgeInsets.zero,
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadii.inputBorder,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadii.inputBorder,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadii.inputBorder,
        borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadii.inputBorder,
        borderSide: const BorderSide(color: AppColors.red, width: 1),
      ),
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.grey),
      errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.red),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.buttonBorder,
        ),
        textStyle: AppTypography.titleMedium.copyWith(color: AppColors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkBlue,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.buttonBorder,
        ),
        side: const BorderSide(color: AppColors.darkBlue, width: 1),
        textStyle: AppTypography.titleMedium,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.cyan,
        textStyle: AppTypography.titleMedium.copyWith(color: AppColors.cyan),
      ),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.background,
      selectedColor: AppColors.darkBlue10,
      labelStyle: AppTypography.labelMedium,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.pillBorder,
      ),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.cardBorder,
      thickness: 1,
      space: 0,
    ),

    // Bottom sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardBorder,
      ),
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      headlineLarge: AppTypography.headlineLarge,
      headlineMedium: AppTypography.headlineMedium,
      headlineSmall: AppTypography.headlineSmall,
      titleLarge: AppTypography.titleLarge,
      titleMedium: AppTypography.titleMedium,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.labelLarge,
      labelMedium: AppTypography.labelMedium,
      labelSmall: AppTypography.labelSmall,
    ),
  );
}
```

---

## 4. Navigation & Routing

### 4.1 GoRouter Configuration

```dart
// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_names.dart';
import 'guards/auth_guard.dart';
import 'guards/kyc_guard.dart';
import 'guards/step_up_guard.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) => authGuard(authState, state),
    routes: [
      // --- Pre-auth routes ---
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: RouteNames.otp,
        builder: (_, __) => const OtpScreen(),
      ),
      GoRoute(
        path: '/create-pin',
        name: RouteNames.createPin,
        builder: (_, __) => const CreatePinScreen(),
      ),
      GoRoute(
        path: '/permissions',
        name: RouteNames.permissions,
        builder: (_, __) => const PermissionsScreen(),
      ),

      // --- Main app shell with bottom tabs ---
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => BottomNavScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (_, __) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'dashboard',
                    name: RouteNames.dashboard,
                    builder: (_, __) => const DashboardScreen(),
                  ),
                  GoRoute(
                    path: 'attention',
                    name: RouteNames.attentionList,
                    builder: (_, __) => const AttentionListScreen(),
                  ),
                  GoRoute(
                    path: 'insight/:id',
                    name: RouteNames.insightDetail,
                    builder: (_, state) => InsightDetailScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 1: Pay
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pay',
                name: RouteNames.payHub,
                builder: (_, __) => const PayHubScreen(),
                routes: [
                  // Send flow
                  GoRoute(
                    path: 'send/recipient',
                    name: RouteNames.sendRecipient,
                    builder: (_, __) => const SendRecipientScreen(),
                  ),
                  GoRoute(
                    path: 'send/details',
                    name: RouteNames.sendDetails,
                    builder: (_, __) => const SendDetailsScreen(),
                  ),
                  GoRoute(
                    path: 'send/amount',
                    name: RouteNames.sendAmount,
                    builder: (_, __) => const SendAmountScreen(),
                  ),
                  GoRoute(
                    path: 'send/confirm',
                    name: RouteNames.sendConfirm,
                    redirect: (_, state) => stepUpGuard(ref, state),
                    builder: (_, __) => const SendConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'send/receipt/:txId',
                    name: RouteNames.sendReceipt,
                    builder: (_, state) => SendReceiptScreen(
                      txId: state.pathParameters['txId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'send/failed',
                    name: RouteNames.sendFailed,
                    builder: (_, __) => const SendFailedScreen(),
                  ),

                  // Request flow
                  GoRoute(
                    path: 'request/create',
                    name: RouteNames.requestCreate,
                    builder: (_, __) => const RequestCreateScreen(),
                  ),
                  GoRoute(
                    path: 'request/share/:id',
                    name: RouteNames.requestShare,
                    builder: (_, state) => RequestShareScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'request/status/:id',
                    name: RouteNames.requestStatus,
                    builder: (_, state) => RequestStatusScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),

                  // Scan/Pay flow
                  GoRoute(
                    path: 'scan',
                    name: RouteNames.scan,
                    builder: (_, __) => const ScanScreen(),
                  ),
                  GoRoute(
                    path: 'scan/manual',
                    name: RouteNames.scanManual,
                    builder: (_, __) => const ScanManualEntryScreen(),
                  ),
                  GoRoute(
                    path: 'scan/confirm',
                    name: RouteNames.scanConfirm,
                    redirect: (_, state) => stepUpGuard(ref, state),
                    builder: (_, __) => const ScanConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'scan/receipt/:txId',
                    name: RouteNames.scanReceipt,
                    builder: (_, state) => ScanReceiptScreen(
                      txId: state.pathParameters['txId']!,
                    ),
                  ),

                  // Pay business template flow
                  GoRoute(
                    path: 'business/category',
                    name: RouteNames.businessCategory,
                    builder: (_, __) => const BusinessCategoryScreen(),
                  ),
                  GoRoute(
                    path: 'business/payee',
                    name: RouteNames.businessPayee,
                    builder: (_, __) => const BusinessPayeeScreen(),
                  ),
                  GoRoute(
                    path: 'business/confirm',
                    name: RouteNames.businessConfirm,
                    redirect: (_, state) => stepUpGuard(ref, state),
                    builder: (_, __) => const BusinessConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'business/receipt/:txId',
                    name: RouteNames.businessReceipt,
                    builder: (_, state) => BusinessReceiptScreen(
                      txId: state.pathParameters['txId']!,
                    ),
                  ),

                  // Top up flow
                  GoRoute(
                    path: 'topup/source',
                    name: RouteNames.topupSource,
                    builder: (_, __) => const TopupSourceScreen(),
                  ),
                  GoRoute(
                    path: 'topup/amount',
                    name: RouteNames.topupAmount,
                    builder: (_, __) => const TopupAmountScreen(),
                  ),
                  GoRoute(
                    path: 'topup/confirm',
                    name: RouteNames.topupConfirm,
                    builder: (_, __) => const TopupConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'topup/receipt/:txId',
                    name: RouteNames.topupReceipt,
                    builder: (_, state) => TopupReceiptScreen(
                      txId: state.pathParameters['txId']!,
                    ),
                  ),

                  // Pensions (sub-route of Pay — pension is a pay category)
                  GoRoute(
                    path: 'pensions',
                    name: RouteNames.pensionHub,
                    builder: (_, __) => const PensionHubScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/contribute',
                    name: RouteNames.pensionContribute,
                    builder: (_, __) => const PensionContributeScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/confirm',
                    name: RouteNames.pensionConfirm,
                    redirect: (_, state) => stepUpGuard(ref, state),
                    builder: (_, __) => const PensionConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'pensions/receipt/:txId',
                    name: RouteNames.pensionReceipt,
                    builder: (_, state) => PensionReceiptScreen(
                      txId: state.pathParameters['txId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'pensions/history',
                    name: RouteNames.pensionHistory,
                    builder: (_, __) => const PensionHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2: Pia
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pia',
                name: RouteNames.piaFeed,
                builder: (_, __) => const PiaFeedScreen(),
                routes: [
                  GoRoute(
                    path: 'empty',
                    name: RouteNames.piaEmpty,
                    builder: (_, __) => const PiaEmptyScreen(),
                  ),
                  GoRoute(
                    path: 'card/:id',
                    name: RouteNames.piaCardDetail,
                    builder: (_, state) => PiaCardDetailScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'pinned',
                    name: RouteNames.piaPinned,
                    builder: (_, __) => const PiaPinnedItemsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Activity
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                name: RouteNames.activityList,
                builder: (_, __) => const ActivityListScreen(),
                routes: [
                  GoRoute(
                    path: 'filters',
                    name: RouteNames.activityFilters,
                    builder: (_, __) => const ActivityFiltersScreen(),
                  ),
                  GoRoute(
                    path: 'transaction/:id',
                    name: RouteNames.transactionDetail,
                    builder: (_, state) => TransactionDetailScreen(
                      id: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'export/period',
                    name: RouteNames.exportPeriod,
                    builder: (_, __) => const ExportPeriodScreen(),
                  ),
                  GoRoute(
                    path: 'export/confirm',
                    name: RouteNames.exportConfirm,
                    builder: (_, __) => const ExportConfirmScreen(),
                  ),
                  GoRoute(
                    path: 'export/success',
                    name: RouteNames.exportSuccess,
                    builder: (_, __) => const ExportSuccessScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Tab 4: More
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                name: RouteNames.moreHub,
                builder: (_, __) => const MoreHubScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: RouteNames.profile,
                    builder: (_, __) => const ProfileScreen(),
                  ),
                  GoRoute(
                    path: 'accounts',
                    name: RouteNames.connectedAccounts,
                    builder: (_, __) => const ConnectedAccountsScreen(),
                  ),
                  GoRoute(
                    path: 'accounts/connect',
                    name: RouteNames.connectAccount,
                    builder: (_, __) => const ConnectAccountScreen(),
                  ),
                  GoRoute(
                    path: 'security',
                    name: RouteNames.securitySettings,
                    builder: (_, __) => const SecuritySettingsScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    name: RouteNames.notificationSettings,
                    builder: (_, __) => const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'merchants',
                    name: RouteNames.pinnedMerchants,
                    builder: (_, __) => const PinnedMerchantsScreen(),
                  ),
                  GoRoute(
                    path: 'help',
                    name: RouteNames.helpSupport,
                    builder: (_, __) => const HelpSupportScreen(),
                  ),
                  GoRoute(
                    path: 'legal',
                    name: RouteNames.legalAbout,
                    builder: (_, __) => const LegalAboutScreen(),
                  ),

                  // Bulk import (sub-route of More → Connected Accounts)
                  GoRoute(
                    path: 'import/source',
                    name: RouteNames.importSource,
                    builder: (_, __) => const ImportSourceScreen(),
                  ),
                  GoRoute(
                    path: 'import/upload',
                    name: RouteNames.importUpload,
                    builder: (_, __) => const ImportUploadScreen(),
                  ),
                  GoRoute(
                    path: 'import/review',
                    name: RouteNames.importReview,
                    builder: (_, __) => const ImportReviewScreen(),
                  ),
                  GoRoute(
                    path: 'import/progress/:jobId',
                    name: RouteNames.importProgress,
                    builder: (_, state) => ImportProgressScreen(
                      jobId: state.pathParameters['jobId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'import/result/:jobId',
                    name: RouteNames.importResult,
                    builder: (_, state) => ImportResultScreen(
                      jobId: state.pathParameters['jobId']!,
                    ),
                  ),

                  // KYC flow
                  GoRoute(
                    path: 'kyc',
                    name: RouteNames.kycEntry,
                    builder: (_, __) => const KycEntryScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/account-type',
                    name: RouteNames.kycAccountType,
                    builder: (_, __) => const KycAccountTypeScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/checklist',
                    name: RouteNames.kycChecklist,
                    builder: (_, __) => const KycChecklistScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/id-front',
                    name: RouteNames.kycIdFront,
                    builder: (_, __) => const KycCaptureIdFrontScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/id-back',
                    name: RouteNames.kycIdBack,
                    builder: (_, __) => const KycCaptureIdBackScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/selfie',
                    name: RouteNames.kycSelfie,
                    builder: (_, __) => const KycSelfieScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/review',
                    name: RouteNames.kycReview,
                    builder: (_, __) => const KycReviewScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/pending',
                    name: RouteNames.kycPending,
                    builder: (_, __) => const KycPendingScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/approved',
                    name: RouteNames.kycApproved,
                    builder: (_, __) => const KycApprovedScreen(),
                  ),
                  GoRoute(
                    path: 'kyc/failed',
                    name: RouteNames.kycFailed,
                    builder: (_, __) => const KycFailedScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
```

### 4.2 Route Name Constants

```dart
// lib/core/router/route_names.dart
abstract final class RouteNames {
  // Pre-auth
  static const splash          = 'splash';
  static const onboarding      = 'onboarding';
  static const login           = 'login';
  static const otp             = 'otp';
  static const createPin       = 'create-pin';
  static const permissions     = 'permissions';

  // Home
  static const home            = 'home';
  static const dashboard       = 'dashboard';
  static const attentionList   = 'attention-list';
  static const insightDetail   = 'insight-detail';

  // Pay
  static const payHub          = 'pay-hub';
  static const sendRecipient   = 'send-recipient';
  static const sendDetails     = 'send-details';
  static const sendAmount      = 'send-amount';
  static const sendConfirm     = 'send-confirm';
  static const sendReceipt     = 'send-receipt';
  static const sendFailed      = 'send-failed';
  static const requestCreate   = 'request-create';
  static const requestShare    = 'request-share';
  static const requestStatus   = 'request-status';
  static const scan            = 'scan';
  static const scanManual      = 'scan-manual';
  static const scanConfirm     = 'scan-confirm';
  static const scanReceipt     = 'scan-receipt';
  static const businessCategory = 'business-category';
  static const businessPayee   = 'business-payee';
  static const businessConfirm = 'business-confirm';
  static const businessReceipt = 'business-receipt';
  static const topupSource     = 'topup-source';
  static const topupAmount     = 'topup-amount';
  static const topupConfirm    = 'topup-confirm';
  static const topupReceipt    = 'topup-receipt';

  // Pensions
  static const pensionHub       = 'pension-hub';
  static const pensionContribute = 'pension-contribute';
  static const pensionConfirm   = 'pension-confirm';
  static const pensionReceipt   = 'pension-receipt';
  static const pensionHistory   = 'pension-history';

  // Pia
  static const piaFeed         = 'pia-feed';
  static const piaEmpty        = 'pia-empty';
  static const piaCardDetail   = 'pia-card-detail';
  static const piaPinned       = 'pia-pinned';

  // Activity
  static const activityList    = 'activity-list';
  static const activityFilters = 'activity-filters';
  static const transactionDetail = 'transaction-detail';
  static const exportPeriod    = 'export-period';
  static const exportConfirm   = 'export-confirm';
  static const exportSuccess   = 'export-success';

  // More
  static const moreHub         = 'more-hub';
  static const profile         = 'profile';
  static const connectedAccounts = 'connected-accounts';
  static const connectAccount  = 'connect-account';
  static const securitySettings = 'security-settings';
  static const notificationSettings = 'notification-settings';
  static const pinnedMerchants = 'pinned-merchants';
  static const helpSupport     = 'help-support';
  static const legalAbout      = 'legal-about';

  // Import
  static const importSource    = 'import-source';
  static const importUpload    = 'import-upload';
  static const importReview    = 'import-review';
  static const importProgress  = 'import-progress';
  static const importResult    = 'import-result';

  // KYC
  static const kycEntry        = 'kyc-entry';
  static const kycAccountType  = 'kyc-account-type';
  static const kycChecklist    = 'kyc-checklist';
  static const kycIdFront      = 'kyc-id-front';
  static const kycIdBack       = 'kyc-id-back';
  static const kycSelfie       = 'kyc-selfie';
  static const kycReview       = 'kyc-review';
  static const kycPending      = 'kyc-pending';
  static const kycApproved     = 'kyc-approved';
  static const kycFailed       = 'kyc-failed';
}
```

### 4.3 Route Guards

**Auth Guard:** Redirects unauthenticated users to `/login`. Allows `/`, `/onboarding`, `/login`, `/otp`, `/create-pin`, `/permissions` without auth.

```dart
// lib/core/router/guards/auth_guard.dart
String? authGuard(AuthState authState, GoRouterState state) {
  final publicPaths = {'/', '/onboarding', '/login', '/otp', '/create-pin', '/permissions'};
  final isPublic = publicPaths.contains(state.matchedLocation);

  if (!authState.isAuthenticated && !isPublic) return '/login';
  if (authState.isAuthenticated && isPublic && state.matchedLocation != '/') return '/home';
  return null;
}
```

**KYC Guard:** Blocks access to payment flows if KYC status is not `approved`. Redirects to `/more/kyc` with a `returnTo` query parameter.

```dart
// lib/core/router/guards/kyc_guard.dart
String? kycGuard(KycStatus status, GoRouterState state) {
  if (status != KycStatus.approved) {
    return '/more/kyc?returnTo=${Uri.encodeComponent(state.matchedLocation)}';
  }
  return null;
}
```

**Step-up Guard:** For payment confirmations and other risky actions. Triggers PIN/biometric re-verification modal. Implemented as a redirect that checks `lastVerifiedAt` timestamp.

```dart
// lib/core/router/guards/step_up_guard.dart
String? stepUpGuard(Ref ref, GoRouterState state) {
  final lastVerified = ref.read(lastVerifiedAtProvider);
  final now = DateTime.now();
  // Require re-verification if last check was more than 5 minutes ago
  if (lastVerified == null || now.difference(lastVerified).inMinutes > 5) {
    return '/verify-pin?returnTo=${Uri.encodeComponent(state.matchedLocation)}';
  }
  return null;
}
```

### 4.4 Deep Linking for Push Notifications

| Notification Type | Deep Link | Target Screen |
|---|---|---|
| Payment received | `tisini://activity/transaction/{txId}` | Transaction detail |
| Pia card ready | `tisini://pia/card/{cardId}` | Pia card detail |
| Pension reminder | `tisini://pay/pensions` | Pension hub |
| KYC status update | `tisini://more/kyc/{status}` | KYC status screen |
| Import complete | `tisini://more/import/result/{jobId}` | Import result |
| Payment request | `tisini://pay/request/status/{reqId}` | Request status |

### 4.5 Tab State Preservation

Using `StatefulShellRoute.indexedStack` ensures each tab preserves its navigation stack. When switching between tabs:
- Scroll position is maintained
- Sub-navigation state is preserved
- No rebuild occurs when returning to a tab
- Back button pops within the current tab, does not switch tabs

---

## 5. State Management Architecture

### 5.1 Three-Tier Riverpod Provider Pattern

```
┌─────────────────────────────────────────────┐
│  Presentation Layer                         │
│  ┌───────────────────────────┐              │
│  │  Controller (StateNotifier│AsyncNotifier) │
│  │  - Orchestrates UI logic  │              │
│  │  - Calls repository       │              │
│  │  - Manages screen state   │              │
│  └──────────┬────────────────┘              │
├─────────────┼───────────────────────────────┤
│  Domain Layer │                              │
│  ┌──────────▼────────────────┐              │
│  │  Repository (abstract)     │              │
│  │  - Defines contract        │              │
│  └──────────┬────────────────┘              │
├─────────────┼───────────────────────────────┤
│  Data Layer  │                              │
│  ┌──────────▼────────────────┐              │
│  │  Repository (impl)        │              │
│  │  - Combines datasources   │              │
│  │  - Maps models ↔ entities │              │
│  └──────────┬────────────────┘              │
│  ┌──────────▼────────────────┐              │
│  │  DataSource (Remote/Local) │              │
│  │  - Dio calls / DB queries │              │
│  └───────────────────────────┘              │
└─────────────────────────────────────────────┘
```

### 5.2 Global Providers (Never Auto-Disposed)

| Provider | Type | Purpose |
|---|---|---|
| `dioProvider` | `Provider<Dio>` | Configured Dio instance |
| `databaseProvider` | `Provider<AppDatabase>` | Drift database singleton |
| `secureStorageProvider` | `Provider<SecureStorage>` | Encrypted storage wrapper |
| `authStateProvider` | `StateNotifierProvider<AuthStateNotifier, AuthState>` | Auth status, tokens, user ID |
| `connectivityProvider` | `StreamProvider<ConnectivityStatus>` | Online/offline state |
| `userProvider` | `AsyncNotifierProvider<UserNotifier, User?>` | Current user profile |
| `kycStatusProvider` | `AsyncNotifierProvider<KycStatusNotifier, KycStatus>` | KYC approval state |
| `lastVerifiedAtProvider` | `StateProvider<DateTime?>` | Step-up verification timestamp |
| `featureFlagsProvider` | `Provider<FeatureFlags>` | Feature toggle state |

### 5.3 Feature-Scoped Providers (autoDispose)

All feature-scoped providers use `autoDispose` so they clean up when the screen is dismissed.

#### Home & Dashboard

| Provider | Type | Purpose |
|---|---|---|
| `tisiniIndexProvider` | `AutoDisposeFutureProvider<TisiniIndex>` | Fetches tisini index (0-90) + sub-scores |
| `dashboardIndicatorsProvider` | `AutoDisposeFutureProvider<List<DashboardIndicator>>` | 4 bar indicators |
| `badgesProvider` | `AutoDisposeFutureProvider<List<Badge>>` | Achievement badges |
| `attentionItemsProvider` | `AutoDisposeFutureProvider<List<AttentionItem>>` | "What needs attention" list |
| `insightDetailProvider` | `AutoDisposeFutureProviderFamily<AttentionItem, String>` | Single insight by ID |
| `piaGuidanceProvider` | `AutoDisposeFutureProvider<PiaCard?>` | Home screen Pia snippet |

#### Pay

| Provider | Type | Purpose |
|---|---|---|
| `payHubProvider` | `AutoDisposeFutureProvider<PayHubData>` | Recent payees, categories |
| `sendControllerProvider` | `AutoDisposeAsyncNotifierProvider<SendController, SendState>` | Send flow state machine |
| `requestControllerProvider` | `AutoDisposeAsyncNotifierProvider<RequestController, RequestState>` | Request flow state |
| `scanControllerProvider` | `AutoDisposeAsyncNotifierProvider<ScanController, ScanState>` | Scan/pay flow state |
| `businessPayControllerProvider` | `AutoDisposeAsyncNotifierProvider<BusinessPayController, BusinessPayState>` | Business payment state |
| `topupControllerProvider` | `AutoDisposeAsyncNotifierProvider<TopupController, TopupState>` | Top up flow state |
| `payeeSearchProvider` | `AutoDisposeFutureProviderFamily<List<Payee>, String>` | Debounced payee search |
| `paymentRoutesProvider` | `AutoDisposeFutureProvider<List<PaymentRoute>>` | Available payment rails |
| `recentPayeesProvider` | `AutoDisposeFutureProvider<List<Payee>>` | Recent payees list |

#### Pensions

| Provider | Type | Purpose |
|---|---|---|
| `pensionStatusProvider` | `AutoDisposeFutureProvider<PensionStatus>` | NSSF link status, next due |
| `pensionContributeControllerProvider` | `AutoDisposeAsyncNotifierProvider<PensionContributeController, PensionContributeState>` | Contribution flow |
| `pensionHistoryProvider` | `AutoDisposeFutureProvider<List<PensionContribution>>` | Contribution history |
| `pensionRemindersProvider` | `AutoDisposeFutureProvider<List<PensionReminder>>` | Active reminders |

#### Pia

| Provider | Type | Purpose |
|---|---|---|
| `piaFeedProvider` | `AutoDisposeFutureProvider<List<PiaCard>>` | Pia card feed |
| `piaCardDetailProvider` | `AutoDisposeFutureProviderFamily<PiaCard, String>` | Single card by ID |
| `piaActionControllerProvider` | `AutoDisposeAsyncNotifierProvider<PiaActionController, PiaActionState>` | Execute Pia action |
| `piaPinnedProvider` | `AutoDisposeFutureProvider<List<PiaCard>>` | Pinned/saved cards |

#### Activity

| Provider | Type | Purpose |
|---|---|---|
| `transactionListProvider` | `AutoDisposeAsyncNotifierProvider<TransactionListNotifier, PaginatedList<Transaction>>` | Paginated transactions |
| `transactionFiltersProvider` | `AutoDisposeStateProvider<TransactionFilters>` | Active filter state |
| `transactionDetailProvider` | `AutoDisposeFutureProviderFamily<Transaction, String>` | Single transaction by ID |
| `updateCategoryProvider` | `AutoDisposeFutureProviderFamily<void, UpdateCategoryParams>` | Edit transaction category |
| `pinMerchantProvider` | `AutoDisposeFutureProviderFamily<void, PinMerchantParams>` | Pin merchant with role |
| `exportControllerProvider` | `AutoDisposeAsyncNotifierProvider<ExportController, ExportState>` | Export flow state |

#### More & Settings

| Provider | Type | Purpose |
|---|---|---|
| `profileProvider` | `AutoDisposeFutureProvider<UserProfile>` | User profile data |
| `connectedAccountsProvider` | `AutoDisposeFutureProvider<List<ConnectedAccount>>` | Linked accounts |
| `securitySettingsProvider` | `AutoDisposeFutureProvider<SecuritySettings>` | Security config |
| `notificationSettingsProvider` | `AutoDisposeFutureProvider<NotificationSettings>` | Notification preferences |
| `pinnedMerchantsProvider` | `AutoDisposeFutureProvider<List<PinnedMerchant>>` | Pinned merchants with roles |
| `updateMerchantRoleProvider` | `AutoDisposeFutureProviderFamily<void, UpdateRoleParams>` | Edit merchant role |

#### Bulk Import

| Provider | Type | Purpose |
|---|---|---|
| `importControllerProvider` | `AutoDisposeAsyncNotifierProvider<ImportController, ImportState>` | Full import flow |
| `importMappingProvider` | `AutoDisposeStateProvider<ImportMapping?>` | Column mapping state |
| `importJobStatusProvider` | `AutoDisposeStreamProviderFamily<ImportJob, String>` | Poll job progress |

#### KYC

| Provider | Type | Purpose |
|---|---|---|
| `kycFlowProvider` | `AutoDisposeAsyncNotifierProvider<KycFlowNotifier, KycFlowState>` | KYC submission flow |
| `kycCaptureControllerProvider` | `AutoDisposeAsyncNotifierProvider<KycCaptureController, KycCaptureState>` | Camera capture state |
| `kycSubmissionStatusProvider` | `AutoDisposeStreamProviderFamily<KycSubmission, String>` | Poll submission status |

#### Auth

| Provider | Type | Purpose |
|---|---|---|
| `loginControllerProvider` | `AutoDisposeAsyncNotifierProvider<LoginController, LoginState>` | Phone → OTP flow |
| `pinControllerProvider` | `AutoDisposeAsyncNotifierProvider<PinController, PinState>` | PIN creation/verification |
| `biometricAvailableProvider` | `AutoDisposeFutureProvider<bool>` | Check biometric support |

---

## 6. Data Models

All entities use `freezed` for immutable data classes with `copyWith`, `==`, and `toString`. Data models (in `data/models/`) extend entities with `fromJson`/`toJson` via `json_serializable`.

### 6.1 Enums

```dart
// --- Payment ---

enum PaymentRail { bank, mobileMoney, card, wallet }
// Note: "wallet" is tisini wallet; stablecoin deferred to Phase 2

enum PaymentStatus { pending, processing, completed, failed, reversed }

enum PaymentType { send, request, scanPay, businessPay, topUp, pensionContribution }

enum TransactionDirection { inbound, outbound }

// --- Business / Categorisation ---

enum TransactionCategory { sales, inventory, bills, people, compliance, agency, uncategorised }

enum MerchantRole { supplier, rent, wages, tax, pension, utilities }

// --- Pia ---

enum PiaActionType { setReminder, schedulePayment, prepareExport, askUserConfirmation, markAsPinned }

enum PiaCardPriority { high, medium, low }

enum PiaCardStatus { active, dismissed, actioned, expired }

// --- KYC ---

enum KycStatus { notStarted, inProgress, pending, approved, failed }

enum KycAccountType { business, gig }

enum KycDocumentType { idFront, idBack, selfie, businessRegistration, licence, tin }

// --- Pension ---

enum PensionLinkStatus { linked, notLinked, verifying }

enum ContributionStatus { pending, completed, failed }

// --- Import ---

enum ImportSource { bank, mobileMoney }

enum ImportJobStatus { uploading, mapping, processing, completed, failed }

// --- Auth ---

enum AuthStatus { unauthenticated, otpSent, pinRequired, authenticated }

// --- Dashboard ---

enum IndicatorType { paymentConsistency, complianceReadiness, businessMomentum, dataCompleteness }

// --- Connectivity ---

enum ConnectivityStatus { online, offline }
```

### 6.2 Core Entities

```dart
// --- User ---
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String phoneNumber,
    required String? fullName,
    required String? businessName,
    required KycStatus kycStatus,
    required DateTime createdAt,
  }) = _User;
}

// --- AuthToken ---
@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthToken;
}

// --- Payee ---
@freezed
class Payee with _$Payee {
  const factory Payee({
    required String id,
    required String name,
    required String identifier,        // phone, account number, till
    required PaymentRail rail,
    required String? avatarUrl,
    required MerchantRole? role,       // if pinned
    required bool isPinned,
    required DateTime? lastPaidAt,
  }) = _Payee;
}

// --- Payment ---
@freezed
class Payment with _$Payment {
  const factory Payment({
    required String id,
    required PaymentType type,
    required PaymentStatus status,
    required TransactionDirection direction,
    required double amount,
    required String currency,          // "UGX", "KES", etc.
    required PaymentRail rail,
    required Payee payee,
    required String? reference,
    required double fee,
    required double total,             // amount + fee
    required TransactionCategory category,
    required String? note,
    required DateTime createdAt,
    required DateTime? completedAt,
  }) = _Payment;
}

// --- PaymentReceipt ---
@freezed
class PaymentReceipt with _$PaymentReceipt {
  const factory PaymentReceipt({
    required String transactionId,
    required String receiptNumber,
    required PaymentType type,
    required PaymentStatus status,
    required double amount,
    required String currency,
    required double fee,
    required double total,
    required PaymentRail rail,
    required String payeeName,
    required String payeeIdentifier,
    required String? reference,
    required DateTime timestamp,
  }) = _PaymentReceipt;
}

// --- PaymentRoute ---
@freezed
class PaymentRoute with _$PaymentRoute {
  const factory PaymentRoute({
    required PaymentRail rail,
    required String label,             // "Bank Transfer", "Mobile Money", etc.
    required bool isAvailable,
    required double? fee,
    required String? estimatedTime,    // "Instant", "1-2 hours"
  }) = _PaymentRoute;
}

// --- PaymentRequest ---
@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String id,
    required double amount,
    required String currency,
    required String? note,
    required String shareLink,
    required PaymentStatus status,
    required DateTime createdAt,
    required DateTime? paidAt,
  }) = _PaymentRequest;
}

// --- TopUp ---
@freezed
class TopUp with _$TopUp {
  const factory TopUp({
    required String id,
    required double amount,
    required String currency,
    required PaymentRail sourceRail,
    required String sourceIdentifier,
    required PaymentStatus status,
    required DateTime createdAt,
  }) = _TopUp;
}

// --- TisiniIndex ---
@freezed
class TisiniIndex with _$TisiniIndex {
  const factory TisiniIndex({
    required int score,                // 0-90
    required int paymentConsistency,   // 0-30
    required int complianceReadiness,  // 0-30
    required int businessMomentum,     // 0-15
    required int dataCompleteness,     // 0-15
    required String? changeReason,     // "Up +3: pension reminder set"
    required int? changeAmount,        // +3 or -2
    required DateTime updatedAt,
  }) = _TisiniIndex;
}

// --- DashboardIndicator ---
@freezed
class DashboardIndicator with _$DashboardIndicator {
  const factory DashboardIndicator({
    required IndicatorType type,
    required String label,
    required int value,                // Current score
    required int maxValue,             // Max possible
    required double percentage,
  }) = _DashboardIndicator;
}

// --- AttentionItem ---
@freezed
class AttentionItem with _$AttentionItem {
  const factory AttentionItem({
    required String id,
    required String title,
    required String description,
    required String? actionLabel,
    required String? actionRoute,
    required PiaCardPriority priority,
    required DateTime createdAt,
  }) = _AttentionItem;
}

// --- Badge ---
@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String label,
    required String iconName,
    required bool isEarned,
    required DateTime? earnedAt,
  }) = _Badge;
}

// --- PensionStatus ---
@freezed
class PensionStatus with _$PensionStatus {
  const factory PensionStatus({
    required PensionLinkStatus linkStatus,
    required String? nssfNumber,
    required DateTime? nextDueDate,
    required double? nextDueAmount,
    required String currency,
    required int totalContributions,
    required double totalAmount,
    required List<PensionReminder> activeReminders,
  }) = _PensionStatus;
}

// --- PensionContribution ---
@freezed
class PensionContribution with _$PensionContribution {
  const factory PensionContribution({
    required String id,
    required double amount,
    required String currency,
    required ContributionStatus status,
    required String? reference,
    required PaymentRail rail,
    required DateTime createdAt,
    required DateTime? completedAt,
  }) = _PensionContribution;
}

// --- PensionReminder ---
@freezed
class PensionReminder with _$PensionReminder {
  const factory PensionReminder({
    required String id,
    required DateTime reminderDate,
    required double? amount,
    required bool isActive,
  }) = _PensionReminder;
}

// --- PiaCard ---
@freezed
class PiaCard with _$PiaCard {
  const factory PiaCard({
    required String id,
    required String title,
    required String what,              // 1 sentence
    required String why,               // 1 sentence
    required String? details,          // very short
    required List<PiaAction> actions,
    required PiaCardPriority priority,
    required PiaCardStatus status,
    required bool isPinned,
    required DateTime createdAt,
  }) = _PiaCard;
}

// --- PiaAction ---
@freezed
class PiaAction with _$PiaAction {
  const factory PiaAction({
    required String id,
    required PiaActionType type,
    required String label,             // "Set reminder", "Schedule payment"
    required Map<String, dynamic>? params, // Action-specific data
  }) = _PiaAction;
}

// --- Transaction (Activity list item) ---
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required PaymentType type,
    required TransactionDirection direction,
    required PaymentStatus status,
    required double amount,
    required String currency,
    required String counterpartyName,
    required String counterpartyIdentifier,
    required TransactionCategory category,
    required MerchantRole? merchantRole,
    required String? note,
    required PaymentRail rail,
    required double fee,
    required DateTime createdAt,
  }) = _Transaction;
}

// --- ExportJob ---
@freezed
class ExportJob with _$ExportJob {
  const factory ExportJob({
    required String id,
    required DateTime startDate,
    required DateTime endDate,
    required String? downloadUrl,
    required PaymentStatus status,
    required DateTime createdAt,
  }) = _ExportJob;
}

// --- ConnectedAccount ---
@freezed
class ConnectedAccount with _$ConnectedAccount {
  const factory ConnectedAccount({
    required String id,
    required String providerName,
    required String accountIdentifier,
    required ImportSource type,
    required DateTime connectedAt,
  }) = _ConnectedAccount;
}

// --- PinnedMerchant ---
@freezed
class PinnedMerchant with _$PinnedMerchant {
  const factory PinnedMerchant({
    required String id,
    required String name,
    required String identifier,
    required MerchantRole role,
    required DateTime pinnedAt,
  }) = _PinnedMerchant;
}

// --- ImportJob ---
@freezed
class ImportJob with _$ImportJob {
  const factory ImportJob({
    required String id,
    required ImportSource source,
    required ImportJobStatus status,
    required int totalRows,
    required int processedRows,
    required int successRows,
    required int errorRows,
    required DateTime createdAt,
    required DateTime? completedAt,
  }) = _ImportJob;
}

// --- ImportMapping ---
@freezed
class ImportMapping with _$ImportMapping {
  const factory ImportMapping({
    required String dateColumn,
    required String amountColumn,
    required String merchantColumn,
    required String? referenceColumn,
  }) = _ImportMapping;
}

// --- ImportResult ---
@freezed
class ImportResult with _$ImportResult {
  const factory ImportResult({
    required String jobId,
    required int totalImported,
    required int categorised,
    required int uncategorised,
    required List<String> errors,
  }) = _ImportResult;
}

// --- KycSubmission ---
@freezed
class KycSubmission with _$KycSubmission {
  const factory KycSubmission({
    required String id,
    required KycAccountType accountType,
    required KycStatus status,
    required List<KycDocument> documents,
    required String? rejectionReason,
    required DateTime submittedAt,
    required DateTime? reviewedAt,
  }) = _KycSubmission;
}

// --- KycDocument ---
@freezed
class KycDocument with _$KycDocument {
  const factory KycDocument({
    required String id,
    required KycDocumentType type,
    required String filePath,
    required bool isUploaded,
  }) = _KycDocument;
}

// --- UserProfile ---
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String phoneNumber,
    required String? fullName,
    required String? businessName,
    required String? email,
    required KycStatus kycStatus,
    required KycAccountType? accountType,
  }) = _UserProfile;
}

// --- SecuritySettings ---
@freezed
class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    required bool pinEnabled,
    required bool biometricEnabled,
    required bool twoStepEnabled,
    required List<String> trustedDevices,
  }) = _SecuritySettings;
}

// --- NotificationSettings ---
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    required bool paymentReceived,
    required bool piaCards,
    required bool pensionReminders,
    required bool promotions,
  }) = _NotificationSettings;
}

// --- Paginated list wrapper ---
@freezed
class PaginatedList<T> with _$PaginatedList<T> {
  const factory PaginatedList({
    required List<T> items,
    required String? nextCursor,
    required bool hasMore,
  }) = _PaginatedList<T>;
}

// --- Feature Flags ---
@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    @Default(false) bool stablecoinRails,
    @Default(false) bool pockets,
    @Default(true)  bool bulkImport,
    @Default(true)  bool piaCards,
    @Default(true)  bool pensionIntegration,
  }) = _FeatureFlags;
}
```

---

## 7. API Contract Definitions

### 7.1 Conventions

| Convention | Value |
|---|---|
| Base URL | `https://api.tisini.co/v1` |
| Auth header | `Authorization: Bearer {access_token}` |
| Content type | `application/json` |
| Pagination | Cursor-based: `?cursor={cursor}&limit={limit}` (default limit: 20, max: 50) |
| Date format | ISO 8601: `2026-02-18T10:30:00Z` |
| Currency amounts | Integer cents (e.g., `500000` = UGX 5,000) — avoid float precision issues |
| Error format | `{ "error": { "code": "PAYMENT_FAILED", "message": "...", "details": {} } }` |
| Rate limits | 60 requests/minute per user, 429 response with `Retry-After` header |

### 7.2 Error Code Catalog

| Code | HTTP | Description |
|---|---|---|
| `AUTH_EXPIRED` | 401 | Access token expired |
| `AUTH_INVALID` | 401 | Invalid token |
| `AUTH_REFRESH_FAILED` | 401 | Refresh token expired — force re-login |
| `OTP_INVALID` | 400 | Incorrect OTP code |
| `OTP_EXPIRED` | 400 | OTP has expired |
| `OTP_RATE_LIMITED` | 429 | Too many OTP requests |
| `PIN_INVALID` | 400 | Incorrect PIN |
| `PIN_LOCKED` | 423 | Too many failed PIN attempts |
| `PAYMENT_FAILED` | 400 | Payment could not be processed |
| `PAYMENT_DUPLICATE` | 409 | Duplicate payment detected |
| `INSUFFICIENT_BALANCE` | 400 | Wallet balance too low |
| `PAYEE_NOT_FOUND` | 404 | Payee not found |
| `KYC_REQUIRED` | 403 | KYC not approved — action blocked |
| `KYC_ALREADY_SUBMITTED` | 409 | KYC already in review |
| `IMPORT_INVALID_FORMAT` | 400 | CSV format not recognized |
| `IMPORT_TOO_LARGE` | 413 | File exceeds max size (5MB) |
| `PENSION_NOT_LINKED` | 400 | NSSF account not linked |
| `RATE_LIMITED` | 429 | Too many requests |
| `SERVER_ERROR` | 500 | Internal server error |
| `SERVICE_UNAVAILABLE` | 503 | Downstream service unavailable |
| `VALIDATION_ERROR` | 422 | Request body validation failed |

### 7.3 Endpoints by Domain

#### Auth (4 endpoints)

**POST /auth/otp/request**
```json
// Request
{ "phone_number": "+256700123456" }

// Response 200
{ "data": { "otp_id": "otp_abc123", "expires_in": 300 } }
```

**POST /auth/otp/verify**
```json
// Request
{ "otp_id": "otp_abc123", "code": "123456" }

// Response 200
{
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_at": "2026-02-18T11:30:00Z",
    "user": {
      "id": "usr_001",
      "phone_number": "+256700123456",
      "full_name": null,
      "business_name": null,
      "kyc_status": "not_started",
      "created_at": "2026-02-18T10:30:00Z"
    },
    "is_new_user": true
  }
}
```

**POST /auth/pin/create**
```json
// Request
{ "pin": "1234" }

// Response 200
{ "data": { "pin_set": true } }
```

**POST /auth/token/refresh**
```json
// Request
{ "refresh_token": "eyJ..." }

// Response 200
{
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_at": "2026-02-18T11:30:00Z"
  }
}
```

#### Dashboard (3 endpoints)

**GET /dashboard**
```json
// Response 200
{
  "data": {
    "tisini_index": {
      "score": 62,
      "payment_consistency": 22,
      "compliance_readiness": 18,
      "business_momentum": 12,
      "data_completeness": 10,
      "change_reason": "Up +3: pension reminder set + supplier pinned",
      "change_amount": 3,
      "updated_at": "2026-02-18T10:00:00Z"
    },
    "badges": [
      { "id": "bdg_001", "label": "First Payment", "icon_name": "rocket", "is_earned": true, "earned_at": "2026-02-10T08:00:00Z" },
      { "id": "bdg_002", "label": "KYC Verified", "icon_name": "shield_check", "is_earned": true, "earned_at": "2026-02-12T14:00:00Z" },
      { "id": "bdg_003", "label": "Pension Active", "icon_name": "heart", "is_earned": false, "earned_at": null }
    ],
    "pia_guidance": {
      "id": "pia_g01",
      "title": "Pension due soon",
      "what": "Your NSSF contribution is due in 5 days.",
      "why": "Staying current keeps your compliance readiness score up.",
      "details": "UGX 50,000 due Feb 23",
      "actions": [{ "id": "act_01", "type": "schedule_payment", "label": "Schedule payment" }],
      "priority": "high"
    }
  }
}
```

**GET /dashboard/attention**
```json
// Response 200
{
  "data": {
    "items": [
      {
        "id": "att_001",
        "title": "3 uncategorised transactions",
        "description": "Categorise these to improve your business picture.",
        "action_label": "Review",
        "action_route": "/activity?filter=uncategorised",
        "priority": "medium",
        "created_at": "2026-02-18T09:00:00Z"
      }
    ]
  }
}
```

**GET /dashboard/insight/:id**
```json
// Response 200
{
  "data": {
    "id": "att_001",
    "title": "3 uncategorised transactions",
    "description": "Categorise these to improve your business picture.",
    "action_label": "Review",
    "action_route": "/activity?filter=uncategorised",
    "priority": "medium",
    "created_at": "2026-02-18T09:00:00Z"
  }
}
```

#### Payments (8 endpoints)

**GET /payees?q={search}&limit={limit}**
```json
// Response 200
{
  "data": {
    "items": [
      {
        "id": "pye_001",
        "name": "Kampala Supplies Ltd",
        "identifier": "+256700555123",
        "rail": "mobile_money",
        "avatar_url": null,
        "role": "supplier",
        "is_pinned": true,
        "last_paid_at": "2026-02-15T14:30:00Z"
      }
    ]
  }
}
```

**GET /payees/recent?limit=5**
```json
// Response 200 — same schema as payees search
```

**GET /payment-routes**
```json
// Response 200
{
  "data": {
    "routes": [
      { "rail": "bank", "label": "Bank Transfer", "is_available": true, "fee": 0, "estimated_time": "1-2 hours" },
      { "rail": "mobile_money", "label": "Mobile Money", "is_available": true, "fee": 500, "estimated_time": "Instant" },
      { "rail": "card", "label": "Card Payment", "is_available": true, "fee": 1500, "estimated_time": "Instant" },
      { "rail": "wallet", "label": "tisini Wallet", "is_available": true, "fee": 0, "estimated_time": "Instant" }
    ]
  }
}
```

**POST /payments/send**
```json
// Request
{
  "payee_id": "pye_001",
  "amount": 500000,
  "currency": "UGX",
  "rail": "mobile_money",
  "category": "bills",
  "reference": "Feb rent",
  "note": "Monthly office rent"
}

// Response 201
{
  "data": {
    "id": "tx_001",
    "status": "processing",
    "amount": 500000,
    "currency": "UGX",
    "fee": 500,
    "total": 500500,
    "rail": "mobile_money",
    "payee": { "id": "pye_001", "name": "Kampala Supplies Ltd", "identifier": "+256700555123" },
    "reference": "Feb rent",
    "created_at": "2026-02-18T10:30:00Z"
  }
}
```

**POST /payments/request**
```json
// Request
{ "amount": 200000, "currency": "UGX", "note": "Invoice #INV-2026-042" }

// Response 201
{
  "data": {
    "id": "req_001",
    "amount": 200000,
    "currency": "UGX",
    "note": "Invoice #INV-2026-042",
    "share_link": "https://pay.tisini.co/r/req_001",
    "status": "pending",
    "created_at": "2026-02-18T10:30:00Z"
  }
}
```

**GET /payments/request/:id**
```json
// Response 200 — same as request creation response
```

**POST /payments/scan**
```json
// Request
{ "qr_data": "tisini://pay?to=pye_002&amount=150000&currency=UGX", "rail": "wallet" }

// Response 201 — same schema as send response
```

**GET /payments/receipt/:txId**
```json
// Response 200
{
  "data": {
    "transaction_id": "tx_001",
    "receipt_number": "RCP-2026-0218-001",
    "type": "send",
    "status": "completed",
    "amount": 500000,
    "currency": "UGX",
    "fee": 500,
    "total": 500500,
    "rail": "mobile_money",
    "payee_name": "Kampala Supplies Ltd",
    "payee_identifier": "+256700555123",
    "reference": "Feb rent",
    "timestamp": "2026-02-18T10:30:05Z"
  }
}
```

#### Business Payments (2 endpoints)

**GET /business-payees?category={suppliers|bills|wages|statutory}**
```json
// Response 200
{
  "data": {
    "items": [
      {
        "id": "pye_003",
        "name": "NWSC - Water",
        "identifier": "NWSC-ACC-12345",
        "rail": "bank",
        "role": "utilities",
        "is_pinned": true,
        "last_paid_at": "2026-01-18T10:00:00Z"
      }
    ]
  }
}
```

**POST /payments/business** — Same schema as `/payments/send`

#### Top Up (2 endpoints)

**GET /topup/sources**
```json
// Response 200
{
  "data": {
    "sources": [
      { "rail": "mobile_money", "label": "Mobile Money", "identifier": "+256700123456", "is_available": true },
      { "rail": "bank", "label": "Stanbic Bank ****4521", "identifier": "ACCT-4521", "is_available": true }
    ]
  }
}
```

**POST /topup**
```json
// Request
{ "amount": 1000000, "currency": "UGX", "source_rail": "mobile_money", "source_identifier": "+256700123456" }

// Response 201 — returns top-up transaction
```

#### Pensions (5 endpoints)

**GET /pensions/status**
```json
// Response 200
{
  "data": {
    "link_status": "linked",
    "nssf_number": "NSSF-UG-123456",
    "next_due_date": "2026-02-23T00:00:00Z",
    "next_due_amount": 5000000,
    "currency": "UGX",
    "total_contributions": 12,
    "total_amount": 60000000,
    "active_reminders": [
      { "id": "rem_001", "reminder_date": "2026-02-21T09:00:00Z", "amount": 5000000, "is_active": true }
    ]
  }
}
```

**POST /pensions/contribute**
```json
// Request
{ "amount": 5000000, "currency": "UGX", "rail": "mobile_money", "reference": "NSSF Feb 2026" }

// Response 201 — returns contribution transaction
```

**GET /pensions/contributions?cursor={cursor}&limit={limit}**
```json
// Response 200
{
  "data": {
    "items": [
      {
        "id": "pc_001",
        "amount": 5000000,
        "currency": "UGX",
        "status": "completed",
        "reference": "NSSF Jan 2026",
        "rail": "mobile_money",
        "created_at": "2026-01-18T10:00:00Z",
        "completed_at": "2026-01-18T10:00:05Z"
      }
    ],
    "next_cursor": "pc_000",
    "has_more": true
  }
}
```

**POST /pensions/link**
```json
// Request
{ "nssf_number": "NSSF-UG-123456" }

// Response 200
{ "data": { "link_status": "verifying" } }
```

**POST /pensions/reminders**
```json
// Request
{ "reminder_date": "2026-02-21T09:00:00Z", "amount": 5000000 }

// Response 201
{ "data": { "id": "rem_002", "reminder_date": "2026-02-21T09:00:00Z", "amount": 5000000, "is_active": true } }
```

#### Pia (4 endpoints)

**GET /pia/cards?cursor={cursor}&limit={limit}**
```json
// Response 200
{
  "data": {
    "items": [
      {
        "id": "pia_001",
        "title": "Pension due soon",
        "what": "Your NSSF contribution is due in 5 days.",
        "why": "Staying current keeps your compliance readiness up.",
        "details": "UGX 50,000 due Feb 23",
        "actions": [
          { "id": "act_01", "type": "schedule_payment", "label": "Schedule payment", "params": { "payee_id": "pye_nssf", "amount": 5000000 } }
        ],
        "priority": "high",
        "status": "active",
        "is_pinned": false,
        "created_at": "2026-02-18T06:00:00Z"
      },
      {
        "id": "pia_002",
        "title": "New supplier detected",
        "what": "You paid Mukwano Industries 3 times this month.",
        "why": "Pinning them helps tisini categorise future payments.",
        "details": "Total: UGX 1,500,000",
        "actions": [
          { "id": "act_02", "type": "mark_as_pinned", "label": "Pin as supplier", "params": { "payee_id": "pye_005", "role": "supplier" } }
        ],
        "priority": "medium",
        "status": "active",
        "is_pinned": false,
        "created_at": "2026-02-17T18:00:00Z"
      }
    ],
    "next_cursor": "pia_000",
    "has_more": false
  }
}
```

**GET /pia/cards/:id** — Single card detail (same schema as list item)

**POST /pia/cards/:id/action**
```json
// Request
{ "action_id": "act_01", "params": { "scheduled_date": "2026-02-22T09:00:00Z" } }

// Response 200
{ "data": { "success": true, "message": "Payment scheduled for Feb 22" } }
```

**PATCH /pia/cards/:id**
```json
// Request — dismiss or pin
{ "status": "dismissed" }
// or
{ "is_pinned": true }

// Response 200
{ "data": { "id": "pia_001", "status": "dismissed" } }
```

#### Transactions (4 endpoints)

**GET /transactions?cursor={cursor}&limit={limit}&category={cat}&direction={dir}&from={date}&to={date}**
```json
// Response 200 — paginated list of Transaction objects
```

**GET /transactions/:id** — Single transaction detail

**PATCH /transactions/:id/category**
```json
// Request
{ "category": "inventory" }

// Response 200
{ "data": { "id": "tx_001", "category": "inventory" } }
```

**POST /transactions/export**
```json
// Request
{ "start_date": "2026-01-01", "end_date": "2026-01-31", "format": "csv" }

// Response 202
{ "data": { "job_id": "exp_001", "status": "processing" } }
```

**GET /transactions/export/:jobId**
```json
// Response 200
{ "data": { "id": "exp_001", "status": "completed", "download_url": "https://..." } }
```

#### Merchants (3 endpoints)

**GET /merchants/pinned**
```json
// Response 200
{
  "data": {
    "items": [
      { "id": "pye_001", "name": "Kampala Supplies", "identifier": "+256700555123", "role": "supplier", "pinned_at": "2026-02-10T08:00:00Z" }
    ]
  }
}
```

**POST /merchants/pin**
```json
// Request
{ "payee_id": "pye_005", "role": "supplier" }

// Response 201
```

**DELETE /merchants/pin/:payeeId** — Unpin merchant

**PATCH /merchants/pin/:payeeId**
```json
// Request
{ "role": "rent" }

// Response 200
```

#### Import (4 endpoints)

**POST /import/upload** (multipart/form-data)
```
file: <CSV file>
source: "bank"
```
```json
// Response 201
{
  "data": {
    "job_id": "imp_001",
    "detected_columns": ["Date", "Description", "Amount", "Reference", "Balance"],
    "sample_rows": [
      ["2026-01-15", "MTN MoMo Transfer", "50000", "REF-001", "1500000"],
      ["2026-01-16", "Stanbic ATM", "-200000", "ATM-002", "1300000"]
    ]
  }
}
```

**POST /import/:jobId/mapping**
```json
// Request
{ "date_column": "Date", "amount_column": "Amount", "merchant_column": "Description", "reference_column": "Reference" }

// Response 200
{
  "data": {
    "job_id": "imp_001",
    "status": "processing",
    "total_rows": 142,
    "categorisation_preview": { "auto_categorised": 89, "uncategorised": 53 }
  }
}
```

**GET /import/:jobId/status**
```json
// Response 200
{
  "data": {
    "id": "imp_001",
    "source": "bank",
    "status": "completed",
    "total_rows": 142,
    "processed_rows": 142,
    "success_rows": 138,
    "error_rows": 4,
    "created_at": "2026-02-18T10:30:00Z",
    "completed_at": "2026-02-18T10:31:15Z"
  }
}
```

**GET /import/:jobId/result**
```json
// Response 200
{
  "data": {
    "job_id": "imp_001",
    "total_imported": 138,
    "categorised": 89,
    "uncategorised": 49,
    "errors": ["Row 15: invalid date format", "Row 42: missing amount"]
  }
}
```

#### KYC (3 endpoints)

**POST /kyc/submit** (multipart/form-data)
```
account_type: "business"
id_front: <image file>
id_back: <image file>
selfie: <image file>
business_registration: <image file> (optional)
```
```json
// Response 201
{ "data": { "submission_id": "kyc_001", "status": "pending" } }
```

**GET /kyc/status**
```json
// Response 200
{
  "data": {
    "id": "kyc_001",
    "account_type": "business",
    "status": "approved",
    "documents": [
      { "id": "doc_01", "type": "id_front", "is_uploaded": true },
      { "id": "doc_02", "type": "id_back", "is_uploaded": true },
      { "id": "doc_03", "type": "selfie", "is_uploaded": true }
    ],
    "rejection_reason": null,
    "submitted_at": "2026-02-15T10:00:00Z",
    "reviewed_at": "2026-02-16T14:00:00Z"
  }
}
```

**POST /kyc/retry** — Re-submit after failure (same as submit)

#### Settings (5 endpoints)

**GET /users/me** — Returns UserProfile
**PATCH /users/me** — Update profile fields
**GET /settings/security** — Returns SecuritySettings
**PATCH /settings/security** — Update security settings
**GET /settings/notifications** — Returns NotificationSettings
**PATCH /settings/notifications** — Update notification preferences

#### Wallet (2 endpoints)

**GET /wallet/balance**
```json
// Response 200
{ "data": { "balance": 2500000, "currency": "UGX" } }
```

**GET /wallet/accounts** — Returns connected accounts list

### 7.4 Endpoint Summary Count

| Domain | Count |
|---|---|
| Auth | 4 |
| Dashboard | 3 |
| Payments | 8 |
| Business Payments | 2 |
| Top Up | 2 |
| Pensions | 5 |
| Pia | 4 |
| Transactions | 5 |
| Merchants | 4 |
| Import | 4 |
| KYC | 3 |
| Settings | 6 |
| Wallet | 2 |
| **Total** | **52** |

---

## 8. Screen-by-Screen Specifications

> Each screen specifies: **purpose**, **route**, **file path**, **UI layout** (top to bottom), **state requirements**, **user interactions**, **navigation**, **error states**, and **placeholder copy keys**.

---

### 8.1 Launch Splash (2 screens)

#### Screen 1 — Splash (Light)

| Field | Value |
|---|---|
| **Purpose** | Brand impression + auth state check on app launch |
| **Route** | `/` |
| **File** | `features/splash/presentation/screens/splash_screen.dart` |

**UI Layout (top → bottom):**
1. Full screen `AppColors.white` background
2. Centered tisini logo mark (SVG asset, ~80x80)
3. Optional subtle Pia watermark (low opacity, background)
4. No text, no paragraphs, no clutter
5. Safe area insets respected for iOS/Android

**State:** Reads `authStateProvider`. On init: check for stored tokens → if valid, navigate to `/home`; if expired, attempt refresh; if no tokens, navigate to `/onboarding`.

**Interactions:** None (auto-transitions after 1.5-2s).

**Navigation:** `→ /home` (authenticated) | `→ /onboarding` (first launch) | `→ /login` (returning, expired)

**Error:** If token refresh fails silently, navigate to `/login`.

**Copy keys:** None (visual only).

#### Screen 2 — Splash (Dark)

Same as Screen 1 but with `AppColors.darkBlue` background and white logo variant. Selected based on system theme via `MediaQuery.platformBrightnessOf(context)`.

---

### 8.2 Onboarding + Auth (8 screens)

#### Screen 3–6 — Onboarding Carousel (4 pages)

| Field | Value |
|---|---|
| **Purpose** | Introduce tisini value props to new users (max 4 pages + skip) |
| **Route** | `/onboarding` |
| **File** | `features/onboarding/presentation/screens/onboarding_screen.dart` |

**UI Layout:**
1. **Top-right:** "Skip" text button
2. **Center:** Illustration area (70% graphics / 30% text). Mild animation allowed (pulse/ring/shimmer). No mascot/face.
3. **Bottom:** Dot indicator (4 dots)
4. **Bottom CTA:** "Continue" button (ElevatedButton, full width)

**Pages:**
- Page 1: Payments — "Send and receive payments instantly"
- Page 2: Business picture — "See how your business is doing each day"
- Page 3: Pia — "Know how your business is doing each day. Pia notices patterns, tells you what is due, and shows you the next step."
- Page 4: Pension — "Stay on top of pension and compliance"

**State:** `onboardingProvider` — tracks current page index, stores `hasSeenOnboarding` flag in SharedPreferences.

**Interactions:** Swipe pages, tap dots, tap "Skip" (→ login), tap "Continue" on last page (→ login).

**Navigation:** `→ /login` (skip or complete)

**Copy keys:** `onboarding.page1.title`, `onboarding.page1.body`, etc. (copy provided by tisini)

#### Screen 7 — Login

| Field | Value |
|---|---|
| **Purpose** | Phone number entry for OTP login |
| **Route** | `/login` |
| **File** | `features/auth/presentation/screens/login_screen.dart` |

**UI Layout:**
1. **AppBar:** tisini logo centered, no back button
2. **Headline:** "Enter your phone number" (`headlineMedium`)
3. **Subtext:** "We'll send you a code to verify" (`bodyMedium`, grey)
4. **Phone input:** Country picker (+256 default) + phone number field
5. **CTA:** "Continue" button — disabled until valid phone entered

**State:** `loginControllerProvider` — validates phone format, calls `POST /auth/otp/request`.

**Interactions:** Enter phone → tap Continue → loading state on button → navigate to OTP.

**Navigation:** `→ /otp`

**Error states:**
- `OTP_RATE_LIMITED` → inline error: "Too many attempts. Try again in X minutes."
- Network error → inline error: "Check your connection and try again."

**Copy keys:** `login.title`, `login.subtitle`, `login.cta`, `login.error.rate_limited`

#### Screen 8 — OTP

| Field | Value |
|---|---|
| **Purpose** | OTP code entry and verification |
| **Route** | `/otp` |
| **File** | `features/auth/presentation/screens/otp_screen.dart` |

**UI Layout:**
1. **AppBar:** Back arrow
2. **Headline:** "Enter verification code" (`headlineMedium`)
3. **Subtext:** "Sent to +256 700 123 456" (`bodyMedium`, grey) — masked phone
4. **OTP input:** 6 individual digit boxes, auto-focus first, auto-advance
5. **Resend link:** "Resend code" text button — countdown timer (60s)
6. **CTA:** Auto-submit on 6th digit, or manual "Verify" button

**State:** `loginControllerProvider` — calls `POST /auth/otp/verify`, handles response.

**Interactions:** Type 6 digits → auto-verify → if `is_new_user`, go to create PIN; otherwise go home. Tap "Resend" after countdown.

**Navigation:** `→ /create-pin` (new user) | `→ /home` (returning user with PIN)

**Error states:**
- `OTP_INVALID` → shake animation + inline error: "Incorrect code. Try again."
- `OTP_EXPIRED` → inline error: "Code expired. Tap resend for a new one."

**Copy keys:** `otp.title`, `otp.subtitle`, `otp.resend`, `otp.error.invalid`, `otp.error.expired`

#### Screen 9 — Create PIN / Enable Biometrics

| Field | Value |
|---|---|
| **Purpose** | Set 4-digit PIN and optionally enable biometric auth |
| **Route** | `/create-pin` |
| **File** | `features/auth/presentation/screens/create_pin_screen.dart` |

**UI Layout:**
1. **AppBar:** Back arrow
2. **Headline:** "Create your PIN" → after first entry: "Confirm your PIN"
3. **Subtext:** "You'll use this to approve payments" (`bodyMedium`, grey)
4. **PIN display:** 4 dots (filled/empty)
5. **Numpad:** Custom 0-9 grid with backspace, no decimal
6. **After PIN confirmed:** Biometric prompt — "Enable Face ID / fingerprint?" with Enable + Skip buttons

**State:** `pinControllerProvider` — two-step: enter PIN, confirm PIN match. Then `POST /auth/pin/create`. Check `biometricAvailableProvider` to show biometric option.

**Interactions:** Enter 4 digits → confirm 4 digits → if match, save PIN → show biometric option → navigate.

**Navigation:** `→ /permissions` (new user) | `→ /home` (if permissions already granted)

**Error states:**
- PIN mismatch → shake + "PINs don't match. Try again." Clear both.

**Copy keys:** `pin.create.title`, `pin.confirm.title`, `pin.subtitle`, `pin.biometric.title`, `pin.error.mismatch`

#### Screen 10 — Permissions

| Field | Value |
|---|---|
| **Purpose** | Request OS permissions (notifications, camera) |
| **Route** | `/permissions` |
| **File** | `features/onboarding/presentation/screens/permissions_screen.dart` |

**UI Layout:**
1. **Headline:** "A couple of things" (`headlineMedium`)
2. **Permission cards** (2 cards stacked):
   - Notifications: icon + "Get notified about payments and Pia updates" + toggle/button
   - Camera: icon + "Scan QR codes and verify your ID" + toggle/button
3. **CTA:** "Get started" button (full width)

**State:** Calls platform permission APIs. Stores results.

**Interactions:** Toggle/request each permission → tap "Get started".

**Navigation:** `→ /home`

**Copy keys:** `permissions.title`, `permissions.notifications.*`, `permissions.camera.*`, `permissions.cta`

---

### 8.3 Home + Dashboard (4 screens)

#### Screen 11 — Home

| Field | Value |
|---|---|
| **Purpose** | Main landing screen with wallet balance and quick actions |
| **Route** | `/home` |
| **File** | `features/home/presentation/screens/home_screen.dart` |

**UI Layout:**
1. **Welcome header:** "Welcome back" + user first name (`headlineMedium`)
2. **Wallet balance card:** Large amount (UGX 2,500,000), "Available balance" label
3. **Quick actions row:** Send, Request, Scan, Top Up (4 circular icon buttons)
4. **tisini index mini:** Small ring preview (score number + colored arc) — tappable → dashboard
5. **Pia guidance card:** 1-3 lines + CTA (from `piaGuidanceProvider`)
6. **Recent transactions:** 3-5 items with "See all →" link

**State:** `userProvider`, `walletBalanceProvider`, `tisiniIndexProvider`, `piaGuidanceProvider`, `recentTransactionsProvider`.

**Interactions:** Tap quick action → navigate to respective flow. Tap index ring → dashboard. Tap Pia card → Pia feed or action. Tap transaction → detail.

**Navigation:** `→ /home/dashboard`, `→ /pay/send/*`, `→ /pay/request/*`, `→ /pay/scan`, `→ /pay/topup/*`, `→ /pia/*`, `→ /activity/transaction/:id`

**Error:** Pull-to-refresh. Offline banner if `connectivityProvider` is offline.

**Copy keys:** `home.welcome`, `home.balance.label`, `home.quick.*`

#### Screen 12 — Dashboard (tisini index 0-90)

| Field | Value |
|---|---|
| **Purpose** | Business picture — operational view (not a rating), actionable |
| **Route** | `/home/dashboard` |
| **File** | `features/home/presentation/screens/dashboard_screen.dart` |

**UI Layout:**
1. **AppBar:** "Dashboard" title, back arrow
2. **Ring:** Large tisini index ring (0-90), colored by zone (0-30 red, 31-60 amber, 61-90 green). Label: "Operational view (not a rating)"
3. **Change indicator:** "Up +3: pension reminder set + supplier pinned" or "Down -2: overdue bill + missing categorisation"
4. **Bar indicators (3-4 bars):**
   - Payment consistency (0-30)
   - Compliance readiness (0-30)
   - Business momentum (0-15)
   - Data completeness (0-15)
5. **Badges row:** Horizontal scrollable badges
6. **Pia guidance:** 1-3 lines + CTA

**State:** `tisiniIndexProvider`, `dashboardIndicatorsProvider`, `badgesProvider`, `piaGuidanceProvider`.

**Interactions:** Tap a bar indicator → could show detail. Tap Pia guidance → navigate to relevant action.

**Navigation:** Back to Home. Pia card action routes.

**Copy keys:** `dashboard.title`, `dashboard.index.label`, `dashboard.change.*`, `dashboard.indicators.*`

#### Screen 13 — "What needs attention" list

| Field | Value |
|---|---|
| **Purpose** | Full list of items needing user action |
| **Route** | `/home/attention` |
| **File** | `features/home/presentation/screens/attention_list_screen.dart` |

**UI Layout:**
1. **AppBar:** "What needs attention", back arrow
2. **List:** Cards with title, description, priority indicator (colored left border), action button
3. **Empty state:** "All caught up" illustration

**State:** `attentionItemsProvider`.

**Interactions:** Tap item → insight detail or direct action route.

**Navigation:** `→ /home/insight/:id` or action-specific route.

**Copy keys:** `attention.title`, `attention.empty`

#### Screen 14 — Insight Detail

| Field | Value |
|---|---|
| **Purpose** | Expanded view of a single attention/insight item |
| **Route** | `/home/insight/:id` |
| **File** | `features/home/presentation/screens/insight_detail_screen.dart` |

**UI Layout:**
1. **AppBar:** Back arrow
2. **Title:** (`headlineMedium`)
3. **Description:** Full explanation (`bodyLarge`)
4. **CTA:** Action button if applicable

**State:** `insightDetailProvider(id)`.

**Interactions:** Tap CTA → navigate to action route.

**Copy keys:** Dynamic from API.

---

### 8.4 Pay Hub + Core Payment Flows (20 screens)

#### Screen 15 — Pay Hub

| Field | Value |
|---|---|
| **Purpose** | Central payment entry point with categories |
| **Route** | `/pay` |
| **File** | `features/pay/presentation/screens/pay_hub_screen.dart` |

**UI Layout:**
1. **Header:** "Pay" (`headlineLarge`)
2. **Search bar:** "Search payees..." (debounced, 300ms)
3. **Quick actions row:** Send, Request, Scan (3 buttons)
4. **Categories grid (2 columns):**
   - Suppliers
   - Bills
   - Wages
   - Statutory (Pension is here — primary pay category)
   - Top Up
5. **Recent payees:** Horizontal scroll of PayeeCard widgets
6. **Pinned payees:** Horizontal scroll of pinned PayeeCard widgets

**State:** `payHubProvider`, `recentPayeesProvider`, `payeeSearchProvider`.

**Interactions:** Tap search → payee search results. Tap category → business category screen. Tap quick action → respective flow. Tap payee card → send flow pre-filled.

**Navigation:** `→ /pay/send/*`, `→ /pay/request/*`, `→ /pay/scan`, `→ /pay/business/*`, `→ /pay/topup/*`, `→ /pay/pensions`

**Copy keys:** `pay.title`, `pay.search.placeholder`, `pay.categories.*`

#### Screens 16-21 — Send Flow (6 screens)

**Screen 16 — Send: Recipient** (`/pay/send/recipient`)
File: `features/pay/presentation/screens/send/send_recipient_screen.dart`

Layout: AppBar "Send" + search field + recent payees list + search results. Tap payee → next.

**Screen 17 — Send: Details** (`/pay/send/details`)
File: `features/pay/presentation/screens/send/send_details_screen.dart`

Layout: Selected payee card (PayeeCard) + reference field (optional) + category selector (CategoryTag chips) + note field (optional) + Continue button.

**Screen 18 — Send: Amount** (`/pay/send/amount`)
File: `features/pay/presentation/screens/send/send_amount_screen.dart`

Layout: Large amount input (currency prefix UGX, numpad) + route selector (RouteChip for bank/mobile money/card/wallet) + fee display (CostLine) + Continue button.

**Screen 19 — Send: Confirm** (`/pay/send/confirm`)
File: `features/pay/presentation/screens/send/send_confirm_screen.dart`

Layout: Confirmation summary card showing: payee (PayeeCard), amount, route (RouteChip), fee (CostLine), total. "Pay" CTA button. Step-up guard triggers PIN/biometric before processing.

Trust principle: route + cost + total are explicitly visible.

**Screen 20 — Send: Receipt** (`/pay/send/receipt/:txId`)
File: `features/pay/presentation/screens/send/send_receipt_screen.dart`

Layout: ReceiptTemplate widget: green check icon, "Payment sent", receipt details (amount, to, route, fee, total, reference, receipt number, timestamp). "Share" and "Done" buttons.

**Screen 21 — Send: Failed** (`/pay/send/failed`)
File: `features/pay/presentation/screens/send/send_failed_screen.dart`

Layout: Red X icon, "Payment failed", error message, "Try again" + "Cancel" buttons.

**State for all send screens:** `sendControllerProvider` — state machine with steps: `recipient → details → amount → confirm → processing → receipt | failed`.

#### Screens 22-24 — Request Flow (3 screens)

**Screen 22 — Request: Create** (`/pay/request/create`)
File: `features/pay/presentation/screens/request/request_create_screen.dart`

Layout: Amount input + optional note + "Create request" CTA.

**Screen 23 — Request: Share** (`/pay/request/share/:id`)
File: `features/pay/presentation/screens/request/request_share_screen.dart`

Layout: QR code of share link + share link text + "Copy link" + "Share" (via share_plus) + "Done".

**Screen 24 — Request: Status** (`/pay/request/status/:id`)
File: `features/pay/presentation/screens/request/request_status_screen.dart`

Layout: Request details + status indicator (pending/paid) + "Share again" if still pending.

**State:** `requestControllerProvider`.

#### Screens 25-28 — Scan/Pay Flow (4 screens)

**Screen 25 — Scan** (`/pay/scan`)
File: `features/pay/presentation/screens/scan/scan_screen.dart`

Layout: Full-screen camera viewfinder with QR frame overlay + "Enter manually" text button at bottom + flash toggle.

**Screen 26 — Scan: Manual Entry** (`/pay/scan/manual`)
File: `features/pay/presentation/screens/scan/scan_manual_entry_screen.dart`

Layout: Phone/account/till input field + Continue button.

**Screen 27 — Scan: Confirm** (`/pay/scan/confirm`)
File: `features/pay/presentation/screens/scan/scan_confirm_screen.dart`

Layout: Same pattern as Send Confirm — payee + amount + route + fee + total + "Pay" CTA. Step-up guard.

**Screen 28 — Scan: Receipt** (`/pay/scan/receipt/:txId`)
File: `features/pay/presentation/screens/scan/scan_receipt_screen.dart`

Layout: Same ReceiptTemplate pattern.

**State:** `scanControllerProvider`.

#### Screens 29-32 — Pay Business Template (4 screens)

> "Pay business template" covers Suppliers / Bills / Wages / Statutory via shared screens with different data.

**Screen 29 — Business: Category** (`/pay/business/category`)
File: `features/pay/presentation/screens/business/business_category_screen.dart`

Layout: Category list (Suppliers, Bills, Wages, Statutory) — each shows count of pinned payees. Statutory includes pension as top item.

**Screen 30 — Business: Payee** (`/pay/business/payee`)
File: `features/pay/presentation/screens/business/business_payee_screen.dart`

Layout: Filtered payee list by selected category + search + "Add new payee" option.

**Screen 31 — Business: Confirm** (`/pay/business/confirm`)
File: `features/pay/presentation/screens/business/business_confirm_screen.dart`

Layout: Standard confirm pattern. Step-up guard.

**Screen 32 — Business: Receipt** (`/pay/business/receipt/:txId`)
File: `features/pay/presentation/screens/business/business_receipt_screen.dart`

Layout: Standard ReceiptTemplate.

**State:** `businessPayControllerProvider`.

#### Screens 33-36 — Top Up (4 screens)

**Screen 33 — Top Up: Source** (`/pay/topup/source`)
File: `features/pay/presentation/screens/topup/topup_source_screen.dart`

Layout: List of funding sources (Mobile Money, Bank) — each shows account identifier.

**Screen 34 — Top Up: Amount** (`/pay/topup/amount`)
File: `features/pay/presentation/screens/topup/topup_amount_screen.dart`

Layout: Amount input + selected source display + Continue.

**Screen 35 — Top Up: Confirm** (`/pay/topup/confirm`)
File: `features/pay/presentation/screens/topup/topup_confirm_screen.dart`

Layout: Source + amount + fee (if any) + total + "Top up" CTA.

**Screen 36 — Top Up: Receipt** (`/pay/topup/receipt/:txId`)
File: `features/pay/presentation/screens/topup/topup_receipt_screen.dart`

Layout: Standard ReceiptTemplate for top-up.

**State:** `topupControllerProvider`.

---

### 8.5 Pensions (5 screens)

#### Screen 37 — Pension Hub

| Field | Value |
|---|---|
| **Purpose** | Pension status, next due, reminders, contribution history preview |
| **Route** | `/pay/pensions` |
| **File** | `features/pensions/presentation/screens/pension_hub_screen.dart` |

**UI Layout:**
1. **AppBar:** "Pensions", back arrow
2. **NSSF status card:** "Linked" / "Not linked" badge + NSSF number + "Connect / verify" button if not linked
3. **Next due banner:** Date + amount + "Contribute" CTA (prominent)
4. **Active reminders:** List of upcoming reminders
5. **Quick contribute CTA:** Large button
6. **History preview:** Last 3 contributions + "See all →"

**State:** `pensionStatusProvider`, `pensionHistoryProvider`.

**Interactions:** Tap "Contribute" → contribution flow. Tap "See all" → history. Tap "Connect" → NSSF linking flow.

**Navigation:** `→ /pay/pensions/contribute`, `→ /pay/pensions/history`

**Copy keys:** `pension.title`, `pension.status.*`, `pension.next_due.*`, `pension.cta.contribute`

#### Screen 38 — Pension Contribute

| Field | Value |
|---|---|
| **Purpose** | Enter contribution amount and reference |
| **Route** | `/pay/pensions/contribute` |
| **File** | `features/pensions/presentation/screens/pension_contribute_screen.dart` |

Layout: Pre-filled payee (NSSF) + amount input (pre-filled with due amount) + reference field (auto: "NSSF {month} {year}") + route selector + Continue.

**State:** `pensionContributeControllerProvider`.

#### Screen 39 — Pension Confirm

Route: `/pay/pensions/confirm`. Standard confirm pattern with route + cost line. Step-up guard.

#### Screen 40 — Pension Receipt

Route: `/pay/pensions/receipt/:txId`. Standard ReceiptTemplate.

#### Screen 41 — Contribution History

| Field | Value |
|---|---|
| **Purpose** | Paginated list of pension contributions with filters |
| **Route** | `/pay/pensions/history` |
| **File** | `features/pensions/presentation/screens/pension_history_screen.dart` |

Layout: AppBar + filter chips (All, Completed, Pending, Failed) + list of ContributionRow widgets (date, amount, status badge) + cursor pagination.

**State:** `pensionHistoryProvider`.

---

### 8.6 Pia (6 screens)

#### Screen 42 — Pia Feed

| Field | Value |
|---|---|
| **Purpose** | Card feed of AI-generated guidance (not chat) |
| **Route** | `/pia` |
| **File** | `features/pia/presentation/screens/pia_feed_screen.dart` |

**UI Layout:**
1. **Header:** "Pia" (`headlineLarge`)
2. **Filter tabs:** All, Pinned
3. **Card list:** Vertical list of PiaCardWidget components. Each card: title, what (1 sentence), why (1 sentence), details (short), action buttons. Priority cards have colored left border (high=red, medium=cyan).
4. **Pull to refresh**

**State:** `piaFeedProvider`.

**Interactions:** Tap card → expanded detail. Tap action → action modal. Swipe to dismiss. Long-press to pin.

**Navigation:** `→ /pia/card/:id`, action modals

**Copy keys:** `pia.title`, `pia.filter.*`, `pia.empty.*`

#### Screen 43 — Pia Early/Empty State

Route: `/pia/empty`. Shown when user has no Pia cards yet (new user, no data).

Layout: Illustration + "Pia will start showing you guidance once you make a few payments or import your history." + "Import transactions" CTA.

#### Screen 44 — Pia Card Detail (Expanded)

Route: `/pia/card/:id`.

Layout: Full card content with all fields expanded + all action buttons visible + "Dismiss" and "Pin" options in overflow menu.

**State:** `piaCardDetailProvider(id)`.

#### Screen 45 — Pia Action Modal: Reminder

Shown as bottom sheet when user taps "Set reminder" action.

Layout: Date picker + optional amount field + "Set reminder" CTA.

**State:** `piaActionControllerProvider` — calls `POST /pia/cards/:id/action` with `type: set_reminder`.

#### Screen 46 — Pia Action Modal: Schedule Payment / Confirm

Shown as bottom sheet for `schedule_payment` and `ask_user_confirmation` actions.

Schedule payment: Pre-filled payee + date picker + optional amount + "Schedule" CTA.
Confirm prompt: Simple yes/no + optional "Tell Pia more" text input.

#### Screen 47 — Pinned Items (Pia View)

Route: `/pia/pinned`.

Layout: List of pinned Pia cards, filterable. Unpin option per card.

**State:** `piaPinnedProvider`.

---

### 8.7 Activity (6 screens)

#### Screen 48 — Activity List

| Field | Value |
|---|---|
| **Purpose** | Chronological list of all transactions |
| **Route** | `/activity` |
| **File** | `features/activity/presentation/screens/activity_list_screen.dart` |

**UI Layout:**
1. **Header:** "Activity" (`headlineLarge`)
2. **Filter button** (top right) → filter screen
3. **Active filter chips** (if any filters applied)
4. **Transaction list:** Grouped by date. Each row: TransactionRow widget (icon, counterparty name, amount, category tag, time). Uses `ListView.builder` for performance.
5. **"Export" button** in header actions
6. **Cursor pagination** (load more on scroll)

**State:** `transactionListProvider`, `transactionFiltersProvider`.

**Interactions:** Tap row → transaction detail. Tap filter → filters screen. Tap export → export flow. Pull to refresh.

**Copy keys:** `activity.title`, `activity.export`, `activity.empty`

#### Screen 49 — Filters

Route: `/activity/filters`.

Layout: Bottom sheet or full screen with filter options: direction (In/Out/All), category (multi-select chips), date range picker. "Apply" + "Clear" buttons.

**State:** `transactionFiltersProvider`.

#### Screen 50 — Transaction Detail

| Field | Value |
|---|---|
| **Purpose** | Full transaction details with edit category + pin merchant |
| **Route** | `/activity/transaction/:id` |
| **File** | `features/activity/presentation/screens/transaction_detail_screen.dart` |

**UI Layout:**
1. **AppBar:** Back arrow
2. **Amount:** Large display (`amountLarge`)
3. **Status badge:** (completed/pending/failed)
4. **Details card:** Counterparty, route, fee, total, reference, timestamp
5. **Category tag:** CategoryTag widget + "Edit" action (opens category selector bottom sheet)
6. **Pin merchant:** PinMerchantControl — "Pin merchant" button → role selector (supplier/rent/wages/tax/pension/utilities)
7. **Optional note field:** Editable

**State:** `transactionDetailProvider(id)`, `updateCategoryProvider`, `pinMerchantProvider`.

**Interactions:** Tap "Edit category" → bottom sheet with category chips. Tap "Pin merchant" → role selector. Edit note → auto-save (debounced).

**Copy keys:** `transaction.detail.*`

#### Screens 51-53 — Export Flow (3 screens)

**Screen 51 — Export: Choose Period** (`/activity/export/period`)

Layout: Period options (This month, Last month, Custom) + date range picker for custom + "Continue".

**Screen 52 — Export: Confirm** (`/activity/export/confirm`)

Layout: Summary (period, estimated rows) + format info (CSV) + "Export" CTA.

**Screen 53 — Export: Success** (`/activity/export/success`)

Layout: Green check + "Export ready" + download/share button + "Done".

**State:** `exportControllerProvider`.

---

### 8.8 More + Settings (9 screens)

#### Screen 54 — More Hub

| Field | Value |
|---|---|
| **Route** | `/more` |
| **File** | `features/more/presentation/screens/more_hub_screen.dart` |

**UI Layout:**
1. **User header:** Avatar placeholder + name + phone
2. **Menu list:** Settings tiles with icons:
   - Profile / Business details
   - Connected accounts
   - Security settings
   - Notifications
   - Pinned merchants
   - Verify identity (KYC) — shows status badge
   - Help / Support
   - Legal / About
3. **App version** at bottom

**Interactions:** Tap any tile → navigate to respective screen.

#### Screen 55 — Profile / Business Details

Route: `/more/profile`. Layout: Editable form (name, business name, email, phone (read-only), account type). Save button.

#### Screen 56 — Connected Accounts List

Route: `/more/accounts`. Layout: List of connected accounts + "Add account" CTA → connect account screen. Each account shows provider, identifier, connected date.

#### Screen 57 — Connect Account

Route: `/more/accounts/connect`. Layout: Provider list (Bank, Mobile Money) + "Import statement" option (→ import flow). Selecting a provider starts OAuth or manual linking.

#### Screen 58 — Security Settings

Route: `/more/security`. Layout: PIN toggle (always on), Biometric toggle, 2-step verification toggle, Trusted devices list.

#### Screen 59 — Notification Settings

Route: `/more/notifications`. Layout: Toggle switches for: Payment received, Pia cards, Pension reminders, Promotions.

#### Screen 60 — Pinned Merchants

Route: `/more/merchants`. Layout: List of pinned merchants with assigned role + quick edit/remove. Each shows name, identifier, role chip. Tap → edit role bottom sheet.

#### Screen 61 — Help / Support

Route: `/more/help`. Layout: FAQ accordion + "Contact support" button (email/in-app).

#### Screen 62 — Legal / About

Route: `/more/legal`. Layout: Links to Terms, Privacy Policy, Licences. "New rails coming" placeholder if stablecoin feature flag is off. App version + build number.

---

### 8.9 Bulk Import (5 screens)

#### Screen 63 — Import: Choose Source

| Field | Value |
|---|---|
| **Route** | `/more/import/source` |
| **File** | `features/bulk_import/presentation/screens/import_source_screen.dart` |

Layout: "Import statement" header + source options: Bank CSV, Mobile Money CSV. Each with description of supported formats.

#### Screen 64 — Import: Upload + Map Fields

Route: `/more/import/upload`. Layout: File picker CTA + after upload: column mapping UI — dropdowns mapping CSV columns to (date, amount, merchant, reference) + sample data preview.

#### Screen 65 — Import: Review

Route: `/more/import/review`. Layout: Sample rows table (first 5 rows) + categorisation preview ("89 auto-categorised, 53 need review") + "Import" CTA.

#### Screen 66 — Import: Progress

Route: `/more/import/progress/:jobId`. Layout: Progress bar + processed/total count + animated indicator. Polls `GET /import/:jobId/status` every 3 seconds.

#### Screen 67 — Import: Result

Route: `/more/import/result/:jobId`. Layout: Success summary (imported count, categorised, uncategorised) + error list if any + "Review transactions" CTA (→ activity with filter) + "Done".

**State for all import screens:** `importControllerProvider`, `importJobStatusProvider`.

---

### 8.10 KYC / Verification (5 screens + 4 result states = 9)

> "Verification powered by [Provider]" required.

#### Screen 68 — Verification Entry

Route: `/more/kyc`. Layout: "Verify your identity" header + why explanation + provider disclosure ("Verification powered by [Provider]") + "Start verification" CTA. Shows current status if already submitted.

#### Screen 69 — Choose Account Type

Route: `/more/kyc/account-type`. Layout: Two cards — "Business" and "Gig worker / Sole trader" — with descriptions. Selection determines required documents.

#### Screen 70 — Document Checklist

Route: `/more/kyc/checklist`. Layout: Checklist of required documents: ID (front + back), Selfie/liveness. Business: + registration/licence/TIN. Green checks for uploaded items. "Continue" when all ready.

#### Screen 71 — Capture ID Front

Route: `/more/kyc/id-front`. Layout: Camera viewfinder with ID card frame overlay + capture button + "Retake" option after capture. DocumentCaptureFrame widget.

#### Screen 72 — Capture ID Back

Route: `/more/kyc/id-back`. Same pattern as ID front with back-of-card frame.

#### Screen 73 — Selfie / Liveness

Route: `/more/kyc/selfie`. Layout: Front camera with face outline overlay + instructions ("Look straight at the camera") + capture button.

#### Screen 74 — Review + Submit

Route: `/more/kyc/review`. Layout: Thumbnail previews of all captured documents + account type + "Submit for review" CTA. Uploads via `POST /kyc/submit`.

#### Screen 75 — Pending

Route: `/more/kyc/pending`. Layout: Clock illustration + "Your verification is being reviewed" + "This usually takes 1-2 business days" + "Done" button.

#### Screen 76 — Approved

Route: `/more/kyc/approved`. Layout: Green check illustration + "You're verified" + "Your account is now fully active" + "Done" button.

#### Screen 77 — Failed + Retry

Route: `/more/kyc/failed`. Layout: Red X illustration + "Verification unsuccessful" + rejection reason + "Try again" CTA (→ restart flow) + "Contact support" link.

**State for all KYC screens:** `kycFlowProvider`, `kycCaptureControllerProvider`, `kycSubmissionStatusProvider`.

---

### 8.11 Screen Count Verification

| Section | Count | Screen Numbers |
|---|---|---|
| Launch Splash | 2 | 1-2 |
| Onboarding + Auth | 8 | 3-10 |
| Home + Dashboard | 4 | 11-14 |
| Pay hub + core payment flows | 22 | 15-36 |
| Pensions | 5 | 37-41 |
| Pia | 6 | 42-47 |
| Activity | 6 | 48-53 |
| More + Settings | 9 | 54-62 |
| Bulk import | 5 | 63-67 |
| KYC / Verification | 5 + 4 states | 68-77 |
| **Total** | **72** (screens 68-77 counted as 5 screens + 4 result states per brief) | **1-77** |

---

## 9. Shared Components

### 9.1 PayeeCard

| Field | Value |
|---|---|
| **File** | `shared/widgets/payee_card.dart` |
| **Used in** | Pay hub, Send recipient, Business payee, Scan confirm, Send confirm, Pension contribute |

**Props:**
```dart
class PayeeCard extends StatelessWidget {
  final String name;
  final String identifier;
  final PaymentRail rail;
  final MerchantRole? role;
  final String? avatarUrl;
  final bool isPinned;
  final VoidCallback? onTap;
}
```

**Visual spec:** White card with `AppRadii.card` border radius, 1px border. Left: circular avatar (40px, initials fallback). Center: name (`titleMedium`), identifier (`bodySmall`, grey). Right: RouteChip showing rail. If pinned, small pin icon. Entire card tappable.

**Behavior:** On tap, calls `onTap`. Optional trailing widget for cost line in confirm screens.

### 9.2 RouteChip

| Field | Value |
|---|---|
| **File** | `shared/widgets/route_chip.dart` |
| **Used in** | Send amount, Send confirm, Scan confirm, Business confirm, Pension confirm, Top up confirm, PayeeCard |

**Props:**
```dart
class RouteChip extends StatelessWidget {
  final PaymentRail rail;
  final bool isSelected;
  final VoidCallback? onTap;
}
```

**Visual spec:** Pill-shaped chip (`AppRadii.pill`). Icon + label. MVP rails: Bank, Mobile Money, Card, Wallet. Selected state: `AppColors.darkBlue` background, white text. Unselected: `AppColors.background` background, `darkBlue` text.

**Behavior:** Tappable for selection in route selector. Read-only display in confirm screens.

### 9.3 CostLine

| Field | Value |
|---|---|
| **File** | `shared/widgets/cost_line.dart` |
| **Used in** | Send confirm, Scan confirm, Business confirm, Pension confirm, Top up confirm |

**Props:**
```dart
class CostLine extends StatelessWidget {
  final double amount;
  final double fee;
  final double total;
  final String currency;
}
```

**Visual spec:** Three rows, right-aligned amounts:
- Amount: `bodyMedium`
- Fee: `bodySmall`, grey, "Fee: UGX 500" (or "Free" in green if zero)
- Total: `titleMedium`, bold, top border (1px divider)

Costs are transparent, quiet, not promotional per design philosophy.

### 9.4 PiaCardWidget

| Field | Value |
|---|---|
| **File** | `shared/widgets/pia_card_widget.dart` |
| **Used in** | Pia feed, Pia card detail, Home (Pia guidance), Dashboard |

**Props:**
```dart
class PiaCardWidget extends StatelessWidget {
  final PiaCard card;
  final bool isExpanded;
  final VoidCallback? onTap;
  final Function(PiaAction)? onAction;
  final VoidCallback? onDismiss;
  final VoidCallback? onPin;
}
```

**Visual spec:** White card with left colored border (high=`AppColors.red`, medium=`AppColors.cyan`, low=`AppColors.grey`). Content:
- Title (`titleMedium`, bold)
- What (1 sentence, `bodyMedium`)
- Why (1 sentence, `bodySmall`, grey)
- Details line (`labelMedium`, if present)
- Action buttons row (TextButton style, `AppColors.cyan`)
- Overflow menu (dismiss, pin)

**Behavior:** Tap card → expand/navigate to detail. Tap action → triggers action modal. Long-press → pin. Swipe → dismiss.

### 9.5 TisiniIndexRing

| Field | Value |
|---|---|
| **File** | `shared/widgets/tisini_index_ring.dart` |
| **Used in** | Dashboard, Home (mini version) |

**Props:**
```dart
class TisiniIndexRing extends StatelessWidget {
  final int score;        // 0-90
  final double size;      // Ring diameter
  final bool showLabel;   // "Operational view (not a rating)"
}
```

**Visual spec:** Circular arc progress indicator drawn with `fl_chart` or custom `CustomPainter`. Score number centered inside ring (`displayLarge` for full size, `headlineMedium` for mini). Arc color: 0-30 `zoneRed`, 31-60 `zoneAmber`, 61-90 `zoneGreen`. Background arc: `AppColors.background`. Arc covers 270 degrees (3/4 circle), starting from bottom-left.

**Behavior:** Animated on first render (0 → score). Tappable in home (navigates to dashboard).

### 9.6 DashboardBarIndicator

| Field | Value |
|---|---|
| **File** | `shared/widgets/dashboard_bar_indicator.dart` |
| **Used in** | Dashboard |

**Props:**
```dart
class DashboardBarIndicator extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;
}
```

**Visual spec:** Horizontal bar chart row. Left: label (`bodySmall`). Center: progress bar (filled portion colored, remainder grey). Right: "value/maxValue" (`labelMedium`). Bar height: 8px, rounded ends (`AppRadii.pill`).

### 9.7 BadgeChip

| Field | Value |
|---|---|
| **File** | `shared/widgets/badge_chip.dart` |
| **Used in** | Dashboard (badges row) |

**Props:**
```dart
class BadgeChip extends StatelessWidget {
  final String label;
  final String iconName;
  final bool isEarned;
}
```

**Visual spec:** Pill chip. Earned: `AppColors.green` background with icon + label in `darkBlue`. Not earned: `AppColors.background` with grey icon + grey label. Size: 32px height. Icon: 16px.

### 9.8 TransactionRow

| Field | Value |
|---|---|
| **File** | `shared/widgets/transaction_row.dart` |
| **Used in** | Activity list, Home (recent transactions) |

**Props:**
```dart
class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
}
```

**Visual spec:** ListTile pattern. Leading: direction icon (arrow up for outbound in `red`, arrow down for inbound in `green`), 40px circle. Title: counterparty name (`titleMedium`). Subtitle: time + CategoryTag. Trailing: amount (`titleMedium`, colored by direction) + currency code.

**Behavior:** Tap → transaction detail.

### 9.9 CategoryTag

| Field | Value |
|---|---|
| **File** | `shared/widgets/category_tag.dart` |
| **Used in** | Transaction detail, Transaction row, Send details |

**Props:**
```dart
class CategoryTag extends StatelessWidget {
  final TransactionCategory category;
  final bool isEditable;
  final ValueChanged<TransactionCategory>? onChanged;
}
```

**Visual spec:** Small pill chip with category icon + label. Colors per category:
- Sales: `green`
- Inventory: `cyan`
- Bills: `AppColors.warning`
- People: `darkBlue`
- Compliance: `red`
- Agency: `grey`
- Uncategorised: dashed border, grey

When `isEditable`, shows chevron and opens bottom sheet selector on tap.

### 9.10 PinMerchantControl

| Field | Value |
|---|---|
| **File** | `shared/widgets/pin_merchant_control.dart` |
| **Used in** | Transaction detail |

**Props:**
```dart
class PinMerchantControl extends StatelessWidget {
  final String payeeId;
  final String payeeName;
  final MerchantRole? currentRole;
  final ValueChanged<MerchantRole> onRoleSelected;
}
```

**Visual spec:** If not pinned: "Pin merchant" button with pin icon. If pinned: shows current role chip + "Change role" text button. Tapping opens bottom sheet with role grid: Supplier, Rent, Wages, Tax, Pension, Utilities — each as a selectable card with icon.

### 9.11 ReceiptTemplate

| Field | Value |
|---|---|
| **File** | `shared/widgets/receipt_template.dart` |
| **Used in** | Send receipt, Scan receipt, Business receipt, Top up receipt, Pension receipt |

**Props:**
```dart
class ReceiptTemplate extends StatelessWidget {
  final PaymentReceipt receipt;
  final VoidCallback? onShare;
  final VoidCallback? onDone;
}
```

**Visual spec:** Full screen layout:
1. Status icon: green circle check (success) or red circle X (failed) — 64px
2. Status text: "Payment sent" / "Top up successful" / etc. (`headlineMedium`)
3. Amount: `amountLarge`
4. Details card: receipt number, payee, route, fee, total, reference, timestamp — each as label-value row
5. **Bottom actions:** "Share" outlined button + "Done" filled button

Receipt card has a subtle "receipt" appearance with torn-edge top (optional decorative).

---

## 10. Authentication & Security

### 10.1 Auth Flow Diagram

```
┌─────────┐     ┌────────────┐     ┌─────┐     ┌─────┐     ┌───────────┐     ┌──────┐
│  Splash  │────▶│ Onboarding │────▶│Login│────▶│ OTP │────▶│Create PIN │────▶│ Home │
└─────────┘     └────────────┘     └─────┘     └─────┘     └───────────┘     └──────┘
     │                                                           │
     │ (has tokens)                                   (enable biometrics?)
     │                                                           │
     ▼                                                           ▼
┌──────┐                                               ┌─────────────┐
│ Home │◀──────────────────────────────────────────────│  Biometric   │
└──────┘                                               │   Prompt     │
     │                                                 └─────────────┘
     │ (token expired)
     ▼
┌─────────────┐
│ Token Refresh│──── (success) ────▶ Home
└─────────────┘
     │ (fail)
     ▼
┌─────┐
│Login│
└─────┘
```

### 10.2 Token Management

**Token pair:** Access token (short-lived, 30 min) + Refresh token (long-lived, 30 days).

**Storage:** Both stored in `FlutterSecureStorage` (encrypted at rest).

**Dio Interceptor with Queue:**

```dart
// lib/core/network/auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;
  final _pendingRequests = <({RequestOptions options, ErrorInterceptorHandler handler})>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      // Queue this request
      _pendingRequests.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();
      final response = await _dio.post('/auth/token/refresh', data: {
        'refresh_token': refreshToken,
      });

      final newTokens = AuthToken.fromJson(response.data['data']);
      await _storage.saveTokens(newTokens);

      // Retry original request
      final retryResponse = await _dio.fetch(err.requestOptions
        ..headers['Authorization'] = 'Bearer ${newTokens.accessToken}');
      handler.resolve(retryResponse);

      // Retry queued requests
      for (final pending in _pendingRequests) {
        final retryResp = await _dio.fetch(pending.options
          ..headers['Authorization'] = 'Bearer ${newTokens.accessToken}');
        pending.handler.resolve(retryResp);
      }
    } catch (e) {
      // Refresh failed — force re-login
      await _storage.clearTokens();
      // Navigate to login (via auth state change)
      handler.reject(err);
      for (final pending in _pendingRequests) {
        pending.handler.reject(err);
      }
    } finally {
      _pendingRequests.clear();
      _isRefreshing = false;
    }
  }
}
```

### 10.3 Step-Up Verification

For risky actions (payment confirmations, security settings changes):

1. **Trigger:** Route guard checks `lastVerifiedAtProvider` timestamp
2. **Threshold:** 5 minutes since last verification
3. **Modal:** Bottom sheet with PIN pad (or biometric prompt if enabled)
4. **On success:** Update `lastVerifiedAtProvider`, proceed to target screen
5. **On failure:** Stay on current screen, show error

**Risky actions requiring step-up:**
- Send payment confirm
- Scan/pay confirm
- Business payment confirm
- Pension contribution confirm
- Security settings changes
- KYC submission

### 10.4 Session Management

**Background → Foreground:**
- If app was backgrounded > 5 minutes: show PIN/biometric lock screen
- If backgrounded > 30 minutes: soft-check token validity
- If backgrounded > 24 hours: force token refresh

**Implementation:** Use `WidgetsBindingObserver.didChangeAppLifecycleState` in `app.dart`. Store `backgroundedAt` timestamp. On resume, compare.

**Logout:** Clear all secure storage, clear drift cache, reset all providers, navigate to `/login`.

---

## 11. Local Storage Strategy

### 11.1 Four Storage Layers

| Layer | Technology | Contents | Encryption |
|---|---|---|---|
| **Secure** | `FlutterSecureStorage` | Access token, refresh token, PIN hash, biometric flag | AES-256 (platform keychain) |
| **Preferences** | `SharedPreferences` | `hasSeenOnboarding`, `lastVerifiedAt`, UI flags, feature flags | None (non-sensitive) |
| **Database** | `Drift` (SQLite) | Transaction cache, payee cache, Pia cards cache, pension history | None (non-sensitive data only) |
| **File system** | `path_provider` temp dir | KYC photo captures (temp), CSV uploads (temp) | None (deleted after upload) |

### 11.2 Drift Schema

```dart
// lib/core/storage/database/app_database.dart

// --- Tables ---

class CachedTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get direction => text()();
  TextColumn get status => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  TextColumn get counterpartyName => text()();
  TextColumn get counterpartyIdentifier => text()();
  TextColumn get category => text()();
  TextColumn get merchantRole => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get rail => text()();
  IntColumn get fee => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPayees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get identifier => text()();
  TextColumn get rail => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastPaidAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPiaCards extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get what => text()();
  TextColumn get why => text()();
  TextColumn get details => text().nullable()();
  TextColumn get actionsJson => text()(); // JSON array of PiaAction
  TextColumn get priority => text()();
  TextColumn get status => text()();
  BoolColumn get isPinned => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPensionContributions extends Table {
  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  TextColumn get status => text()();
  TextColumn get reference => text().nullable()();
  TextColumn get rail => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Indexes ---
// CachedTransactions: index on (createdAt DESC), index on (category)
// CachedPayees: index on (lastPaidAt DESC), index on (isPinned)
// CachedPiaCards: index on (priority, createdAt DESC)
```

### 11.3 Cache Invalidation: Stale-While-Revalidate

Pattern: Return cached data immediately, then fetch fresh data in background. Update UI when fresh data arrives.

| Entity | Max Cache Age | Revalidation Trigger |
|---|---|---|
| Transactions | 5 minutes | Screen visit, pull-to-refresh, after payment |
| Payees | 15 minutes | Search, after pin/unpin |
| Pia cards | 10 minutes | Tab visit, pull-to-refresh |
| Pension status | 15 minutes | Screen visit, after contribution |
| Dashboard / Index | 10 minutes | Home screen visit |
| User profile | 30 minutes | Profile screen visit |

**Implementation:** Each repository checks `cachedAt` column vs max age. If stale, fetch from API and update cache. If offline, serve cache regardless of age.

---

## 12. Error Handling

### 12.1 Exception Hierarchy

```dart
// lib/core/errors/exceptions.dart

sealed class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
}

// Network-level
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out', code: 'TIMEOUT');
}

class NoConnectionException extends NetworkException {
  const NoConnectionException() : super('No internet connection', code: 'NO_CONNECTION');
}

// Server-level (API returned an error)
class ServerException extends AppException {
  final int statusCode;
  final Map<String, dynamic>? details;
  const ServerException(super.message, {required this.statusCode, super.code, this.details});
}

// Business logic
class BusinessException extends AppException {
  const BusinessException(super.message, {super.code});
}

class InsufficientBalanceException extends BusinessException {
  const InsufficientBalanceException() : super('Insufficient balance', code: 'INSUFFICIENT_BALANCE');
}

class KycRequiredException extends BusinessException {
  const KycRequiredException() : super('Identity verification required', code: 'KYC_REQUIRED');
}

class PaymentFailedException extends BusinessException {
  final String? reason;
  const PaymentFailedException({this.reason}) : super('Payment failed', code: 'PAYMENT_FAILED');
}

// Validation
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;
  const ValidationException(super.message, {required this.fieldErrors, super.code});
}

// Auth
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException() : super('Session expired', code: 'AUTH_REFRESH_FAILED');
}
```

### 12.2 UI Error Patterns

| Pattern | When | Implementation |
|---|---|---|
| **Screen-level error** | Entire screen data fails to load | Full-screen `ErrorView` widget with message + "Try again" button. Replaces content. |
| **Inline error** | Form field validation or API field error | Red text below input field (`bodySmall`, `AppColors.red`). |
| **Snackbar** | Non-critical background failure | Bottom snackbar, auto-dismiss 4s. |
| **Payment failed screen** | Payment processing fails | Dedicated screen (Screen 21) with retry + cancel. |
| **Offline banner** | No internet connection | Persistent top banner: "You're offline" with grey background. Content shows cached data. |
| **Bottom sheet error** | Action failure within modal | Error message inside the bottom sheet, above CTA button. |
| **Empty state** | No data available (not an error) | Illustration + message + action CTA (e.g., "Import transactions"). |

### 12.3 Retry Patterns

```dart
// lib/core/errors/error_handler.dart

class ErrorHandler {
  /// Retry with exponential backoff for server errors (5xx)
  static Future<T> withRetry<T>({
    required Future<T> Function() action,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    var delay = initialDelay;
    for (var attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await action();
      } on ServerException catch (e) {
        if (e.statusCode < 500 || attempt == maxRetries) rethrow;
        await Future.delayed(delay);
        delay *= 2; // exponential backoff
      }
    }
    throw const ServerException('Max retries exceeded', statusCode: 500);
  }
}
```

**Retry rules:**
- 5xx errors: Retry up to 3 times with exponential backoff (1s, 2s, 4s)
- 4xx errors: Never retry (client error, user must fix)
- Network errors: Retry up to 2 times, then show offline banner
- 429 (rate limited): Respect `Retry-After` header, show message to user

---

## 13. Testing Strategy

### 13.1 Test Pyramid

| Level | Coverage Target | Focus |
|---|---|---|
| **Unit tests** | 80%+ line coverage | Domain entities, repository logic, controllers, providers, formatters, validators |
| **Widget tests** | 70%+ of shared components | All 11 shared components, screen layouts, interaction flows |
| **Integration tests** | All 8 prototype journeys | End-to-end flows with mocked backend |
| **Golden tests** | All 11 shared components | Visual regression for design system compliance |

### 13.2 Test File Structure

Test files mirror `lib/` structure:

```
test/
├── core/
│   ├── network/
│   │   ├── auth_interceptor_test.dart
│   │   └── dio_client_test.dart
│   ├── errors/
│   │   └── error_handler_test.dart
│   ├── storage/
│   │   └── database/
│   │       └── app_database_test.dart
│   ├── router/
│   │   ├── app_router_test.dart
│   │   └── guards/
│   │       ├── auth_guard_test.dart
│   │       ├── kyc_guard_test.dart
│   │       └── step_up_guard_test.dart
│   └── utils/
│       ├── formatters_test.dart
│       └── validators_test.dart
│
├── shared/
│   └── widgets/
│       ├── payee_card_test.dart
│       ├── route_chip_test.dart
│       ├── cost_line_test.dart
│       ├── pia_card_widget_test.dart
│       ├── tisini_index_ring_test.dart
│       ├── dashboard_bar_indicator_test.dart
│       ├── badge_chip_test.dart
│       ├── transaction_row_test.dart
│       ├── category_tag_test.dart
│       ├── pin_merchant_control_test.dart
│       └── receipt_template_test.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/auth_remote_datasource_test.dart
│   │   │   └── repositories/auth_repository_impl_test.dart
│   │   └── presentation/
│   │       ├── screens/login_screen_test.dart
│   │       ├── screens/otp_screen_test.dart
│   │       └── providers/login_controller_test.dart
│   ├── home/
│   │   ├── data/repositories/dashboard_repository_impl_test.dart
│   │   └── presentation/providers/dashboard_provider_test.dart
│   ├── pay/
│   │   ├── data/repositories/payment_repository_impl_test.dart
│   │   └── presentation/providers/send_controller_test.dart
│   ├── pensions/
│   │   └── ...
│   ├── pia/
│   │   └── ...
│   ├── activity/
│   │   └── ...
│   ├── more/
│   │   └── ...
│   ├── bulk_import/
│   │   └── ...
│   └── kyc/
│       └── ...
│
├── goldens/
│   ├── payee_card_golden_test.dart
│   ├── route_chip_golden_test.dart
│   ├── cost_line_golden_test.dart
│   ├── pia_card_widget_golden_test.dart
│   ├── tisini_index_ring_golden_test.dart
│   ├── dashboard_bar_indicator_golden_test.dart
│   ├── badge_chip_golden_test.dart
│   ├── transaction_row_golden_test.dart
│   ├── category_tag_golden_test.dart
│   ├── pin_merchant_control_golden_test.dart
│   └── receipt_template_golden_test.dart
│
├── integration/
│   ├── journey_1_splash_to_home_test.dart
│   ├── journey_2_send_payment_test.dart
│   ├── journey_3_scan_pay_test.dart
│   ├── journey_4_pia_action_test.dart
│   ├── journey_5_pension_contribute_test.dart
│   ├── journey_6_categorise_transaction_test.dart
│   ├── journey_7_import_csv_test.dart
│   └── journey_8_kyc_verification_test.dart
│
└── fixtures/
    ├── user_fixture.dart
    ├── transaction_fixture.dart
    ├── payee_fixture.dart
    ├── pia_card_fixture.dart
    ├── pension_fixture.dart
    └── api_responses/
        ├── dashboard_response.json
        ├── transactions_response.json
        └── ...
```

### 13.3 Mocking Strategy

**Riverpod overrides:** Use `ProviderContainer` with `overrides` for unit and widget tests:

```dart
// Example: Testing SendController
final container = ProviderContainer(
  overrides: [
    paymentRepositoryProvider.overrideWithValue(MockPaymentRepository()),
    authStateProvider.overrideWith((_) => AuthState.authenticated(testUser)),
  ],
);
```

**Dio mocking:** Use `dio_test` or `http_mock_adapter` for interceptor tests.

**Drift testing:** Use in-memory database with `NativeDatabase.memory()`.

**Test fixtures:** Shared factory methods in `test/fixtures/` returning valid entity instances with sensible defaults:

```dart
// test/fixtures/transaction_fixture.dart
Transaction makeTransaction({
  String? id,
  double? amount,
  TransactionCategory? category,
}) => Transaction(
  id: id ?? 'tx_test_001',
  type: PaymentType.send,
  direction: TransactionDirection.outbound,
  status: PaymentStatus.completed,
  amount: amount ?? 500000,
  currency: 'UGX',
  counterpartyName: 'Test Merchant',
  counterpartyIdentifier: '+256700000000',
  category: category ?? TransactionCategory.bills,
  merchantRole: null,
  note: null,
  rail: PaymentRail.mobileMoney,
  fee: 500,
  createdAt: DateTime(2026, 2, 18),
);
```

### 13.4 Integration Test Journeys (8 journeys)

| # | Journey | Screens Covered |
|---|---|---|
| 1 | Splash → Onboarding → Login → Home | 1, 3-10, 11 |
| 2 | Home → Pay → Send → Confirm → Receipt | 11, 15, 16-20 |
| 3 | Pay → Scan/Pay → Confirm → Receipt | 15, 25-28 |
| 4 | Home → Pia → action (reminder/schedule) → confirmation | 11, 42, 44-46 |
| 5 | Pay → Pensions → Contribute → Confirm → Receipt | 15, 37-40 |
| 6 | Activity → Transaction detail → edit category + pin merchant | 48, 50 |
| 7 | More → Connected accounts → Import → review → result | 54, 56-57, 63-67 |
| 8 | More → Verify → KYC → pending/approved/failed | 54, 68-77 |

---

## 14. Performance Considerations

### 14.1 Startup Performance

- **Target:** < 3 seconds cold start on a mid-range Android device (e.g., Samsung A14)
- **Strategy:**
  - Use `flutter_native_splash` for instant visual feedback
  - Defer non-critical initialization (analytics, push registration) after first frame
  - Minimize `main()` work: only init secure storage + check auth state
  - Pre-warm Dio client with base configuration
  - No API calls during splash — auth check is local (stored tokens)

### 14.2 List Performance

- **All lists use `ListView.builder`** — never `ListView(children: [...])` for dynamic content
- **Cursor-based pagination:** Load 20 items initially, fetch next page when user scrolls to 80% threshold
- **Transaction list:** Use `SliverList` with date group headers via `SliverStickyHeader`
- **Image caching:** Use `cached_network_image` for payee avatars with placeholder initials

### 14.3 Network Optimization

| Technique | Application |
|---|---|
| **Batch dashboard call** | `/dashboard` returns index + badges + Pia guidance in one call |
| **Debounced search** | Payee search debounced 300ms to reduce API calls |
| **Parallel fetches** | Home screen fetches balance, index, and recent transactions concurrently |
| **Stale-while-revalidate** | Show cached data instantly, refresh in background |
| **Conditional requests** | Use `If-None-Match` / `ETag` headers for unchanged resources |

### 14.4 Bundle Size

- **APK target:** < 25MB
- **iOS target:** < 30MB
- **Strategy:**
  - Use `--split-per-abi` for Android (produces ~8-12MB per ABI)
  - Minimize asset sizes: SVG for icons, WebP for illustrations
  - Tree-shake unused Phosphor Icons
  - Avoid large packages; prefer lightweight alternatives
  - Run `flutter build --analyze-size` during CI

### 14.5 Offline Behavior (MVP)

- **Read-only cache:** Cached transactions, payees, Pia cards, and pension history are available offline
- **No offline write queue in MVP:** All mutations (payments, actions, exports) require connectivity
- **Offline indicator:** Persistent top banner when offline
- **Graceful degradation:**
  - Home: Show cached balance (with "last updated" timestamp), cached index, cached transactions
  - Pay: Show cached payees for browsing; disable payment CTAs
  - Pia: Show cached cards; disable actions
  - Activity: Show cached transactions; disable export

---

## Appendix A: Feature Flag Registry

| Flag | Key | Default (MVP) | Purpose |
|---|---|---|---|
| Stablecoin rails | `stablecoin_rails` | `false` | Show stablecoin as a route option in Pay |
| Pockets | `pockets` | `false` | Enable create_pocket / suggest_transfer_to_pocket Pia actions |
| Bulk import | `bulk_import` | `true` | Enable CSV import flow from Connected accounts |
| Pia cards | `pia_cards` | `true` | Enable Pia tab and card feed |
| Pension integration | `pension_integration` | `true` | Enable pension hub and contribution flow |

**Implementation:** Flags stored in `SharedPreferences`, seeded from API on login, checked via `featureFlagsProvider`. UI hides flagged features entirely (not greyed out).

**Stablecoin note:** When `stablecoin_rails` is false, the "Stablecoin" route must NOT appear in Pay confirmations or Top Up sources. A "New rails coming" placeholder can exist only in More → Legal/About.

---

## Appendix B: Localization Strategy

### Setup

- Use Flutter's built-in `intl` package with ARB files
- Default locale: `en_UG` (English, Uganda)
- ARB directory: `lib/l10n/`

### ARB File Structure

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appName": "tisini",
  "home_welcome": "Welcome back",
  "home_balance_label": "Available balance",
  "pay_title": "Pay",
  "pay_search_placeholder": "Search payees...",
  "send_confirm_cta": "Pay",
  "receipt_success_title": "Payment sent",
  "pension_title": "Pensions",
  "pia_title": "Pia",
  "activity_title": "Activity",
  "more_title": "More",
  ...
}
```

### Conventions

- All user-facing strings extracted to ARB (no hardcoded strings in widgets)
- Use ICU message syntax for plurals and gender: `{count, plural, one{1 transaction} other{{count} transactions}}`
- Currency formatting via `NumberFormat.currency(locale: 'en_UG', symbol: 'UGX')`
- Date formatting via `DateFormat` with locale-aware patterns
- tisini provides final copy per screen — ARB keys use `screen.element` naming

---

## Appendix C: Analytics Event Catalog

| Event | Parameters | Trigger |
|---|---|---|
| `app_open` | `source: (cold\|warm\|push)` | App launch |
| `onboarding_complete` | `skipped: bool` | Finish or skip onboarding |
| `login_start` | — | Phone number submitted |
| `login_complete` | `is_new_user: bool` | OTP verified |
| `pin_created` | `biometric_enabled: bool` | PIN setup complete |
| `payment_initiated` | `type, rail, category` | Confirm button tapped |
| `payment_completed` | `type, rail, amount_range, category` | Receipt shown |
| `payment_failed` | `type, rail, error_code` | Failed screen shown |
| `payee_searched` | `query_length, results_count` | Search submitted |
| `payee_pinned` | `role` | Merchant pinned |
| `category_changed` | `from, to` | Category edited |
| `pension_contribute_start` | — | Contribute flow entered |
| `pension_contribute_complete` | `amount_range, rail` | Pension receipt shown |
| `pia_card_viewed` | `card_id, priority` | Card detail opened |
| `pia_action_taken` | `action_type, card_id` | Action executed |
| `pia_card_dismissed` | `card_id` | Card dismissed |
| `pia_card_pinned` | `card_id` | Card pinned |
| `export_completed` | `period, row_count` | Export success |
| `import_started` | `source` | Import flow entered |
| `import_completed` | `source, row_count, error_count` | Import result |
| `kyc_started` | `account_type` | KYC flow entered |
| `kyc_submitted` | `account_type, doc_count` | KYC submitted |
| `kyc_result` | `status` | KYC result received |
| `dashboard_viewed` | `score` | Dashboard opened |
| `screen_view` | `screen_name` | Any screen opened |
| `error_shown` | `error_code, screen` | Error displayed to user |

---

## Appendix D: Push Notification Types & Deep Links

| Type | Title Pattern | Body Pattern | Deep Link | Action |
|---|---|---|---|---|
| `payment_received` | "Payment received" | "UGX {amount} from {sender}" | `tisini://activity/transaction/{txId}` | Open transaction detail |
| `payment_completed` | "Payment sent" | "UGX {amount} to {payee}" | `tisini://activity/transaction/{txId}` | Open transaction detail |
| `payment_failed` | "Payment failed" | "Your payment to {payee} could not be processed" | `tisini://activity/transaction/{txId}` | Open transaction detail |
| `pia_card` | "Pia" | "{card.title}" | `tisini://pia/card/{cardId}` | Open Pia card |
| `pension_reminder` | "Pension reminder" | "Your contribution of UGX {amount} is due {date}" | `tisini://pay/pensions` | Open pension hub |
| `kyc_approved` | "Verified" | "Your identity has been verified" | `tisini://more/kyc/approved` | Open KYC approved |
| `kyc_failed` | "Verification update" | "Your verification needs attention" | `tisini://more/kyc/failed` | Open KYC failed |
| `import_complete` | "Import complete" | "{count} transactions imported" | `tisini://more/import/result/{jobId}` | Open import result |
| `payment_request` | "Payment request" | "{requester} requests UGX {amount}" | `tisini://pay/request/status/{reqId}` | Open request |

**Implementation:** Firebase Cloud Messaging. Parse deep link from notification data payload. GoRouter handles `tisini://` scheme links via `initialLink` and `onGenerateRoute`.

---

## Appendix E: Screen-to-Provider Mapping Matrix

| Screen # | Screen Name | Providers Used |
|---|---|---|
| 1-2 | Splash | `authStateProvider` |
| 3-6 | Onboarding | `onboardingProvider` |
| 7 | Login | `loginControllerProvider` |
| 8 | OTP | `loginControllerProvider` |
| 9 | Create PIN | `pinControllerProvider`, `biometricAvailableProvider` |
| 10 | Permissions | (platform APIs only) |
| 11 | Home | `userProvider`, `tisiniIndexProvider`, `piaGuidanceProvider`, `recentTransactionsProvider` |
| 12 | Dashboard | `tisiniIndexProvider`, `dashboardIndicatorsProvider`, `badgesProvider`, `piaGuidanceProvider` |
| 13 | Attention list | `attentionItemsProvider` |
| 14 | Insight detail | `insightDetailProvider` |
| 15 | Pay hub | `payHubProvider`, `recentPayeesProvider`, `payeeSearchProvider` |
| 16-21 | Send flow | `sendControllerProvider`, `payeeSearchProvider`, `paymentRoutesProvider` |
| 22-24 | Request flow | `requestControllerProvider` |
| 25-28 | Scan/Pay flow | `scanControllerProvider`, `paymentRoutesProvider` |
| 29-32 | Business pay | `businessPayControllerProvider`, `paymentRoutesProvider` |
| 33-36 | Top up | `topupControllerProvider` |
| 37 | Pension hub | `pensionStatusProvider`, `pensionHistoryProvider`, `pensionRemindersProvider` |
| 38-40 | Pension contribute | `pensionContributeControllerProvider`, `paymentRoutesProvider` |
| 41 | Pension history | `pensionHistoryProvider` |
| 42 | Pia feed | `piaFeedProvider` |
| 43 | Pia empty | `piaFeedProvider` |
| 44 | Pia card detail | `piaCardDetailProvider` |
| 45-46 | Pia action modals | `piaActionControllerProvider` |
| 47 | Pia pinned | `piaPinnedProvider` |
| 48 | Activity list | `transactionListProvider`, `transactionFiltersProvider` |
| 49 | Filters | `transactionFiltersProvider` |
| 50 | Transaction detail | `transactionDetailProvider`, `updateCategoryProvider`, `pinMerchantProvider` |
| 51-53 | Export flow | `exportControllerProvider` |
| 54 | More hub | `userProvider`, `kycStatusProvider` |
| 55 | Profile | `profileProvider` |
| 56 | Connected accounts | `connectedAccountsProvider` |
| 57 | Connect account | `connectedAccountsProvider` |
| 58 | Security settings | `securitySettingsProvider` |
| 59 | Notification settings | `notificationSettingsProvider` |
| 60 | Pinned merchants | `pinnedMerchantsProvider`, `updateMerchantRoleProvider` |
| 61 | Help/Support | (static content) |
| 62 | Legal/About | `featureFlagsProvider` |
| 63-67 | Import flow | `importControllerProvider`, `importMappingProvider`, `importJobStatusProvider` |
| 68-77 | KYC flow | `kycFlowProvider`, `kycCaptureControllerProvider`, `kycSubmissionStatusProvider` |

---

## Appendix F: Implementation Sprint Sequencing

### Sprint Plan (10 sprints, 2 weeks each)

| Sprint | Focus | Screens | Key Deliverables |
|---|---|---|---|
| **1** | Foundation | — | Project setup, architecture scaffolding, design system (`AppColors`, `AppTypography`, `AppTheme`), core infrastructure (`Dio`, `Drift`, `SecureStorage`, router shell), CI pipeline |
| **2** | Auth + Onboarding | 1-10 | Splash, onboarding carousel, login, OTP, PIN creation, biometrics, permissions, auth interceptor, token management |
| **3** | Home + Dashboard | 11-14 | Home screen, dashboard with tisini index ring, bar indicators, badges, attention list, Pia guidance card on home |
| **4** | Pay Hub + Send | 15-21 | Pay hub, full send flow (recipient → details → amount → confirm → receipt → failed), payee search, route selector, cost line, step-up verification |
| **5** | Pay Flows (Request, Scan, Business, Top Up) | 22-36 | Request flow, scan/pay flow, business template flow, top up flow, QR scanner, receipt template |
| **6** | Pensions | 37-41 | Pension hub, NSSF linking, contribution flow, pension history, pension appearing in Pay tab + Dashboard + Pia |
| **7** | Pia | 42-47 | Pia feed, card detail, action modals (reminder, schedule, confirm, pin), empty state, pinned items |
| **8** | Activity + Import | 48-53, 63-67 | Activity list, filters, transaction detail (edit category + pin merchant), export flow, bulk CSV import flow |
| **9** | More + KYC | 54-62, 68-77 | Settings hub, profile, connected accounts, security, notifications, merchants, help, legal, full KYC flow with camera capture |
| **10** | Polish + Testing | All | Integration tests for all 8 journeys, golden tests, performance optimization, offline behavior, push notifications, analytics, bug fixes |

### Sprint Dependencies

```
Sprint 1 (Foundation) ──▶ Sprint 2 (Auth) ──▶ Sprint 3 (Home)
                                                    │
                                                    ▼
                         Sprint 4 (Send) ◀──── Sprint 3
                              │
                              ▼
                         Sprint 5 (Pay Flows)
                              │
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
              Sprint 6    Sprint 7   Sprint 8
              (Pensions)  (Pia)      (Activity)
                    │         │         │
                    └─────────┼─────────┘
                              ▼
                         Sprint 9 (More + KYC)
                              │
                              ▼
                         Sprint 10 (Polish)
```

### Critical Path Items

1. **Auth interceptor** (Sprint 2) — blocks all authenticated screens
2. **Step-up verification** (Sprint 4) — blocks all payment confirmations
3. **PayeeCard + RouteChip + CostLine + ReceiptTemplate** (Sprint 4) — reused across all payment flows
4. **Pension in Pay tab** (Sprint 6) — key product requirement
5. **Transaction detail with categorisation** (Sprint 8) — feeds tisini index accuracy

---

*End of technical specification. This document should provide a Flutter developer with everything needed to build the tisini mobile app without guessing.*
