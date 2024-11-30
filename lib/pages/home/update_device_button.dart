import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/usb/usb_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpdateDeviceWidget extends ConsumerWidget {
  const UpdateDeviceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usbStatus = ref.watch(usbProvider);

    final isConnected = usbStatus.maybeWhen(
      data: (data) => data.maybeMap(
        connected: (s) => true,
        orElse: () => false,
      ),
      orElse: () => false,
    );

    return Row(
      children: [
        const SizedBox(width: 8.0),
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            color: isConnected
                ? const Color.fromRGBO(80, 254, 0, 1)
                : const Color.fromRGBO(238, 65, 35, 1),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(isConnected ? "Connected" : "No device found"),
      ],
    );
  }
}
