# 🛍️ FLEXXX — Shopping Redesigned

A modern, high-performance, cross-platform e-commerce application built with **Flutter** and **Riverpod**. **FLEXXX** delivers a seamless, responsive shopping experience across mobile, tablet, and desktop devices with adaptive UI layouts, dark/light theme support, custom accessibility features, and real-time state management.

---

## ✨ Features

- **📱 Adaptive & Responsive Navigation**
  - Mobile bottom navigation bar and desktop vertical navigation rail (`AdaptiveNavShell`).
  - Fluid responsiveness tailored for mobile, tablet, and desktop viewports.

- **🔥 Home & Exploration**
  - Curated product feeds, category carousels, promotional banners, and quick search.
  - Interactive **Explore Mode** featuring dynamic staggered grid layouts (`flutter_staggered_grid_view`).

- **🔍 Advanced Search & Filtering**
  - Instant product filtering by category, price, rating, and tags.
  - Quick access to recent searches and trending tags.

- **🛍️ Product Details & Interactive Variant Selector**
  - Multi-image gallery viewer with cached network images.
  - Interactive color, size, and specification selectors.
  - Customer ratings, reviews breakdown, and item availability tracking.

- **⚖️ Side-by-Side Product Comparison**
  - Multi-product comparison matrix comparing pricing, specifications, ratings, and features.

- **🛒 Dynamic Shopping Cart & Checkout**
  - Live cart state management powered by Riverpod.
  - Save-for-later items list.
  - Coupon code redemption and detailed pricing breakdown.
  - Multi-step Checkout flow (Shipping Address, Delivery Method, Payment Selection, & Order Confirmation).

- **❤️ Wishlist & 📦 Order Tracking**
  - Save favorite items to wishlist with one-tap cart transfers.
  - Track active and historical orders with live delivery status timelines.

- **🏆 Gamified Loyalty Rewards**
  - Earn points, unlock reward tiers (Bronze, Silver, Gold, Platinum), and redeem discount vouchers.

- **🎨 Themes & Accessibility**
  - Seamless Light and Dark Mode toggle.
  - Accessibility engine supporting dynamic text scaling (`textScaleFactor`).

---

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter SDK](https://flutter.dev/) (Dart 3.x)
- **State Management:** [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) (`^2.5.1`)
- **UI & Layout:** 
  - `google_fonts` — Custom typography tokens
  - `flutter_staggered_grid_view` — Dynamic product grids
  - `cached_network_image` — Image caching & smooth loading placeholders
- **Utilities & Formatting:** `intl`, `shared_preferences`

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── accessibility/     # Accessibility models and scaling providers
│   ├── constants/         # Design tokens, brand colors, spacing constants
│   ├── theme/             # AppTheme configurations (Light & Dark) and theme providers
│   ├── utils/             # Responsive helpers and formatters
│   └── widgets/           # Shared adaptive navigation shell & layout widgets
├── data/                  # Mock database models and dataset
├── features/              # Feature-first modular organization
│   ├── cart/              # Cart screen, state management, and item cards
│   ├── checkout/          # Multi-step checkout pipeline
│   ├── compare/           # Product comparison matrix
│   ├── explore/           # Staggered explore layout
│   ├── home/              # Home screen, discovery feeds, and promotions
│   ├── orders/            # Order history and status tracking
│   ├── products/          # Product details, image gallery, and review widgets
│   ├── profile/           # User profile, theme/accessibility settings
│   ├── rewards/           # Loyalty points, tiers, and vouchers
│   ├── search/            # Search screen and filtering logic
│   └── wishlist/          # Saved items and wishlist management
├── shared/                # App-wide shared providers (cart, wishlist, compare)
└── main.dart              # Application entry point & ProviderScope wrapping
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.13.5 or later recommended)
- Dart SDK 3.x
- iOS / Android / Desktop (macOS, Windows, Linux) / Web development environment setup

### Installation & Running

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Sameer4821/FLEXXX-An_Ecommerce_Store.git
   cd flex
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code analysis:**
   ```bash
   flutter analyze
   ```

4. **Launch application:**
   ```bash
   # Run on default connected device or browser
   flutter run

   # Run specifically on Chrome (Web)
   flutter run -d chrome

   # Run on Windows / macOS Desktop
   flutter run -d windows
   ```

---

## 🧪 Running Tests

Execute the unit and widget test suite:
```bash
flutter test
```

---

## 📄 License

This project is open-source under the MIT License.

