## Thermal Printer

## Introduction:
This document explains how to use a Flutter app that uses Bluetooth printing and printing packages. The app works on all platforms, with specific functionalities for mobile devices.

## Cloning the Project:
To use this app, you must first clone the project from the Git repository using the following command:
```
git clone https://github.com/carloshenrique-dev/thermal_printer
```

## Running the App:
After cloning the project, open it in your preferred IDE or text editor. Next, navigate to the root directory of the project and execute the following command to download and install the dependencies:

```
flutter pub get
```
After installing the dependencies, you can run the app using the following command:

```
flutter run
```
The app should open on your default mobile device emulator or physical device if connected.

- [printing](https://pub.dev/packages/printing)
- [bluetooth_print](https://pub.dev/packages/bluetooth_print)

## Bluetooth Printing and Printing Packages:
This app uses two packages, Bluetooth_print and printing. The Bluetooth_print package provides a way to connect and print to Bluetooth printers, while the printing package allows printing to PDF files.

Mobile and Non-Mobile Platforms:
The app has specific functionalities for mobile devices. After launching the app, it opens on a screen for users to input their information. After submitting the information, the app navigates to a screen that shows available Bluetooth devices for printing.

For non-mobile platforms, after submitting the user information, printing is possible without the need for selecting a Bluetooth device.

Conclusion:
This app provides an easy and efficient way to print documents using Bluetooth printing and printing packages. The app works on all platforms, with specific functionalities for mobile devices, making it a versatile app for users.
