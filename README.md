# Astro Iztro

A Flutter application for generating and displaying Purple Star Astrology (Zi Wei Dou Shu) astrolabes, an ancient Chinese astrological system.

## 📱 About

Astro Iztro is a mobile application built with Flutter that provides users with comprehensive Purple Star Astrology readings and chart generation. The app leverages the power of the iztro library to deliver accurate astrological calculations and interpretations based on traditional Chinese astrology principles.

## ✨ Features

- **Astrolabe Generation**: Create detailed Purple Star Astrology charts
- **Horoscope Analysis**: Get personalized horoscope readings and personality analysis
- **Multi-language Support**: Available in multiple languages
- **Cross-platform**: Runs on both iOS and Android devices
- **Traditional Chinese Astrology**: Based on the authentic Zi Wei Dou Shu system
- **User-friendly Interface**: Clean and intuitive mobile UI design

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=2.0.0)
- Dart SDK (>=2.12.0)
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/osmandemiroz/astro-iztro.git
   cd astro-iztro
   ```

2. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Then edit the `.env` file and add your API keys:
   ```
   RAPIDAPI_KEY=your_rapidapi_key_here
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📚 What is Purple Star Astrology (Zi Wei Dou Shu)?

Purple Star Astrology, also known as Zi Wei Dou Shu (紫微斗数), is one of the most sophisticated forms of Chinese astrology. It uses:

- Birth date and time to generate a personalized astrolabe
- 14 main stars and numerous auxiliary stars
- 12 palaces representing different life aspects
- Complex calculations to determine personality traits and life predictions

## 🛠 Technical Details

This Flutter application integrates with astrology calculation libraries to provide:

- Real-time astrolabe generation
- Accurate birth chart calculations
- Personality analysis based on star positions
- Traditional Chinese calendar support

## 📖 Usage

1. **Input Birth Information**: Enter your birth date, time, and location
2. **Generate Astrolabe**: The app calculates your Purple Star Astrology chart
3. **View Analysis**: Read detailed personality insights and predictions
4. **Explore Features**: Navigate through different aspects of your astrological profile

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Thanks to the [iztro](https://github.com/SylarLong/iztro) project for providing the core astrology calculations
- Inspiration from traditional Chinese astrology masters
- Flutter community for an excellent mobile development framework

## 📞 Support

If you have any questions or need help with the app, please:

- Open an issue on GitHub
- Check the [Flutter documentation](https://docs.flutter.dev/) for development help
- Visit [iztro documentation](https://iztro.com) for astrology-specific information

---

**Disclaimer**: This application is for entertainment and educational purposes. Astrological interpretations should not be used as the sole basis for important life decisions.
