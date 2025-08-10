# Complete Flutter App Development Prompt for Astro Iztro

## Project Overview
Create a comprehensive Flutter app named "astro_iztro" that utilizes the dart_iztro package for Purple Star Astrology (Zi Wei Dou Shu) and BaZi calculations. This app should provide users with detailed astrological charts, analysis, and divination capabilities.

## Core Requirements

### 1. Project Setup
```yaml
# pubspec.yaml configuration
name: astro_iztro
description: A comprehensive Purple Star Astrology and BaZi calculation app
version: 1.0.0+1

dependencies:
  flutter:
    sdk: flutter
  dart_iztro: ^2.5.3
  get: ^4.6.6  # For state management and navigation
  shared_preferences: ^2.2.2  # For local data persistence
  intl: ^0.19.0  # For date formatting
  flutter_datetime_picker: ^1.5.1  # For date/time selection
  flutter_localizations:
    sdk: flutter
  cupertino_icons: ^1.0.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

### 2. App Architecture
- Use GetX pattern for state management
- Implement clean architecture with separate layers:
  - Presentation Layer (UI/Screens)
  - Domain Layer (Business Logic)
  - Data Layer (Services/Repositories)
- Multi-language support (English, Chinese Simplified/Traditional, Japanese, Korean, Thai, Vietnamese)

### 3. Core Features to Implement

#### A. User Input Screen
Create a comprehensive input form with:
- Birth date selection (both solar and lunar calendar support)
- Birth time selection with hour and minute precision
- Gender selection (Male/Female)
- Geographic location input with:
  - Manual latitude/longitude entry
  - Address lookup using GeoLookupService
- Calendar type toggle (Solar/Lunar with leap month handling)
- Language selection dropdown
- Form validation and error handling

#### B. BaZi Calculation Screen
Display calculated BaZi information including:
- Four Pillars (Year, Month, Day, Hour stems and branches)
- Five Elements analysis
- Chinese zodiac sign
- Western zodiac sign
- Formatted display with traditional Chinese characters
- Export/share functionality

#### C. Purple Star Astrology Chart Screen
Comprehensive chart display featuring:
- 12 Palaces visualization in traditional circular format
- Star positions with brightness indicators
- Transformation stars (化禄, 化权, 化科, 化忌)
- Palace analysis with detailed information
- Interactive palace selection for detailed view
- Color-coded star categories
- Zoom and pan functionality for better viewing

#### D. Detailed Analysis Screens
- Individual palace analysis with:
  - Stars present in each palace
  - Star meanings and interpretations
  - Transformation effects
  - Three harmony and four cardinal relationships
- Fortune cycle analysis:
  - Grand limit (大限)
  - Small limit (小限)
  - Annual fortune (流年)
  - Monthly, daily, hourly cycles
- Flying stars analysis between palaces

#### E. Settings & Preferences
- Language selection with real-time switching
- Theme selection (Light/Dark mode)
- Calculation preferences
- Data export/import options
- User profile management

### 4. UI/UX Design Requirements

#### Color Scheme & Theme
- Primary colors: Deep purple (#6B46C1) and gold (#F59E0B)
- Traditional Chinese aesthetic with modern Flutter Material Design
- Dark mode support with appropriate color adjustments
- Gradient backgrounds and subtle animations

#### Key UI Components
```dart
// Custom widgets to create:
- AstroChart: Circular 12-palace chart widget
- PalaceCard: Individual palace information display
- StarChip: Star representation with brightness and transformation indicators
- BaZiCard: Four pillars display widget
- DateTimePicker: Custom date/time selection with calendar support
- LanguageSelector: Multi-language dropdown
- AnalysisPanel: Expandable analysis information display
```

#### Navigation Structure
```
Home Screen
├── User Input
├── BaZi Analysis
├── Purple Star Chart
│   ├── Chart Overview
│   ├── Palace Details
│   └── Fortune Cycles
├── Detailed Analysis
│   ├── Palace Analysis
│   ├── Star Relationships
│   └── Fortune Timing
└── Settings
    ├── Language
    ├── Themes
    └── Preferences
```

### 5. Technical Implementation Details

#### State Management Structure
```dart
// Controllers to implement:
- UserInputController: Manages form data and validation
- ChartController: Handles chart calculations and display
- BaZiController: Manages BaZi calculations
- AnalysisController: Handles detailed analysis logic
- SettingsController: Manages app preferences
- LanguageController: Handles multi-language functionality
```

#### Key Services
```dart
// Services to create:
- IztroService: Wrapper for dart_iztro functionality
- StorageService: Local data persistence
- ExportService: Data export/sharing capabilities
- GeoService: Location and geographic calculations
- CalculationService: Core astrological calculations
```

#### Data Models
```dart
// Models to implement:
- UserProfile: User information and birth data
- ChartData: Purple star chart information
- BaZiData: Four pillars calculation results
- PalaceData: Individual palace information
- StarData: Star positions and properties
- FortuneData: Fortune cycle information
```

### 6. Advanced Features

#### A. True Solar Time Calculation
- Implement accurate solar time conversion using SolarTimeUtil
- Geographic location-based time corrections
- Display both standard time and true solar time

#### B. Chart Analysis Tools
- Palace relationship calculator
- Star brightness and transformation analyzer
- Flying stars between palaces
- Empty palace detection
- Three harmony and four cardinal position analysis

#### C. Fortune Timing
- Current fortune cycle highlighting
- Future fortune predictions
- Annual, monthly fortune overlays on main chart
- Timeline view for fortune cycles

#### D. Export & Sharing
- PDF export of complete charts
- Image export of chart visualizations
- Shareable analysis summaries
- Data backup and restore functionality

### 7. Error Handling & Validation

#### Input Validation
- Date range validation (reasonable birth date limits)
- Time format validation
- Geographic coordinate validation
- Required field checking

#### Error Handling
- Network error handling for geo lookups
- Calculation error handling
- User-friendly error messages in multiple languages
- Fallback options for failed operations

### 8. Performance Optimization
- Lazy loading for complex chart calculations
- Caching of frequently accessed data
- Optimized chart rendering for smooth performance
- Background calculation for heavy operations

### 9. Testing Requirements
- Unit tests for all calculation services
- Widget tests for custom UI components
- Integration tests for core user flows
- Validation tests for different birth data scenarios

### 10. Platform-Specific Considerations
- Responsive design for different screen sizes
- Platform-specific UI adaptations (iOS/Android)
- Proper handling of system themes
- Accessibility features implementation

## Implementation Notes

1. **Initialization**: Initialize IztroTranslationService at app startup
2. **State Persistence**: Save user inputs and preferences using SharedPreferences
3. **Chart Rendering**: Use CustomPainter for complex chart visualizations
4. **Language Support**: Implement GetX translations with dart_iztro's built-in language support
5. **Real-time Updates**: Update charts and analysis as users modify input parameters

## Code Structure
```
lib/
├── main.dart
├── app/
│   ├── bindings/
│   ├── modules/
│   │   ├── home/
│   │   ├── input/
│   │   ├── chart/
│   │   ├── bazi/
│   │   ├── analysis/
│   │   └── settings/
│   └── routes/
├── core/
│   ├── services/
│   ├── models/
│   ├── utils/
│   └── constants/
├── shared/
│   ├── widgets/
│   ├── themes/
│   └── translations/
└── assets/
    ├── images/
    ├── icons/
    └── fonts/
```

This comprehensive Flutter app should provide users with a professional-grade Purple Star Astrology calculation and analysis tool, leveraging all the powerful features of the dart_iztro package while maintaining an intuitive and beautiful user interface.