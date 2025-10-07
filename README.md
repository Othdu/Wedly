# WEDLY - Luxury Wedding Booking Mobile App

WEDLY is a Flutter mobile application for luxury wedding booking services, featuring a golden luxury theme with Arabic RTL support.

## Features

### 🎨 Design & Theme
- **Golden Luxury Theme**: Exact match to web application with golden color palette (#D6B45A)
- **Arabic RTL Support**: Full right-to-left text direction support
- **Noto Kufi Arabic Font**: Beautiful Arabic typography
- **Responsive Design**: Mobile-first design optimized for all screen sizes
- **Golden Gradients & Shadows**: Luxurious visual effects throughout the app

### 🔐 Authentication
- User registration and login
- Password reset functionality
- Supabase integration for backend services
- Secure authentication flow

### 🏠 Home Screen
- WEDLY branding with golden logo
- Welcome header with gradient background
- Search functionality
- Main service categories (3 cards)
- Featured services carousel
- Service categories grid (4+ cards)
- Bottom navigation with golden accents

### 📱 Core Features
- **Service Categories**: Venues, Dresses, Photography, Catering, Decoration, Music, etc.
- **Booking System**: Quick booking functionality
- **Vendor Dashboard**: Mobile-optimized vendor management
- **User Profile**: Profile management with golden theme
- **Favorites**: Save favorite services
- **Search**: Advanced search functionality

### 🛠 Technical Stack
- **Flutter 3.x** with Dart
- **BLoC/Cubit** for state management
- **Supabase Flutter SDK** for backend
- **Go Router** for navigation
- **Cached Network Image** for image handling
- **Shimmer** for loading effects

## Setup Instructions

### Prerequisites
- Flutter SDK 3.5.4 or higher
- Dart SDK
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wedly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a Supabase project
   - Update `lib/core/constants/app_constants.dart` with your Supabase URL and anon key:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

4. **Add Arabic Fonts**
   - Download Noto Kufi Arabic font files
   - Place them in `assets/fonts/` directory:
     - `NotoKufiArabic-Regular.ttf`
     - `NotoKufiArabic-Bold.ttf`
     - `NotoKufiArabic-Medium.ttf`

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and colors
│   ├── theme/             # App theme configuration
│   └── utils/             # Utilities and router
├── features/
│   ├── auth/              # Authentication feature
│   ├── home/              # Home screen feature
│   ├── booking/           # Booking system
│   ├── vendor/            # Vendor dashboard
│   ├── profile/           # User profile
│   └── search/            # Search functionality
├── shared/
│   ├── widgets/           # Shared widgets
│   └── models/            # Shared models
└── l10n/                  # Localization files
```

## Color Palette

### Primary Colors
- **Primary Golden**: #D6B45A (hsl(43, 56%, 58%))
- **Golden Light**: #F3DE96 (hsl(43, 56%, 90%))
- **Golden Dark**: #A17D3B (hsl(43, 56%, 35%))

### Luxury Colors
- **White**: #FFFFFF
- **Light Gray**: #F7F7F7
- **Dark Gray**: #2E2E2E
- **Black**: #1D1D1D

### Gradients
- **Golden Gradient**: linear-gradient(135deg, #D6B45A 0%, #E8C878 100%)
- **Shadows**: rgba(214, 180, 90, 0.3)

## Navigation

The app uses a bottom navigation with 5 main sections:
1. **Home** - Main dashboard
2. **Vendors** - Vendor marketplace
3. **Quick Book** - Quick booking
4. **Favorites** - Saved services
5. **Profile** - User profile

## State Management

The app uses BLoC pattern for state management:
- `AuthBloc` - Authentication state
- `HomeBloc` - Home screen data
- Other feature-specific BLoCs

## Localization

The app supports both Arabic and English:
- Arabic (ar) - Default language with RTL support
- English (en) - Secondary language

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please contact the development team.

---

**WEDLY** - Your Wedding, Our Passion 💍✨