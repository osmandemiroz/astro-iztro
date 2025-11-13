<div align="center">

# ✨ Astro Iztro

### *Ancient Wisdom Meets Modern Technology*

A sophisticated Flutter application delivering comprehensive Purple Star Astrology (紫微斗数) readings, BaZi analysis, and intelligent Tarot interpretations with stunning Apple-inspired UI/UX.

[![Flutter](https://img.shields.io/badge/Flutter-3.6.1+-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.6.1+-0175C2?style=flat&logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey.svg)](https://github.com/osmandemiroz/astro-iztro)

[Features](#-key-features) • [Installation](#-quick-start) • [Architecture](#-architecture) • [Documentation](#-documentation) • [Contributing](#-contributing)

---

</div>

## 🌟 Overview

**Astro Iztro** is a production-ready mobile application that brings the ancient wisdom of Chinese astrology to modern devices. Built with Flutter and powered by native calculation engines, it provides authentic Purple Star Astrology (Zi Wei Dou Shu 紫微斗数) readings, Four Pillars BaZi analysis, and an intelligent Tarot interpretation system—all completely offline with no API keys required.

### Why Astro Iztro?

- 🎯 **Authentic Calculations**: Traditional Chinese astrology algorithms implemented natively
- 🔒 **100% Offline**: All computations happen locally—your data stays private
- 🎨 **Beautiful Design**: Apple Human Interface Guidelines-inspired UI with smooth animations
- 🌍 **Truly International**: Full support for English, Turkish, Chinese, and Japanese
- 🏗️ **Production Ready**: Clean architecture with comprehensive error handling
- ⚡ **High Performance**: Optimized engines for instant chart generation

---

## 🚀 Key Features

<table>
<tr>
<td width="50%">

### 📊 Purple Star Astrology
- **Complete Astrolabe Generation**
  - 14 main stars + auxiliary stars
  - 12 palaces (life aspects)
  - Destiny analysis & predictions
- **Palace Deep Dive**
  - Detailed palace interpretations
  - Star influence analysis
  - Life aspect insights
- **Visual Chart Display**
  - Interactive astrology charts
  - Beautiful gradient backgrounds
  - Smooth, fluid animations

</td>
<td width="50%">

### 🎴 Intelligent Tarot System
- **Advanced Reading Engine**
  - Context-aware interpretations
  - Question categorization
  - Emotional tone analysis
- **Multiple Spread Types**
  - Single card readings
  - Three card spreads
  - Celtic Cross layouts
  - Custom configurations
- **Actionable Insights**
  - Specific guidance & affirmations
  - Timing recommendations
  - Lunar cycle integration

</td>
</tr>
<tr>
<td width="50%">

### 🔢 BaZi (Four Pillars)
- **Comprehensive Analysis**
  - Year, Month, Day, Hour pillars
  - Heavenly Stems & Earthly Branches
  - Hidden Stems calculations
- **Element Analysis**
  - Five Elements balance
  - Strength assessments
  - Elemental interactions
- **Fortune Cycles**
  - 10-year luck periods
  - Annual influences
  - Timing predictions

</td>
<td width="50%">

### 🌐 Localization & UX
- **Multi-Language Support**
  - 🇺🇸 English (professional terminology)
  - 🇹🇷 Turkish (culturally adapted)
  - 🇨🇳 Chinese (traditional characters)
  - 🇯🇵 Japanese (proper context)
- **Modern UI/UX**
  - Apple-inspired aesthetics
  - Liquid glass effects
  - Responsive layouts
  - Accessibility-first design

</td>
</tr>
</table>

---

## 🏗️ Architecture

### **Clean Architecture Principles**

```
lib/
├── app/                          # Application Layer
│   ├── modules/                  # Feature Modules (GetX Pattern)
│   │   ├── analysis/            # Astrology Analysis Views
│   │   ├── astro_matcher/       # Compatibility Analysis
│   │   ├── bazi/                # BaZi Four Pillars
│   │   ├── chart/               # Astrology Chart Display
│   │   ├── tarot/               # Tarot Reading System
│   │   └── ...
│   ├── routes/                   # Navigation & Routing
│   └── bindings/                 # Dependency Injection
│
├── core/                         # Business Logic Layer
│   ├── engines/                  # Native Calculation Engines
│   │   ├── purple_star_engine.dart      # Purple Star calculations
│   │   ├── bazi_engine.dart             # Four Pillars BaZi
│   │   ├── element_engine.dart          # Five Elements analysis
│   │   ├── fortune_engine.dart          # Fortune cycles & timing
│   │   ├── tarot_response_engine.dart   # Intelligent Tarot
│   │   ├── lunar_calendar_engine.dart   # Lunar calendar conversions
│   │   └── ...
│   ├── models/                   # Data Models
│   ├── services/                 # Core Services
│   │   ├── iztro_service.dart           # Astrology service layer
│   │   ├── language_service.dart        # i18n management
│   │   ├── storage_service.dart         # Persistent storage
│   │   └── validation_service.dart      # Input validation
│   └── constants/                # App Constants
│
├── shared/                       # Shared UI Layer
│   ├── themes/                   # App Themes (Dark/Light)
│   └── widgets/                  # Reusable UI Components
│       ├── astro_chart_widget.dart
│       ├── liquid_glass_widget.dart
│       ├── enhanced_tarot_reading_widget.dart
│       └── ...
│
└── l10n/                         # Internationalization
    ├── app_en.arb               # English translations
    ├── app_tr.arb               # Turkish translations
    ├── app_zh.arb               # Chinese translations
    └── app_ja.arb               # Japanese translations
```

### **Core Calculation Engines**

| Engine | Purpose | Key Features |
|--------|---------|--------------|
| **PurpleStarEngine** | Zi Wei Dou Shu calculations | Star positioning, palace generation, destiny analysis |
| **BaZiEngine** | Four Pillars analysis | Stem/Branch calculation, element strength, hidden stems |
| **ElementEngine** | Five Elements system | Balance analysis, element interactions, strength scores |
| **FortuneEngine** | Timing & cycles | 10-year luck periods, annual influences, monthly trends |
| **TarotResponseEngine** | Intelligent readings | Context analysis, pattern recognition, actionable guidance |
| **LunarCalendarEngine** | Date conversions | Solar-to-lunar conversion, Chinese calendar calculations |
| **TimingEngine** | Life cycle analysis | Age-based predictions, optimal timing recommendations |

---

## 💻 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: `>=3.6.1`
- **Dart SDK**: `>=3.6.1 <4.0.0`
- **IDE**: VS Code, Android Studio, or IntelliJ with Flutter plugins
- **For iOS**: Xcode 14+ (macOS only)
- **For Android**: Android SDK 21+ (minimum API level)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/osmandemiroz/astro-iztro.git
cd astro-iztro

# 2. Install dependencies
flutter pub get

# 3. Run the app (debug mode)
flutter run

# 4. Or run on specific device
flutter run -d <device_id>
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS + Xcode)
flutter build ios --release

# Or create IPA for distribution
flutter build ipa --release
```

### Development Scripts

```bash
# Run with specific language
flutter run --dart-define=INIT_LANG=zh

# Run tests
flutter test

# Analyze code quality
flutter analyze

# Format code
dart format lib/

# Generate app icons
flutter pub run flutter_launcher_icons
```

---

## 📚 Documentation

### What is Purple Star Astrology?

**Purple Star Astrology** (紫微斗数, *Zi Wei Dou Shu*) is one of the most sophisticated and accurate forms of Chinese astrology, developed over 1,000 years ago during the Song Dynasty. Unlike Western astrology which focuses on sun signs, Purple Star Astrology uses:

- **Birth Date & Time**: Precise calculations based on lunar calendar
- **12 Palaces**: Life, Siblings, Spouse, Children, Wealth, Health, Travel, Career, Property, Fortune, Parents, and Self
- **14 Major Stars**: Including Purple Star (紫微), Celestial Prime (天机), Sun (太阳), Moon (太阴), and more
- **Auxiliary Stars**: Additional stars that refine predictions and insights
- **Complex Algorithms**: Authentic traditional calculation methods

### BaZi (Four Pillars of Destiny)

**BaZi** (八字, *Eight Characters*) is another cornerstone of Chinese metaphysics:

- **Four Time Pillars**: Year, Month, Day, and Hour of birth
- **Eight Characters**: Each pillar has a Heavenly Stem and Earthly Branch
- **Five Elements**: Wood, Fire, Earth, Metal, Water interactions
- **10-Year Luck Cycles**: Major life period influences
- **Hidden Stems**: Reveals underlying energies and potential

### Tarot Intelligence System

Our **Tarot Response Engine** goes beyond basic card meanings:

- **Question Analysis**: Categorizes questions (love, career, spiritual, etc.)
- **Emotional Tone Detection**: Understands the querent's emotional state
- **Pattern Recognition**: Analyzes card relationships and energy flows
- **Contextual Interpretation**: Tailors meanings to your specific situation
- **Actionable Guidance**: Provides specific steps, affirmations, and focus areas
- **Timing Insights**: Integrates lunar cycles and seasonal energies

---

## 🌍 Internationalization

### Supported Languages

| Language | Code | Status | Features |
|----------|------|--------|----------|
| English | `en_US` | ✅ Complete | Professional astrological terminology |
| Turkish | `tr_TR` | ✅ Complete | Culturally adapted translations |
| Chinese (Simplified) | `zh_CN` | ✅ Complete | Traditional characters & authentic terms |
| Japanese | `ja_JP` | ✅ Complete | Proper context & honorifics |

### Language Features

- **Dynamic Switching**: Change language instantly without restart
- **Persistent Selection**: App remembers your preference
- **Complete Coverage**: 100% of UI elements translated
- **Specialized Terminology**: Accurate astrological & metaphysical terms
- **Cultural Adaptation**: Explanations adjusted for cultural context
- **RTL Support**: Ready for future RTL language additions

---

## 🎨 Design Philosophy

### Apple Human Interface Guidelines

Following Apple's design principles for a premium experience:

- **Clarity**: Clean typography, ample whitespace, purposeful UI elements
- **Deference**: Content takes center stage with subtle, beautiful interface
- **Depth**: Visual layers and realistic motion provide hierarchy and vitality

### Visual Design

- **Dark Theme**: Mystical, immersive experience with gradient backgrounds
- **Liquid Glass Effects**: Modern glassmorphism for depth and elegance
- **Smooth Animations**: 60fps transitions following natural motion curves
- **Typography**: Carefully selected fonts for readability and aesthetic appeal
  - **SFProDisplay** (Raleway): Clean, modern UI text
  - **CinzelDecorative**: Elegant headings with mystical feel
  - **TenorSans**: Readable body text
  - **MaShanZheng**: Authentic Chinese calligraphy style

### Responsive Design

- **Adaptive Layouts**: Optimized for phones and tablets
- **Portrait-First**: Designed for natural mobile usage
- **Edge-to-Edge**: Immersive full-screen experience
- **Safe Areas**: Respects notches and system UI

---

## 🛠️ Technology Stack

### Core Technologies

- **Framework**: Flutter 3.6.1+ (Cross-platform mobile development)
- **Language**: Dart 3.6.1+ (Modern, type-safe, high-performance)
- **State Management**: GetX 4.6.6 (Reactive, lightweight, powerful)
- **Storage**: SharedPreferences (Local data persistence)
- **Internationalization**: Flutter i18n + ARB files

### Key Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management, routing, dependency injection |
| `intl` | Internationalization and date formatting |
| `flutter_localizations` | Localization support |
| `shared_preferences` | Local storage for settings & data |
| `flutter_datetime_picker_plus` | Beautiful date/time pickers |
| `flutter_map` | Location selection for birth data |
| `latlong2` | Geographic coordinate handling |
| `cached_network_image` | Optimized image loading |

### Development Tools

- **Code Quality**: `very_good_analysis`, `flutter_lints`
- **Testing**: `flutter_test`
- **Icons**: `flutter_launcher_icons`
- **Code Organization**: Clean architecture patterns

---

## 📖 Usage Guide

### Creating Your Astrology Chart

1. **Launch the App**: Opens to an elegant onboarding experience
2. **Enter Birth Data**:
   - Date of birth (solar calendar)
   - Exact time of birth (critical for accuracy)
   - Place of birth (for timezone and location)
3. **Generate Chart**: Instant calculation and visualization
4. **Explore Analysis**:
   - View your 12-palace chart
   - Read detailed interpretations
   - Explore star influences
   - Check fortune cycles

### Getting a Tarot Reading

1. **Navigate to Tarot**: Tap the Tarot card icon
2. **Focus Your Question**: Think clearly about what you seek guidance on
3. **Select Spread Type**:
   - **Single Card**: Quick insight or daily guidance
   - **Three Card**: Past-Present-Future or Situation-Action-Outcome
   - **Celtic Cross**: Comprehensive 10-card spread
4. **Draw Cards**: Tap to reveal your cards
5. **Receive Interpretation**: Read contextual insights, guidance, and timing
6. **Take Action**: Follow suggested steps and affirmations

### BaZi Analysis

1. **Access BaZi Module**: From main menu or analysis section
2. **View Your Four Pillars**: See your complete BaZi chart
3. **Element Analysis**: Check your Five Elements balance
4. **Fortune Cycles**: Explore your 10-year luck periods
5. **Understand Influences**: Learn about current and upcoming energies

### Compatibility Matching

1. **Enter Two Birth Profiles**: Your data and partner's data
2. **Generate Analysis**: Calculate compatibility scores
3. **Review Results**: See strengths and challenges
4. **Read Guidance**: Get advice for harmonious relationships

---

## 🧪 Testing & Quality

### Code Quality Standards

- ✅ **Very Good Analysis**: Enforces best practices and style
- ✅ **Flutter Lints**: Official Flutter linting rules
- ✅ **Type Safety**: Strict null safety throughout
- ✅ **Clean Architecture**: Separation of concerns, SOLID principles
- ✅ **Comprehensive Comments**: Well-documented codebase

### Performance Optimizations

- **Lazy Loading**: Controllers and services loaded as needed
- **Efficient State Management**: GetX with reactive updates only when necessary
- **Image Caching**: Network images cached for fast loading
- **Memory Management**: Proper disposal of resources
- **Native Calculations**: All engines optimized for speed

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### How to Contribute

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/astro-iztro.git
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make Your Changes**
   - Follow existing code style and architecture
   - Add comments for complex logic
   - Update documentation as needed

4. **Test Thoroughly**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit Your Changes**
   ```bash
   git commit -m "Add: Amazing new feature with detailed description"
   ```

6. **Push to Your Fork**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open a Pull Request**
   - Describe your changes clearly
   - Reference any related issues
   - Include screenshots for UI changes

### Contribution Guidelines

- **Code Style**: Follow Dart style guide and project conventions
- **Architecture**: Maintain clean architecture patterns
- **Testing**: Include tests for new features
- **Documentation**: Update README and code comments
- **Commits**: Use clear, descriptive commit messages
- **Issues**: Check existing issues before creating new ones

### Areas for Contribution

- 🌍 **New Language Translations**: Add support for more languages
- 🎨 **UI/UX Improvements**: Enhance visual design and user experience
- 🔧 **New Features**: Implement additional astrology systems
- 📚 **Documentation**: Improve guides and explanations
- 🐛 **Bug Fixes**: Report and fix issues
- ⚡ **Performance**: Optimize calculations and rendering

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for full details.

```
MIT License

Copyright (c) 2024 Osman Demiroz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

[Full license text in LICENSE file]
```

---

## 🙏 Acknowledgments

### Core Technologies

- **Flutter & Dart**: Google's excellent cross-platform framework
- **GetX**: Reactive state management by Jonny Borges
- **Flutter Community**: Invaluable packages and support

### Astrological Knowledge

- **Traditional Chinese Astrology**: Centuries of accumulated wisdom
- **Zi Wei Dou Shu Masters**: Ancient and modern practitioners
- **BaZi Experts**: Classical Four Pillars methodology
- **Tarot Tradition**: Rich symbolic system spanning cultures

### Development

- **Clean Architecture**: Robert C. Martin's software design principles
- **Apple Human Interface Guidelines**: Premium UX/UI standards
- **Open Source Community**: Inspiration and collaboration

---

## 📞 Support & Contact

### Get Help

- 🐛 **Bug Reports**: [Open an issue](https://github.com/osmandemiroz/astro-iztro/issues)
- 💡 **Feature Requests**: [Submit an idea](https://github.com/osmandemiroz/astro-iztro/discussions)
- 📖 **Documentation**: Check this README and code comments
- 💬 **Discussions**: [Join the conversation](https://github.com/osmandemiroz/astro-iztro/discussions)

### Useful Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [GetX Documentation](https://pub.dev/packages/get)
- [Purple Star Astrology Background](https://en.wikipedia.org/wiki/Zi_Wei_Dou_Shu)

---

## 🌟 Star History

If you find this project useful, please consider giving it a star ⭐ on GitHub!

---

<div align="center">

### Built with ❤️ using Flutter

**Astro Iztro** • Ancient Wisdom • Modern Technology

*For entertainment and educational purposes. Use responsibly.*

---

**Made by [Osman Demiroz](https://github.com/osmandemiroz)**

</div>
