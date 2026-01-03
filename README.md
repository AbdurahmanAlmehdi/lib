# Buzzy Bee

_A School Project_

## Project Team

- **Student 1:** عبدالرحمن المهدي ابراهيم
- **Student 2:** رغداعمار سعيد
- **Student 3:** ارجوان سمير العائب

---

A Flutter-based mobile application for booking cleaning services. Buzzy Bee connects customers with professional cleaners, allowing users to browse services, select cleaners, schedule appointments, and manage their bookings seamlessly.

## App Overview

Buzzy Bee is an on-demand cleaning service platform that enables users to:

- **Browse Services**: Explore various cleaning services including house cleaning, dish washing, carpet cleaning, and car cleaning
- **Select Cleaners**: View available cleaners with ratings, reviews, and service specializations
- **Book Appointments**: Schedule cleaning services with date, time, and location selection
- **Manage Bookings**: Track order status (pending, confirmed, in progress, completed, cancelled)
- **Favorites**: Save preferred cleaners for quick access
- **Wallet System**: Manage payments through an integrated wallet with transaction history
- **Multi-language Support**: Available in Arabic and English
- **Location Services**: Pick service locations using Google Maps integration

## User Types

The application supports two main user types:

### 1. **Users (Customers)**

Regular customers who book cleaning services. They can:

- Create accounts and manage profiles
- Browse and search for services and cleaners
- Book cleaning appointments
- View booking history and order status
- Save favorite cleaners
- Manage wallet balance and transactions
- Update personal information and preferences

### 2. **Cleaners (Service Providers)**

Professional cleaners who provide cleaning services. They can:

- Have profiles with ratings, reviews, and completed jobs count
- Be associated with multiple service types
- Be assigned to bookings based on service requirements
- Track their order history through the orders view

## Backend

The application uses a hybrid backend architecture:

### **Supabase**

- **Primary Backend**: Supabase serves as the main backend-as-a-service platform
- **Authentication**: Handles user authentication and authorization using Supabase Auth
- **Database Access**: Direct PostgreSQL database access through Supabase's PostgREST API
- **Real-time Capabilities**: Built-in real-time subscriptions for live data updates
- **Row Level Security (RLS)**: Implements security policies at the database level to ensure users can only access their own data

### **REST API**

- **Additional Services**: Custom REST API endpoints for specific operations
- **Payment Integration**: Moamalat payment gateway integration for wallet transactions
- **API Endpoints**: Includes endpoints for banners, categories, services, cleaners, bookings, orders, favorites, and user management

## Database

**PostgreSQL** (hosted on Supabase)

The database schema includes the following main entities:

- **users**: User profiles extending Supabase auth.users
- **services**: Available cleaning services with multilingual support
- **cleaners**: Service provider profiles with ratings and reviews
- **cleaner_services**: Many-to-many relationship between cleaners and services
- **bookings**: Customer booking records with location and scheduling details
- **booking_cleaners**: Many-to-many relationship between bookings and assigned cleaners
- **favorites**: User's saved favorite cleaners
- **wallets**: User wallet balances
- **wallet_transactions**: Transaction history for deposits, withdrawals, and payments


## Packages Used

### **State Management**

- **flutter_bloc** : BLoC pattern implementation for predictable state management
  - _Why_: Provides a clean separation of business logic from UI, making the app more testable and maintainable
- **equatable**: Value equality comparison for state objects
  - _Why_: Simplifies state comparison in BLoC, preventing unnecessary rebuilds


### **Networking**

- **dio** (^5.4.0): Powerful HTTP client for API requests
  - _Why_: Provides interceptors, request/response transformation, and better error handling compared to default HTTP client
- **supabase_flutter** (^2.12.0): Official Supabase Flutter SDK
  - _Why_: Provides seamless integration with Supabase backend services including auth, database, and storage
- **supabase** (^2.10.2): Core Supabase client library
  - _Why_: Base package for Supabase functionality

### **Storage**

- **flutter_secure_storage** (^9.0.0): Secure storage for sensitive data like tokens
  - _Why_: Encrypts data at rest, essential for storing authentication tokens and sensitive user information

### **Navigation**

- **go_router** (^13.0.0): Declarative routing solution for Flutter
  - _Why_: Provides type-safe navigation, and better route management than Navigator 2.0, and allows redirecting based on auth state

### **UI & Icons**

- **cupertino_icons** (^1.0.8): iOS-style icons
  - _Why_: Provides platform-appropriate icons for iOS
- **google_fonts** (^6.1.0): Google Fonts integration
  - _Why_: Allows dynamic font loading without bundling font files, supporting custom typography (Space Grotesk + JetBrains Mono)

### **Utilities**

- **cached_network_image** (^3.3.1): Image caching and loading
  - _Why_: Improves performance by caching network images, reducing bandwidth usage and load times
- **table_calendar** (^3.0.9): Calendar widget for date selection
  - _Why_: Provides a polished calendar UI for booking date selection
- **google_maps_flutter** (^2.5.0): Google Maps integration
  - _Why_: Enables location picking and map visualization for service locations
- **geolocator** (^13.0.1): Location services
  - _Why_: Handles device location permissions and GPS functionality
- **intl** (^0.20.2): Internationalization and localization
  - _Why_: Supports date, number, and message formatting for multiple languages
- **flutter_spinkit** (^5.2.0): Loading indicators
  - _Why_: Provides attractive loading animations for better UX
- **image_picker** (^1.0.7): Image selection from gallery or camera
  - _Why_: Enables users to upload profile pictures and other images
- **skeletonizer** (^2.1.2): Skeleton loading screens
  - _Why_: Improves perceived performance with skeleton placeholders during data loading
- **bloc_concurrency** (^0.2.5): BLoC concurrency utilities
  - _Why_: Provides advanced event handling strategies for BLoC (debounce, throttle, etc.)
- **webview_flutter** (^4.4.2): WebView widget
  - _Why_: Enables payment gateway integration through web views (Moamalat)
- **collection** (^1.19.1): Collection utilities
  - _Why_: Provides additional collection manipulation functions

### **Development Tools**

- **flutter_launcher_icons** (^0.14.4): App icon generation
  - _Why_: Automates the creation of app icons for different platforms

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

- **Presentation Layer**: Widgets, screens, and BLoC for UI and state management
- **Domain Layer**: Business logic, entities, and repository interfaces
- **Data Layer**: Repository implementations, data sources, and models


## Features

- ✅ User authentication (login/signup)
- ✅ Service browsing and search
- ✅ Cleaner selection with ratings and reviews
- ✅ Booking management with date/time selection
- ✅ Location picking with Google Maps
- ✅ Favorites system
- ✅ Wallet management with payment integration
- ✅ Order tracking
- ✅ Multi-language support (Arabic/English)
- ✅ Responsive UI design
