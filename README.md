# Amazon Clone - Flutter Frontend

A complete Amazon clone mobile application built with Flutter.

## 🚀 Features

- User Authentication (Sign Up / Login)
- Product Browsing & Search
- Shopping Cart & Checkout
- Order Management
- Admin Dashboard (Add/Delete products, View analytics)
- Image Upload with Cloudinary
- Responsive UI for all devices

## 🛠 Quick Setup

1. **Clone repository**
   ```bash
   git clone https://github.com/harshitsagar/Amazon-Clone-flutter.git

2. **Configure Cloudinary**
   ```bash
   # Copy the example keys file
    cp lib/constants/global_keys.example.dart lib/constants/global_keys.dart
   
   # Edit with your Cloudinary credentials

3. **Install Dependencies**
   ```bash
    flutter pub get

4. **Run the App**
   ```bash
    flutter run

🔧 Configuration
1. Get Cloudinary Credentials:
   * Sign up at cloudinary.com
   * Get your cloudName from dashboard
   * Create uploadPreset in Settings

2. Update global_keys.dart:
   static const String cloudName = 'your_cloud_name';
   static const String uploadPreset = 'amazon_clone';

🏗 Built With
- Flutter - UI Framework
- Dart - Programming Language
- Provider - State Management
- Cloudinary - Image Storage
- HTTP - API Communication

📱 App Overview
- Home Screen - Product listings & deals
- Product Details - Detailed product view
- Cart - Shopping cart management
- Profile - User account & orders
- Admin Panel - Product & order management

🌐 Backend API
Requires Amazon Clone Backend to be running. (https://github.com/harshitsagar/Amazon-Clone-Backend)
