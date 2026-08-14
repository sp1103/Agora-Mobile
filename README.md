# Agora Mobile

A Flutter mobile application that helps users follow government legislation and legislators at the local and federal levels. Agora brings legislative information, representative details, personalized content, and saved items into a single mobile experience.

**Website:** [Agora for the People](https://agoraforthepeople.net)

## Overview

Agora Mobile was developed as part of the University of Utah Computer Science capstone project. The application provides a mobile interface for exploring political and legislative information while supporting authenticated, personalized user experiences.

The project demonstrates mobile application development, UI design, application state management, authentication, local persistence, remote data integration, and error handling using Flutter and Firebase-backed services.

## Key Features

- Browse legislators and legislation from a mobile interface
- View detailed information about representatives and legislative activity
- Authenticate users through Firebase
- Save and manage favorite content
- Persist selected application data locally
- Retrieve legislative and political data from remote services
- Provide personalized application views and navigation
- Handle application state and errors across multiple screens and workflows

## Technology Stack

- **Flutter / Dart** — cross-platform mobile application development
- **Firebase** — authentication and supporting cloud services
- **SQL / SQLite** — application data and local persistence
- **Android Studio / Android SDK** — Android development and testing
- **Git / GitHub** — source control and collaborative development

## Project Structure

The application is organized into components for pages, reusable widgets, data access, application state, domain types, and error handling. This separation keeps UI code distinct from data and application logic and makes the project easier to maintain and extend.

## Running the Project

The public repository intentionally does **not** include the Firebase configuration or production database credentials used by the original project. As a result, cloning the repository alone will not connect to the original backend services.

To run the source locally, you will need:

1. A working Flutter development environment
2. Android Studio or another supported Flutter development environment
3. Your own Firebase project and configuration
4. Your own compatible database/backend configuration

After configuring those dependencies, install the Flutter packages and launch the application using the standard Flutter development workflow.

## Android Build

A prebuilt Android APK of the capstone version is available here:

[Download the Agora APK](https://drive.google.com/file/d/16zFuzTw1NEfqoKmUXI5pqXVMRPSgsxnl/view?usp=sharing)

## Security Note

Credentials, Firebase configuration, and production database connection information have intentionally been removed from this public repository. This repository is intended to demonstrate the application's source code and engineering approach without exposing private configuration.

## About the Project

Agora was built to make government information easier to access from a single application. The mobile project provided experience building a multi-screen application, integrating local and remote data, implementing authentication, managing application state, troubleshooting integration issues, and delivering a working Android application as part of a collaborative capstone effort.
