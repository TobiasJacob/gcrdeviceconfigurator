import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpdateDeviceWidget extends ConsumerWidget {
  const UpdateDeviceWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usbStatus = ref.watch(usbProvider);

    final isConnected = usbStatus.maybeMap(
      data: (data) => data.maybeMap(
        data: (s) => true,
        orElse: () => false,
      ),
      orElse: () => false,
    );

    return Row(
      children: [
        // isConnected ? ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.white,
        //     foregroundColor: Colors.black,
        //   ),
        //   onPressed: () async {
        //     debugPrint("${serializeConfig(appSettings, database)}");
        //     await usbStatus.device.sendSerializedConfig(serializeConfig(appSettings, database));
        // }, child: const Text("Upload profile")) : const SizedBox(width: 20.0),
        const SizedBox(width: 8.0),
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(isConnected ? "Connected" : "No device found"),
      ],
    );
  }
}