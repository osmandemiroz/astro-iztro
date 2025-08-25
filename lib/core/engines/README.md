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

### 6. AstroMatcherEngine (`astro_matcher_engine.dart`)
- **Purpose**: Astrological compatibility analysis
- **Features**:
  - Sun sign compatibility calculations
  - Element compatibility analysis
  - Timing and life cycle compatibility
  - Relationship type classification
  - Personalized recommendations
  - Traditional astrological rules

### 7. TarotResponseEngine (`tarot_response_engine.dart`)
- **Purpose**: Intelligent tarot reading and interpretation
- **Features**:
  - Question intent analysis and categorization
  - Contextual card interpretation based on user questions
  - Card relationship and pattern analysis
  - Actionable guidance generation
  - Timing insights and optimal action periods
  - Emotional tone and energy balance analysis
  - Position-based interpretations for multi-card spreads
  - Category-specific insights (love, career, finance, etc.)

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

// Astrological compatibility
final compatibilityData = await iztroService.calculateAstroCompatibility(profile1, profile2);
```

## Migration from RapidAPI

The app has been completely migrated from RapidAPI to native engines:
- ✅ Added: Native calculation engines
- ✅ Updated: All controllers to use native engines
- ✅ Enhanced: Calculation accuracy and reliability
- ✅ Added: Astro Matcher compatibility engine

## Technical Details

- **Language**: Dart/Flutter
- **Architecture**: Static methods for easy testing and integration
- **Error Handling**: Comprehensive try-catch blocks with detailed logging
- **Performance**: Optimized calculations with minimal memory usage
- **Extensibility**: Easy to add new calculation methods or modify existing ones

## Future Enhancements

✅ **Lunar Calendar Integration** - More accurate calculations
- `LunarCalendarEngine` - Native lunar date and moon phase calculations
- Julian Day Number calculations for astronomical precision
- Solar term considerations for seasonal accuracy
- Leap month detection and handling

✅ **Performance Optimization** - Caching and memoization
- `PerformanceEngine` - Intelligent caching and performance monitoring
- Calculation result caching with expiration
- Memoization for expensive, deterministic calculations
- Performance metrics and analytics
- Cache preloading for common calculations

✅ **Advanced Star Positioning** - Sophisticated algorithms
- `AdvancedStarEngine` - Advanced star positioning with precision
- Minute-level time branch calculations
- Seasonal adjustments based on latitude
- Solar term considerations for month branches
- Star interaction analysis and palace calculations

✅ **Enhanced Compatibility Analysis** - Advanced relationship insights
- `EnhancedCompatibilityEngine` - Relationship timing predictions
- Compatibility trend analysis over time
- Personal timing cycle calculations
- Optimal timing windows for decisions
- Synergy scoring and energy level analysis

## New Engine Capabilities

### Lunar Calendar Engine
- **Lunar Date Conversion**: Solar to lunar calendar conversion
- **Moon Phase Calculation**: Accurate moon phase and age calculations
- **Lunar Elements**: Traditional Chinese element calculations for lunar dates
- **Moon Timing**: Approximate moon rise and set times

### Performance Engine
- **Smart Caching**: Intelligent cache with expiration management
- **Memoization**: Persistent storage for expensive calculations
- **Performance Tracking**: Detailed metrics and analytics
- **Cache Optimization**: Automatic cleanup and preloading

### Advanced Star Engine
- **Precise Timing**: Minute-level time branch calculations
- **Seasonal Adjustments**: Latitude-based seasonal corrections
- **Solar Terms**: Traditional Chinese solar term integration
- **Star Interactions**: Advanced star combination and conflict analysis

### Enhanced Compatibility Engine
- **Relationship Timing**: Optimal timing for relationship milestones
- **Trend Analysis**: Compatibility changes over time
- **Personal Cycles**: Life period and energy level calculations
- **Synergy Scoring**: Relationship synergy and timing alignment

### Tarot Response Engine
- **Question Intelligence**: Automatic categorization and emotional tone analysis
- **Contextual Interpretation**: Position-based and category-specific card meanings
- **Pattern Recognition**: Card relationship analysis and energy balance calculation
- **Actionable Guidance**: Specific actions, affirmations, and focus areas
- **Timing Insights**: Lunar cycles, seasonal timing, and optimal action periods
- **Multi-Spread Support**: Single card, three card, Celtic Cross, and custom spreads

## Implementation Status

- ✅ **Completed**: All future enhancement engines implemented
- ✅ **Production Ready**: Comprehensive error handling and validation
- ✅ **Native Implementation**: No external dependencies required
- ✅ **Performance Optimized**: Caching and memoization included
- ✅ **Extensible**: Easy to add new calculation methods
- ✅ **Tarot Integration**: Intelligent response engine for contextual readings

## Usage Examples

```dart
// Lunar calendar calculations
final lunarData = await LunarCalendarEngine.calculateLunarDate(
  solarDate: DateTime.now(),
  latitude: 40.7128,
  longitude: -74.0060,
);

// Performance optimized calculations
final result = PerformanceEngine.optimizeCalculation(
  operationName: 'bazi_calculation',
  parameters: {'birthDate': birthDate, 'gender': gender},
  calculation: () => BaZiEngine.calculateBaZi(...),
);

// Advanced star positioning
final advancedStars = await AdvancedStarEngine.calculateAdvancedStarPositions(
  birthDate: birthDate,
  birthHour: birthHour,
  birthMinute: birthMinute,
  gender: gender,
  latitude: latitude,
  longitude: longitude,
  useTrueSolarTime: true,
);

// Enhanced compatibility analysis
final timing = await EnhancedCompatibilityEngine.calculateRelationshipTiming(
  profile1: profile1,
  profile2: profile2,
  targetYear: 2024,
);

final trends = await EnhancedCompatibilityEngine.analyzeCompatibilityTrends(
  profile1: profile1,
  profile2: profile2,
  startYear: 2020,
  endYear: 2030,
);

// Tarot reading and interpretation
final tarotReading = TarotResponseEngine.generateContextualReading(
  question: 'Will I find love this year?',
  selectedCards: selectedCards,
  readingType: 'three_card',
);

// Extract insights from the reading
final questionAnalysis = tarotReading['questionAnalysis'];
final contextualInterpretation = tarotReading['contextualInterpretation'];
final actionableGuidance = tarotReading['guidance'];
final timingInsights = tarotReading['timingInsights'];
```
