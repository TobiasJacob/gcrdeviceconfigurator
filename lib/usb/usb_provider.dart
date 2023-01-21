import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'gcr_device.dart';
import 'usb_data.dart';

const simulate = true;

Stream<UsbData> realUsbProvider(ref) async* {
    var state = const UsbData.disconnected();
    GcrUsbHidDevice device = GcrUsbHidDevice();
    while (true) {
      await state.map(
        connected: (connected) async {
          try {
            final currentValues = await device.receiveRawADCValues();
            state = UsbData.connected(currentValues: currentValues, device: device);
          } catch (e) {
            state = const UsbData.disconnected();
            try {
              await device.close();
            } catch (e) {
              debugPrint("Error closing device: $e");
            }
            debugPrint("Error reading values: $e");
          }
        },
        disconnected: (disconnected) async {
          try {
            await device.open();
            final currentValues = await device.receiveRawADCValues();
            state = UsbData.connected(currentValues: currentValues, device: device);
            // ignore: empty_catches
          } catch (e) {
            debugPrint("Error opening device: $e");
          }
        },
        uninitialized: (value) {
          throw Exception(
              "Error, state uninitialized should not happen in this loop");
        },
      );
      yield state;
      await Future.delayed(const Duration(milliseconds: 100));
    }
}

Stream<UsbData> simulatedUsbProvider(ref) async* {
    var state = const UsbData.disconnected();
    Random random = Random();

    while (true) {
      state = state.maybeMap(
          connected: (connected) {
            final newValues = List<int>.empty(growable: true);
            for (var i = 0; i < connected.currentValues.length; i++) {
              var newVal = connected.currentValues[i] +
                  (random.nextDouble() - 0.5) * 100;

              newVal += (4096 / 2 - newVal) * 0.002;
              newValues.add(max(min(newVal.round(), 4096), -4096));
            }
            return UsbData.connected(currentValues: newValues, device: connected.device);
          },
          orElse: () =>
              UsbData.connected(currentValues: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], device: GcrUsbHidDevice()));
      yield state;
      await Future.delayed(const Duration(milliseconds: 100));
    }
}

final usbProvider = StreamProvider<UsbData>(realUsbProvider);
