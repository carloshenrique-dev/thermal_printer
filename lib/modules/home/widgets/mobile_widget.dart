import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:thermal_printer/core/models/user_information.dart';

import '../controller/controller.dart';

class MobileWidget extends StatefulWidget {
  final String platform;
  final UserInformation userInformation;
  const MobileWidget({
    super.key,
    required this.platform,
    required this.userInformation,
  });

  @override
  State<MobileWidget> createState() => _MobileWidgetState();
}

class _MobileWidgetState extends State<MobileWidget> {
  late final BluetoothPrint bluetoothPrint;
  bool isLoading = false;

  @override
  void initState() {
    bluetoothPrint = BluetoothPrint.instance;
    bluetoothPrint.startScan(timeout: const Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          title: const Text('Devices list'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final value = await bluetoothPrint.startScan(
                    timeout: const Duration(seconds: 1));
                if (value != null) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              icon: const Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () async {
                await Controller.printDocument(widget.userInformation);
              },
              icon: const Icon(Icons.print),
            )
          ],
        ),
        body: StreamBuilder<List<BluetoothDevice>>(
          stream: bluetoothPrint.scanResults,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                (snapshot.data?.isNotEmpty ?? false) &&
                snapshot.connectionState == ConnectionState.active) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: snapshot.data!
                        .map(
                          (bluetoothDevice) => ListTile(
                            title: Text(bluetoothDevice.name ?? ''),
                            subtitle: Text(bluetoothDevice.address ?? ''),
                            onTap: () async => _showSnackBar(
                                await printDocument(bluetoothDevice)),
                            trailing: (bluetoothDevice.address != null &&
                                    bluetoothDevice.address!.isNotEmpty)
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            }
            return const Align(
              alignment: Alignment.center,
              child: Text(
                'No device found...',
                style: TextStyle(fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> printDocument(
    BluetoothDevice bluetoothDevice,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      final value = await bluetoothPrint.connect(bluetoothDevice);
      if (value != null && value) {
        return await Controller.mobilePrintDocument(
          widget.userInformation,
          bluetoothPrint,
        );
      } else {
        await Controller.printDocument(widget.userInformation);
      }
      setState(() {
        isLoading = false;
      });
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(bool success) {
    final snackBar = SnackBar(
      content:
          Text(success ? 'Successful' : 'Operation canceled or with error'),
      backgroundColor: (Colors.black),
      showCloseIcon: true,
      closeIconColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
