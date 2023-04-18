import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thermal_printer/modules/home/widgets/body_widget.dart';

import 'widgets/mobile_widget.dart';

class ThermalPrinter extends StatefulWidget {
  const ThermalPrinter({super.key});

  @override
  State<ThermalPrinter> createState() => _ThermalPrinterState();
}

class _ThermalPrinterState extends State<ThermalPrinter> {
  late final String platform;
  late final bool isAndroid;

  @override
  void initState() {
    platform = kIsWeb ? 'web' : Platform.operatingSystem;
    isAndroid = kIsWeb ? false : Platform.isAndroid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (platform) {
      case 'android':
        return const MobileWidget();
      default:
        return BodyWidget(title: platform);
    }
  }
}
