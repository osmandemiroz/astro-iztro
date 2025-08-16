# Native Calculation Engines

This directory contains native calculation engines that provide comprehensive astrological calculations without external dependencies.

## Engines Overview

### 1. PurpleStarEngine (`purple_star_engine.dart`)
- **Purpose**: Core Purple Star Astrology calculations
- **Features**: 
  - Palace calculations
  - Star positioning
  - Chart generation
  - Native implementation with no external API calls

### 2. BaZiEngine (`bazi_engine.dart`)
- **Purpose**: Four Pillars BaZi calculations
- **Features**:
  - Year, Month, Day, Hour pillar calculations
  - Element distribution analysis
  - Day master strength analysis
  - Hidden stem calculations
  - Traditional Chinese time system

### 3. FortuneEngine (`fortune_engine.dart`)
- **Purpose**: Fortune and timing calculations
- **Features**:
  - Life period analysis
  - Grand limit and small limit cycles
  - Annual, monthly, and daily fortune
  - Element influences
  - Seasonal and lunar phase analysis

### 4. ElementEngine (`element_engine.dart`)
- **Purpose**: Five Elements analysis and balance
- **Features**:
  - Element distribution calculation
  - Day master strength analysis
  - Element relationships and compatibility
  - Balance recommendations
  - Personalized element advice

### 5. TimingEngine (`timing_engine.dart`)
- **Purpose**: Timing cycles and fortune periods
- **Features**:
  - Life cycle calculations
  - Fortune timing cycles
  - Seasonal influences
  - Lunar phase influences
  - Daily timing patterns

## Benefits of Native Engines

✅ **No External Dependencies**: All calculations performed locally
✅ **No API Keys Required**: Eliminates need for RapidAPI or other external services
✅ **Faster Performance**: No network latency or API rate limits
✅ **Reliable**: Works offline and doesn't depend on external service availability
✅ **Authentic**: Implements traditional Chinese astrology algorithms
✅ **Production Ready**: Comprehensive error handling and validation

## Usage

All engines are integrated through the `IztroService` which provides a unified interface:

```dart
// BaZi calculations
final baziData = await iztroService.calculateBaZi(profile);

// Fortune calculations
final fortuneData = await iztroService.calculateFortuneForYear(profile, 2024);

// Element analysis
final elementAnalysis = await iztroService.analyzeElementBalance(profile, elementCounts, dayMaster);

// Timing cycles
final timingData = await iztroService.calculateTimingCycles(profile, 2024);
```

## Migration from RapidAPI

The app has been completely migrated from RapidAPI to native engines:
- ❌ Removed: `RapidApiService` and `RapidApiTester`
- ✅ Added: Native calculation engines
- ✅ Updated: All controllers to use native engines
- ✅ Enhanced: Calculation accuracy and reliability

## Technical Details

- **Language**: Dart/Flutter
- **Architecture**: Static methods for easy testing and integration
- **Error Handling**: Comprehensive try-catch blocks with detailed logging
- **Performance**: Optimized calculations with minimal memory usage
- **Extensibility**: Easy to add new calculation methods or modify existing ones

## Future Enhancements

- Lunar calendar integration for more accurate calculations
- Advanced star positioning algorithms
- Customizable calculation parameters
- Performance optimization for complex charts
- Additional traditional astrology methods
