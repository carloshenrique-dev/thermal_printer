import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:thermal_printer/modules/home/widgets/body_widget.dart';

class MobileWidget extends StatefulWidget {
  const MobileWidget({super.key});

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
        ),
        body: StreamBuilder<List<BluetoothDevice>>(
          stream: bluetoothPrint.scanResults,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                (snapshot.data?.isNotEmpty ?? false) &&
                snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: snapshot.data!
                      .map(
                        (bluetoothDevice) => ListTile(
                          title: Text(bluetoothDevice.name ?? ''),
                          subtitle: Text(bluetoothDevice.address ?? ''),
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            final value =
                                await bluetoothPrint.connect(bluetoothDevice);
                            if (value != null) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BodyWidget(
                                          title: 'android',
                                        )),
                              );
                            }
                          },
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
              );
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No device found...',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent),
                  child: const Text(
                    'Try again',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BodyWidget(
                                title: 'android',
                              )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent),
                  child: const Text(
                    'Continue...',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
