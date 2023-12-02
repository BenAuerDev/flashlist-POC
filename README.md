# Flashlist
Flashlist is a crossplatform app, allowing the user to create, share and manage lists, so you don't have to search through whatsapp conversations.

## Installation
This App is built with Flutter and Firebase so if you haven't already, [install the Flutter-SDK](https://docs.flutter.dev/get-started/install) AND [install Firebase CLI](https://firebase.google.com/docs/cli#setup_update_cli) 

To clone the app, navigate to the desired folder on your machine and run the following command in your terminal 
```bash
git clone git@github.com:BenAuerDev/flashlist.git
```

After that you can install all dependencies by running this command from the project-root directory
```bash
flutter pub get
```

Then install the FlutterFire CLI by running the following command from any directory
```bash
dart pub global activate flutterfire_cli
```

To configure your clone of Flashlist with your own Firebase Backend run
```bash
flutterfire configure
```
Your terminal window will then prompt you with questions regarding set up steps.



After your project is configured, all you need to do is to run
```bash
flutter run
```
