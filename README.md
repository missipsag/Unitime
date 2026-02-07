# Unitime

Unitime is a cross-platform Flutter mobile application designed as a unified platform for university students to manage their academic life, including class schedules, appointments, student groups, and promotional events.

## Demo Video

A short screen recording demonstrating core flows is included in the repository as [Unitime_screen_recording.mp4](Unitime_screen_recording.mp4).

Embedded demo (click the image to open on YouTube):

[![Unitime demo thumbnail](https://img.youtube.com/vi/l5Bsi4z_IQs/hqdefault.jpg)](https://youtube.com/shorts/l5Bsi4z_IQs)

Fallback link: https://youtube.com/shorts/l5Bsi4z_IQs

**Note:** GitHub may sanitize or block iframes in README views; the clickable thumbnail works reliably. To view locally:

```bash
# Linux
xdg-open Unitime_screen_recording.mp4

# macOS
open Unitime_screen_recording.mp4
```

## Project Overview

This application demonstrates production-ready software architecture and advanced Flutter development practices. The project implements a scalable MVVM architecture with clear separation of concerns, custom design patterns, and secure authentication mechanisms.

### Key Features

- **Calendar Management** — Multi-view calendar system (Month, Week, Day, Schedule) with recurrence rule support and color-coded appointment types
- **Appointment Management** — Create, edit, delete, and view class schedules, TDs, TPs, and special events
- **Student Groups** — Join and manage student groups with access codes
- **Academic Promotions** — Browse and manage campus promotions and promotional events
- **User Authentication** — Secure JWT-based authentication with platform-specific secure token storage
- **Multi-Platform Support** — Deploy across Android, iOS, Web, Windows, and macOS
- **Theme Customization** — Dark/Light/System mode support with Material Design 3
- **User Profiles & Settings** — Manage user information, preferences, and language selection

## Technical Architecture & Accomplishments

### Architecture & Design Patterns

- **MVVM Architecture** — Established a scalable structure with clear separation across UI, ViewModel, Repository, and Service layers, enabling maintainability and minimal coupling between components
- **Custom Result Type** — Implemented a discriminated union pattern (Result<Ok, Error>) for type-safe error handling throughout the data layer, eliminating null checks and exception-based control flow
- **Command Pattern** — Created a reusable async operation wrapper with state tracking (running, completed, error), enabling reactive UI updates and preventing concurrent execution issues
- **Singleton Pattern** — Used for repositories and services to maintain consistent state across the application

### Calendar Management

- **Multi-View Calendar System** — Integrated Syncfusion Flutter Calendar with custom appointment rendering across four view modes (Month, Week, Day, Schedule), supporting recurrence rules and flexible time slot customization
- **Custom Data Source Adapter** — Developed `UniAppointmentDataSource` that bridges the Syncfusion calendar widget with the application's data model, enabling real-time synchronization with color-coded appointment types (Courses, TDs, TPs, Special Events)
- **Dynamic Appointment Rendering** — Current time indicators, appointment duration display, and responsive view transitions

### Authentication & Security

- **JWT Token Management** — Engineered a JWT-based authentication system leveraging `flutter_secure_storage` for platform-specific secure credential persistence (Keychain on iOS, Keystore on Android)
- **Token Expiration Validation** — Implemented automated token expiration checking through JwtService, ensuring timely user re-authentication
- **Secure HTTP Communication** — Bearer token authorization in all protected API endpoints with proper error handling

### API Integration & Data Management

- **RESTful Backend Integration** — Connected to HTTP API with endpoints for authentication, appointments (CRUD), user profiles, groups, and promotions
- **Type-Safe Data Serialization** — Implemented JSON serialization/deserialization with factory constructors and pattern matching for safe data transformation between API responses and application models
- **Immutable Data Structures** — Used UnmodifiableListView for safe state exposure and prevented unintended external modifications

### State Management

- **ChangeNotifier-Based ViewModels** — Implemented reactive state management enabling automatic UI rebuilds when data changes with efficient widget re-rendering
- **Riverpod Integration** — Included flutter_riverpod as a dependency, positioning the project for future refactoring toward advanced provider-based patterns
- **Command State Tracking** — Operations expose running, completed, and error states for UI feedback (loading indicators, error messages)

### User Experience

- **Onboarding Flow** — Developed multi-step first-time user setup with promotion and group selection screens for streamlined initial experience
- **Reusable UI Components** — Built maintainable component library (CurrentEventWidget, ThemeSwitcher, UserProfileWidget, CustomListTile) enforcing design consistency
- **Multi-Theme Support** — Implemented Material Design 3 with Dark/Light/System modes, allowing user customization
- **Responsive Design** — Adaptive layouts supporting deployment across mobile, tablet, and desktop platforms

### Code Organization

- **Modular Architecture** — Organized 44+ Dart files across logical modules (data, service, repository, viewmodels, ui, core) for easy navigation and feature isolation
- **Clear File Structure** — Intuitive folder hierarchy making the codebase immediately understandable to new team members

## Technical Stack

- **Framework:** Flutter (SDK ^3.8.1) with Dart
- **State Management:** ChangeNotifier + Custom Command Pattern (flutter_riverpod for potential expansion)
- **UI Components:** Syncfusion Flutter Calendar v31.2.4, Material Design 3
- **Authentication:** JWT with flutter_secure_storage v9.2.4
- **Networking:** http v1.5.0 with Bearer token authorization
- **Utilities:** jwt_decoder v2.0.1, intl v0.20.2 for internationalization
- **Backend:** HTTP API on localhost:8080

## Getting Started

### Prerequisites

- Flutter stable channel ([install here](https://docs.flutter.dev/get-started/install))
- Android SDK for Android builds
- Xcode for iOS builds (macOS only)

### Installation

Clone and install dependencies:

```bash
git clone <your-repo-url>
cd Unitime
flutter pub get
```

### Running the Application

Run on a connected device or emulator:

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ipa
```

## Project Structure

```
lib/
├── main.dart                                    # App entry point & navigation
├── data/                                        # Data models & entities
│   ├── user.dart
│   ├── group.dart
│   ├── promotion.dart
│   ├── uni_appointment.dart
│   └── uni_appointment_data_source.dart
├── service/                                     # API & storage services
│   ├── authentication_service.dart
│   ├── user_service.dart
│   ├── uni_appointment_service.dart
│   ├── group_service.dart
│   ├── promotion_service.dart
│   ├── jwt_service.dart
│   └── storage_service.dart
├── repository/                                  # Data access abstraction
│   ├── authentication_repository.dart
│   ├── user_repository.dart
│   ├── uni_appointment_repository.dart
│   ├── group_repository.dart
│   ├── promotion_repository.dart
│   └── jwt_repository.dart
├── viewmodels/                                  # Presentation logic & state
│   ├── calendar_view_model.dart
│   └── feed_view_model.dart
├── ui/                                          # UI screens
│   ├── calendar_view.dart
│   ├── feed_view.dart
│   ├── profile_view.dart
│   ├── updates_view.dart
│   └── authentication/
│       ├── login_view.dart
│       └── register_view.dart
└── core/                                        # Utilities & constants
    ├── utils/
    │   ├── result.dart                          # Result type for error handling
    │   ├── command.dart                         # Async operation wrapper
    │   └── exceptions.dart                      # Custom exceptions
    ├── constants/                               # App constants & colors
    └── widgets/                                 # Reusable components
```

## API Endpoints

The application communicates with a backend HTTP API:

```
Authentication:
  POST /api/authentication/login
  POST /api/authentication/register

Appointments:
  GET /api/appointments/get
  GET /api/appointments/currentAppointments
  POST /api/appointments/create
  DELETE /api/appointments/delete

Users:
  GET /api/users/me
  PUT /api/users/edit

Groups:
  POST /api/groups/create
  POST /api/groups/get

Promotions:
  POST /api/promotions/get
  POST /api/promotions/create
  DELETE /api/promotions/delete
```

## What This Project Demonstrates

1. **Production-Ready Architecture** — Scalable, maintainable software design with clean separation of concerns
2. **Advanced Design Patterns** — Custom Result types, Command pattern, and Singleton pattern implementation
3. **Security Best Practices** — Platform-specific secure storage and JWT token management
4. **Cross-Platform Development** — Single codebase targeting multiple platforms
5. **Reactive Programming** — ChangeNotifier and reactive UI paradigms
6. **Third-Party Integration** — Effective integration of complex libraries (Syncfusion Calendar)
7. **User-Centered Design** — Thoughtful features including onboarding flows, theme customization, and comprehensive appointment management

