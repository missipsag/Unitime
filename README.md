# Unitime

Unitime — a Flutter mobile app to help university students manage campus life: schedules, groups, appointments, promotions, and more.

**Key features**

- Organize class schedules and appointments
- Join and manage student groups
- Browse campus promotions and events
- Lightweight, offline-capable data storage
- Clean, responsive Flutter UI for mobile

## Demo Video

A short screen recording demonstrating core flows is included in the repository as [Unitime_screen_recording.mp4](Unitime_screen_recording.mp4).

Embedded preview (controls available):

<video controls width="720" poster="">
	<source src="./Unitime_screen_recording.mp4" type="video">
	Your browser does not support the video tag. Download the video directly: <a href="Unitime_screen_recording.mp4">Unitime_screen_recording.mp4</a>
</video>

If the embedded player does not display on your platform (GitHub may sanitize HTML in some views), open the file locally:

Linux:

```
xdg-open Unitime_screen_recording.mp4
```

macOS:

```
open Unitime_screen_recording.mp4
```

Or play in your preferred media player.

## Getting Started

Prerequisites:

- Install Flutter (stable channel). See https://docs.flutter.dev/get-started/install
- Android SDK for Android builds; Xcode for iOS builds (macOS only)

Clone and install dependencies:

```
git clone <your-repo-url>
cd Unitime
flutter pub get
```

Run on a connected device or emulator:

```
flutter run
```

To run on a specific device (list devices first):

```
flutter devices
flutter run -d <device-id>
```

Build release APK (Android):

```
flutter build apk --release
```

Build iOS (macOS):

```
flutter build ipa
```

## Project Structure

- `lib/` — main Flutter source code
	- `core/` — constants, utils, widgets
	- `data/` — models and local data sources
	- `repository/` — repositories that provide data to viewmodels
	- `service/` — services for API, storage, authentication
	- `ui/` — views/screens
	- `viewmodels/` — state management and business logic
- `assets/` — images and static assets
- `android/`, `ios/`, `web/`, `linux/`, `windows/`, `macos/` — platform projects
- `test/` — unit and widget tests

## Configuration

- App-level configuration (API endpoints, feature flags) is in `lib/core/constants`.
- Secure storage is implemented via `flutter_secure_storage` for tokens.

## Running Tests

```
flutter test
```

## Contributing

Contributions are welcome. Please open issues or pull requests describing proposed changes. Keep changes focused and provide tests where appropriate.

## Notes

- If `Unitime_screen_recording.mp4` is not present in the repo root, please add it to the repository (root or `assets/`) and update the path in this README accordingly.

## Contact

For questions or help, open an issue in this repository.

---
Generated README for developer onboarding and users.
