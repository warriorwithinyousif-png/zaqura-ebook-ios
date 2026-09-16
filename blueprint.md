# Blueprint

This document outlines the project structure, design, and features of the Islamic Book and Sound App.

## Overview

The app provides a collection of Islamic books for different grade levels. It features a dark and light theme and supports localization for English and Arabic. The app is designed as a single-screen experience, focusing on easy navigation to the book content.

## Project Structure

- `lib/`
  - `main.dart`: The main entry point of the application.
  - `models/`: Contains the data models for the app (e.g., `book.dart`).
  - `data/`: Contains mock data for the app (e.g., `mock_data.dart`).
  - `widgets/`: Contains reusable widgets (e.g., `grade_card.dart`).
  - `screens/`: Contains the book details screen.
  - `l10n/`: Contains the localization files.
- `assets/`
  - `images/`: Contains the images used in the app.

## Style, Design, and Features

- **Theme:** The app uses a modern Material Design theme. The default theme is light mode, and users can toggle to dark mode.
- **Typography:** The app uses Google Fonts (`Amiri` for display, `Cairo` for titles, `Lato` for body) for a clean and readable look, suitable for both English and Arabic.
- **Colors:** The primary color is a vibrant green (`#3DDC84`), and the app uses a consistent color scheme throughout.
- **Localization:** The app supports English and Arabic. The default language is set to Arabic.
- **Home Screen:** The app's single screen displays a grid of grade levels (1-6) for direct access to the book content.

## Current Change: Remove Bottom Navigation and Simplify UI

- **Goal:** Simplify the application to a single-screen experience by removing the bottom navigation bar, audio player, and associated screens.
- **Implementation:**
  - Modified `lib/main.dart`.
  - Removed the `BottomNavigationBar` from the `MyHomePage` widget.
  - Removed the `AudioPlayerWidget` and the `AudioPlayerState` provider.
  - Removed the `BooksScreen` and `SoundsScreen` widgets as they are no longer accessible.
  - Updated `MyHomePage` to be a `StatelessWidget` and its body to be the `HomeScreen` directly.
  - Removed unused imports and variables related to the deleted components.
  - Corrected layout errors that occurred after removing the `Expanded` widget from `HomeScreen`.
