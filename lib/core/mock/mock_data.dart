import 'package:flutter/material.dart';

import '../../features/discovery/domain/entities/device_platform.dart';
import '../../features/discovery/domain/entities/device_status.dart';
import 'mock_file_item.dart';
import 'mock_history_item.dart';
import 'mock_nearby_device.dart';

class MockData {
  static const nearbyDevices = [
    MockNearbyDevice(
      id: 'iphone-rafi',
      name: "Rafi's iPhone",
      platform: DevicePlatform.ios,
      status: DeviceStatus.available,
      angle: -1.1,
      orbitFactor: 0.33,
      colorValue: 0xFF16A3B8,
    ),
    MockNearbyDevice(
      id: 'pixel-mira',
      name: "Mira's Pixel",
      platform: DevicePlatform.android,
      status: DeviceStatus.connected,
      angle: 1.1,
      orbitFactor: 0.38,
      colorValue: 0xFF6C5CE7,
    ),
    MockNearbyDevice(
      id: 'ipad-studio',
      name: 'Studio iPad',
      platform: DevicePlatform.ios,
      status: DeviceStatus.available,
      angle: 2.75,
      orbitFactor: 0.3,
      colorValue: 0xFF2F80ED,
    ),
  ];

  static const selectedFiles = [
    MockFileItem(
      name: 'trip_photos.zip',
      type: 'Archive',
      sizeLabel: '126.4 MB',
      icon: Icons.folder_zip_rounded,
    ),
    MockFileItem(
      name: 'design_preview.mov',
      type: 'Video',
      sizeLabel: '84.2 MB',
      icon: Icons.movie_rounded,
    ),
    MockFileItem(
      name: 'boarding-pass.pdf',
      type: 'Document',
      sizeLabel: '742 KB',
      icon: Icons.picture_as_pdf_rounded,
    ),
  ];

  static const history = [
    MockHistoryItem(
      fileName: 'client-assets.zip',
      fileSize: '218 MB',
      deviceName: "Mira's Pixel",
      direction: 'Sent',
      timeLabel: 'Today, 5:12 PM',
      status: 'Completed',
      success: true,
    ),
    MockHistoryItem(
      fileName: 'notes.pdf',
      fileSize: '1.8 MB',
      deviceName: "Rafi's iPhone",
      direction: 'Received',
      timeLabel: 'Yesterday, 9:40 PM',
      status: 'Completed',
      success: true,
    ),
    MockHistoryItem(
      fileName: 'raw-footage.mov',
      fileSize: '1.2 GB',
      deviceName: 'Studio iPad',
      direction: 'Sent',
      timeLabel: 'Jun 2, 11:18 AM',
      status: 'Interrupted',
      success: false,
    ),
  ];
}
