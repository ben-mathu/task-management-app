# jenga_planner

A application to help with management of tasks

## Getting Started

### Project Setup

Make sure you have the Firebase CLI.
Find installation instructions [here](https://firebase.google.com/docs/cli?hl=en&authuser=0#install_the_firebase_cli)

Open Firebase console and create a project

Configure firebase to the project by running:

```shell
firebase login
```

Make sure you are signed in using:

```shell
firebase project:list
```

Next run:

```shell
flutterfire configure --project=jenga-planner
```

to configure the project

You can also follow configuration instructions in [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?authuser=0&hl=en&platform=ios)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Database set up

Run this command to generate models for the databse

```shell
flutter pub run build_runner build
```

## Run the app

Start the application by running this command

```shell
flutter run
```

## Installable apk

Find an installable apk from [here](./apk/app-release.apk)
