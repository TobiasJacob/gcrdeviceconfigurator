import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gcrdeviceconfigurator/usb/usb_status.dart';

class UpdateDeviceWidget extends StatelessWidget {
  const UpdateDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    USBStatus usbStatus = USBStatus.of(context);

    return Row(
      children: [
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            color: usbStatus.isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(usbStatus.isConnected ? "Connected" : "No device found"),
      ],
    );
  }
}