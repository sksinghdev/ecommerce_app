🛍️ Welcome to the E-Commerce App

This is a Flutter-based mobile application designed with scalability and maintainability in mind. The project follows a monorepo structure, adhering to clean architecture principles, and makes use of Cubit for effective state management. It integrates multiple modern tools and third-party packages to provide a seamless shopping experience. 

📦 Monorepo Structure

A monorepo (short for monolithic repository) is a single repository that contains code for multiple related projects. Learn more [here](https://en.wikipedia.org/wiki/Monorepo).


🧱 Project Highlights

    📦 Monorepo Structure: All modules, features, and shared packages are maintained in a single repository for ease of development and version control.

    🧼 Clean Architecture: Divided into domain, data, and presentation layers to enforce separation of concerns.

    🧠 State Management: Uses Cubit from the Bloc library for reactive and modular state control.

    🔐 Authentication:

        Email/Password via Firebase Authentication

        Google Sign-In support with Firebase

    💳 Payment Gateway:

        Integrated with Stripe for secure and testable checkout processes

        Mock backend available for local testing

    🌐 Networking: Uses Dio or http (based on your implementation) for API calls (e.g., FakeStoreAPI)

    🚀 Routing: Managed using auto_route for type-safe and scalable navigation

    🎨 UI: Built with clean, responsive components and google_fonts for modern typography

    📱 Platform: Cross-platform support (Android and iOS) 


💻 Development Setup & IDE Configuration

    Flutter SDK version: 3.27.1

    IDEs: VS Code or Android Studio recommended (with Flutter & Dart plugins)

🛠 Melos (Monorepo Tooling)

    Melos is a CLI tool for managing Dart/Flutter monorepos. It helps you link packages, bootstrap dependencies, and run scripts across packages.
🔧 Install Melos

        `dart pub global activate melos 2.9.0`
🚀 Bootstrap the Project

    Run this from the root of the project:

         `melos bootstrap` or melos `bs`

📚 Libraries Used

    This project uses many third-party libraries to simplify and structure development:
      
      Package	              Description

      `get_it`	               Dependency Injection (DI) container
      `auto_route`	           Declarative routing for Flutter
      `flutter_dotenv`	       Load environment variables from .env files
      `flutter_stripe`	       Stripe payments integration
      `flutter_bloc`	       State management using Bloc & Cubit
      `equatable`	           Simplifies value equality in Dart objects
      `dartz`	               Functional programming tools in Dart
      `firebase_core`	       Firebase core initialization
      `firebase_auth`	       Firebase authentication (email, Google)
      `google_sign_in`	       Google authentication
      `connectivity_plus`	   Check internet/network connection
      `dio`	                   Powerful HTTP client for Dart/Flutter
      `cached_network_image`   Caching network images
      `mocktail`	           Mocking in tests
      `bloc_test`	           Testing for Bloc/Cubit logic
      `auto_route_generator`   Code generation for auto_route
      `google_fonts`	       Use Google Fonts in your Flutter app 


ecommerce_app/
├── lib/
│   ├── main.dart                         # Entry point of the app
│
│   ├── application/                      # Global application config
│   │   ├── di/
│   │   │   └── injection_container.dart  # Global dependency injection setup
│   │   └── router/
│   │       └── app_router.dart          # Main app router using AutoRoute
│
│   ├── presentation/
│   │   └── widget/
│   │       └── splash_screen.dart       # Splash screen UI
│
│   ├── core/                             # Shared utilities and services
│   │   ├── common/lib/
│   │   │   ├── main.dart
│   │   │   └── common.dart
│   │   └── core/
│   │       ├── network/
│   │       │   ├── api_service.dart     # API wrapper
│   │       │   └── dio_client.dart      # Dio setup
│   │       ├── util/
│   │       │   └── utils.dart           # Common utility functions
│   │       └── data/
│   │           ├── models/
│   │           │   ├── failure.dart
│   │           │   └── user_model.dart
│   │           ├── repository/
│   │           │   └── auth_repository.dart
│   │           └── presentation/bloc/
│   │               ├── auth_cubit.dart
│   │               ├── auth_state.dart
│   │               └── network_cubit.dart
│
│   ├── authentication/
│   │   ├── core/
│   │   │   └── injection/
│   │   │       └── auth_router.dart     # Router for authentication feature
│   │   └── presentation/
│   │       ├── page/
│   │       │   └── login_page.dart
│   │       └── widget/
│   │           ├── auth_input_field_widget.dart
│   │           ├── divider_with_text_widget.dart
│   │           ├── primary_button_widget.dart
│   │           └── social_signin_button_widget.dart
│
│   ├── cart_detail/
│   │   ├── lib/
│   │   │   ├── cart_view.dart
│   │   │
│   │   │   ├── core/
│   │   │   │   └── cart_details_router.dart
│   │   │
│   │   │   ├── data/repositories/
│   │   │   │   ├── order_repository_impl.dart
│   │   │   │   └── payment_repository.dart
│   │   │
│   │   │   ├── domain/
│   │   │   │   ├── repository/
│   │   │   │   │   └── order_repository.dart
│   │   │   │   └── payment_intent.dart
│   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── order_cubit.dart
│   │   │       │   ├── order_state.dart
│   │   │       │   ├── product_list_cubit.dart
│   │   │       │   └── product_list_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── cart_details.dart
│   │   │       │   └── order_success.dart
│   │   │       └── widgets/
│   │   │           └── product_list_view.dart
│
│   ├── product_cart/
│   │   ├── lib/
│   │   │   ├── core/injection/
│   │   │   │   └── cart_router.dart
│   │   │
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── cart_cubit.dart
│   │   │       │   └── cart_state.dart
│   │   │       ├── page/
│   │   │       │   └── product_carts.dart
│   │   │       └── widgets/
│   │   │           ├── animated_button.dart
│   │   │           ├── animated_cart_button.dart
│   │   │           ├── animated_price_popped.dart
│   │   │           ├── product_card.dart
│   │   │           └── product_carousel.dart
│
│   ├── product_listing/
│   │   ├── main.dart
│   │   ├── core/
│   │   │   └── injection/
│   │   │       └── product_router.dart
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   ├── product.dart
│   │   │   │   └── product_model.dart
│   │   │   └── repository/
│   │   │       └── product_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── product_cubit.dart
│   │       │   └── product_state.dart
│   │       ├── page/
│   │       │   └── products_page.dart
│   │       └── widgets/
│   │           └── product_list_widget.dart





✅ Summary

    📦 Monorepo structure for modular scalability.

    🧼 Clean Architecture: separating core logic from UI and data.

    📁 Feature-based structure: clear separation of concerns across modules (e.g., authentication, cart_detail, product_listing, etc.).

    🧪 Easy to test and maintain, thanks to modular Cubits and DI.

    🚀 Ready for enterprise-scale expansion.