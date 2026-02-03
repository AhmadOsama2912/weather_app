# Weather App — Task Submission

A clean, modern **Flutter Weather Application** built as a technical task submission.
The app delivers a polished (Apple-inspired) UI, supports **Dark/Light themes**, **English/Arabic localization (RTL)**, and fetches real forecast data using a scalable architecture (**BLoC + Repository pattern**).

> **Design Note:** Since no official UI/UX design was provided for this task, the visual direction is inspired by the iOS Weather application (minimal, card-based layout) as a reference for a clean and modern experience.

---

## ✨ Features

- ✅ Current Weather: temperature, feels-like, min/max, condition
- ✅ Hourly Forecast strip
- ✅ Daily Forecast list
- ✅ Metrics grid: wind, gusts, humidity, pressure, visibility, UV index, sunrise/sunset
- ✅ City Search
- ✅ “Use My Location”
- ✅ Refresh (re-fetch data)
- ✅ Dark / Light theme toggle
- ✅ Localization: English (EN) / Arabic (AR) + RTL support
- ✅ Modern UI using glass-style cards + adaptive colors

---

## 🧱 Architecture

This project follows a scalable and testable structure:

- **Presentation Layer:** Pages + Widgets + UI state rendering
- **State Management:** `flutter_bloc` (Cubit/BLoC)
- **Data Layer:** Repository pattern (API + storage)
- **Domain Models:** Typed models (e.g., `WeatherBundle`, `DailyPoint`, `HourlyPoint`)

**Benefits**
- Separation of concerns
- Clean dependency direction: UI → Cubit → Repository → API/Storage
- Easy extension: caching, new screens, more providers

---

## 🧰 Tech Stack

- **Flutter / Dart**
- **State Management:** `flutter_bloc`, `bloc`, `equatable`
- **Networking:** `dio`
- **Storage:** `shared_preferences` (theme + locale + last city)
- **Location:** `geolocator` + `geocoding`
- **Localization:** `flutter_localizations` + `gen-l10n` (ARB-based)
- **Formatting:** `intl`

---

## 🌍 Localization (EN / AR)

Supported languages:
- English (`en`)
- Arabic (`ar`) with RTL layout support

Localization files:
- `assets/l10n/app_en.arb`
- `assets/l10n/app_ar.arb`

Generation:
- `flutter: generate: true`

---

## 🎨 Themes (Dark / Light)

The UI adapts correctly to both themes by:
- Relying on `Theme.of(context).colorScheme`
- Avoiding hard-coded `Colors.white` / `Colors.black` in UI widgets
- Using an adaptive background widget to maintain readability in both modes

---

## ▶️ How to Run (Debug)

```bash
flutter pub get
flutter run
