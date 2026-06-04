# Flutter Project Prompt: Local Wi-Fi FileDrop App

You are an expert Flutter architect and senior mobile engineer.

Build a modern Flutter app for Android and iOS that allows users to transfer files directly between devices connected to the same Wi-Fi network without any cloud backend.

The app should be similar in concept to local Wi-Fi file sharing tools, but it must use a native Flutter mobile-first approach.

## Core Goal

Create a production-quality Flutter app named **FileDrop**.

The app will allow:

* Same Wi-Fi device discovery
* Sender and receiver device connection
* Direct file transfer over local network
* No cloud backend
* No external file storage server
* Local peer-to-peer style transfer using local HTTP/TCP server
* QR code fallback if auto discovery fails
* Beautiful modern animated UI
* Clean Architecture
* BLoC state management
* Dark mode and light mode
* Android and iOS support

---

# Recommended Technical Approach

Do not use WebRTC for the first version.

Use this architecture instead:

```text
Sender Device:
- User selects files
- App starts a temporary local HTTP server
- App exposes selected files through local URLs
- App broadcasts device info on the local Wi-Fi network
- App displays QR code as fallback

Receiver Device:
- App scans local Wi-Fi devices
- Nearby devices appear as animated circular icons
- User taps a device
- Receiver requests file metadata
- Receiver downloads file directly from sender device
- Progress percentage is shown in real time
```

The app must work without a cloud backend.

---

# Must-Have Features

## 1. Same Wi-Fi Device Discovery

Implement local network discovery.

The app should detect other devices running the app on the same Wi-Fi network.

Preferred options:

```text
Option A:
- mDNS / Bonjour / NSD discovery

Option B:
- UDP broadcast discovery

Option C:
- QR code fallback
```

If auto discovery is difficult on a platform, implement QR fallback properly.

Each visible nearby device should show:

* Device name
* Platform icon
* Connection status
* Availability status
* Animated circular avatar/icon

Example:

```text
Rafi's iPhone
Available
Tap to send / receive
```

---

## 2. Local File Transfer

Implement direct file transfer using local network.

Sender side:

* User selects one or multiple files
* App starts a temporary local HTTP server using `dart:io` or a suitable package
* Generate file metadata:

  * file name
  * file size
  * mime type
  * local download URL
  * transfer session ID
* Show sender status
* Show QR code containing session info

Receiver side:

* Read file metadata
* Start download from sender device
* Show download progress
* Save file locally
* Show success / failed state

Transfer must support:

* Single file
* Multiple files
* Large files
* Cancel transfer
* Retry transfer
* Progress percentage
* Transfer speed if possible
* Remaining time if possible

---

# UI / UX Requirements

Create a very beautiful, modern, premium UI.

The app should feel like a polished production app.

## Main Home Screen

Design a circular animated discovery UI.

Main idea:

```text
Center:
- Current user/device avatar
- App logo or device icon

Around center:
- Nearby devices appear as circular floating icons
- Devices slowly rotate or float around the center
- Background has soft animated radar rings
- Scanning circle keeps moving while searching
```

UI behavior:

* When app opens, scanning animation starts
* A circular radar/ripple animation keeps moving
* Nearby devices appear with smooth scale/fade animation
* Device icons gently float
* User can tap a nearby device
* Selected device opens transfer panel

Include:

* Big animated circular scan area
* Nearby user/device bubbles
* File send button
* Receive status
* Settings button
* Theme toggle
* Transfer history shortcut

---

## Transfer Progress UI

When transferring files, show a modern progress screen.

Must include:

* Circular progress indicator
* Percentage text, for example `47%`
* Current file name
* Total transferred size
* Transfer speed
* Estimated time remaining
* Cancel button
* Success animation
* Error state with retry button

Example UI text:

```text
Sending photo_001.png
47%
12.4 MB of 26.1 MB
3.2 MB/s
About 5 seconds remaining
```

---

## Empty / Idle State

When no nearby device is found:

```text
Searching for nearby devices...
Make sure both devices are connected to the same Wi-Fi.
```

Show:

* Animated radar
* QR code fallback button
* Manual IP connect option if useful

---

## QR Code Fallback

Add QR fallback for reliability.

Sender:

* Generate QR code with:

  * sender IP
  * port
  * session ID
  * device name
  * file metadata endpoint

Receiver:

* Scan QR code
* Connect directly to sender
* Fetch metadata
* Start download

Use QR fallback when:

* Auto discovery fails
* Router blocks multicast
* User wants manual transfer

---

# Theme Requirements

Support both light mode and dark mode.

Use modern color design.

Light mode:

* Clean white / soft gray background
* Soft shadows
* Blue / purple accent
* Glassmorphism-style cards if suitable

Dark mode:

* Deep navy / dark gray background
* Neon-like blue / cyan accent
* Soft glowing circles
* Beautiful contrast

Theme should be handled properly using Flutter ThemeData.

Add:

* Theme toggle
* System default theme support
* Persistent theme setting

---

# Architecture Requirements

Use Clean Architecture with BLoC.

The project must have these layers:

```text
lib/
  core/
    constants/
    errors/
    network/
    permissions/
    theme/
    utils/
    widgets/

  features/
    discovery/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/

    transfer/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        bloc/
        pages/
        widgets/

    settings/
      data/
      domain/
      presentation/

    history/
      data/
      domain/
      presentation/
```

Use dependency injection.

Preferred:

```text
get_it
injectable optional
```

State management:

```text
flutter_bloc
equatable
```

Routing:

```text
go_router
```

---

# Important Packages

Use suitable Flutter packages. Suggested packages:

```yaml
flutter_bloc
equatable
get_it
go_router
file_picker
path_provider
permission_handler
network_info_plus
device_info_plus
qr_flutter
mobile_scanner
http
mime
uuid
shared_preferences
```

For local server:

```yaml
shelf
shelf_router
```

For discovery, choose the best working option:

```yaml
multicast_dns
```

Or implement UDP broadcast manually using `dart:io`.

If a package is not suitable for Android/iOS, replace it with a better working package and explain why in comments.

---

# Core Data Models

Create these domain entities:

```dart
DeviceEntity
- id
- name
- ipAddress
- port
- platform
- status
- lastSeen

TransferSessionEntity
- sessionId
- senderDevice
- receiverDevice
- files
- status
- createdAt

FileItemEntity
- id
- name
- path
- size
- mimeType
- downloadUrl

TransferProgressEntity
- sessionId
- fileId
- transferredBytes
- totalBytes
- percentage
- speedBytesPerSecond
- estimatedRemainingSeconds
- status
```

---

# BLoC Requirements

Create separate BLoCs:

## DiscoveryBloc

Events:

```text
StartDiscovery
StopDiscovery
DeviceFound
DeviceLost
RefreshDiscovery
SelectDevice
```

States:

```text
DiscoveryInitial
DiscoveryScanning
DiscoveryLoaded
DiscoveryEmpty
DiscoveryError
```

## TransferBloc

Events:

```text
PickFiles
StartSenderServer
CreateTransferSession
StartDownload
UpdateTransferProgress
CancelTransfer
RetryTransfer
CompleteTransfer
FailTransfer
```

States:

```text
TransferInitial
FilePicking
FilesSelected
SenderServerRunning
TransferReady
TransferInProgress
TransferSuccess
TransferFailure
TransferCancelled
```

## ThemeBloc

Events:

```text
LoadTheme
ToggleTheme
SetLightTheme
SetDarkTheme
SetSystemTheme
```

States:

```text
ThemeState
```

---

# Local Server API

When sender starts local server, expose endpoints like:

```text
GET /health
GET /session/:sessionId
GET /files/:sessionId/:fileId
```

Example metadata response:

```json
{
  "sessionId": "abc-123",
  "deviceName": "Rafi's Android",
  "files": [
    {
      "id": "file-1",
      "name": "photo.png",
      "size": 2457600,
      "mimeType": "image/png",
      "downloadUrl": "http://192.168.0.105:8080/files/abc-123/file-1"
    }
  ]
}
```

---

# Permission Handling

Handle permissions properly.

Android:

* Internet permission
* Wi-Fi/network state permission
* Storage/media permission based on Android version
* Notification permission if needed
* Cleartext local HTTP configuration if required

iOS:

* Local Network permission
* Bonjour service description if using Bonjour/mDNS
* Photo/file access permission if needed

Add clear user-friendly permission messages.

Example:

```text
FileDrop needs local network access to find nearby devices on your Wi-Fi.
```

---

# Platform Requirements

The app must support:

```text
Android
iOS
```

Do not focus on Flutter Web for this version.

The app should be responsive for:

* Small phones
* Large phones
* Tablets

---

# Animation Requirements

Use smooth Flutter animations.

Required animations:

* Radar scanning circle
* Rotating/floating nearby device icons
* Pulse animation around current device
* File transfer circular progress animation
* Success check animation
* Error shake animation
* Smooth page transitions
* Theme transition if possible

Keep animation performance smooth.

Use:

```text
AnimationController
TweenAnimationBuilder
AnimatedContainer
AnimatedSwitcher
CustomPainter
```

Create reusable animated widgets.

---

# Screens

Build these screens:

## 1. Splash Screen

* App logo
* Smooth fade animation
* Auto navigate to Home

## 2. Home / Discovery Screen

* Animated circular scanner
* Nearby devices
* Send files button
* Receive mode status
* QR fallback button
* Settings button

## 3. File Picker / Selected Files Screen

* Selected file list
* File size
* Remove file option
* Start sharing button

## 4. Transfer Screen

* Progress percentage
* Circular progress
* Transfer speed
* Remaining time
* Cancel button
* Success / error state

## 5. QR Send Screen

* QR code
* Sender device name
* File summary
* Waiting for receiver status

## 6. QR Scan Screen

* Camera scanner
* Connect after scan
* Download confirmation

## 7. History Screen

* Previous transfers
* File name
* Date/time
* Sent/received status
* Success/failed status

## 8. Settings Screen

* Theme setting
* Device name setting
* Storage location info
* About app
* Privacy note: no cloud backend

---

# History Feature

Save transfer history locally.

Use:

```text
shared_preferences
```

or local database if needed.

Each history item:

```text
fileName
fileSize
direction: sent / received
deviceName
dateTime
status
```

---

# Error Handling

Handle these cases:

* No Wi-Fi connection
* Devices not on same network
* Permission denied
* Local server failed to start
* Receiver cannot connect
* Transfer cancelled
* Transfer interrupted
* File missing
* Not enough storage
* Router blocks device-to-device traffic
* QR data invalid

Show user-friendly messages.

Example:

```text
Could not reach this device. Make sure both phones are connected to the same Wi-Fi and try again.
```

---

# Security Requirements

Since this is local network file sharing:

* Do not upload files anywhere
* Do not use cloud storage
* Use temporary transfer sessions
* Generate random session IDs
* Stop server after transfer ends
* Do not expose all device files
* Only expose files selected by the user
* Add timeout for inactive sessions
* Add confirmation before receiving files

Optional but recommended:

* Add simple session token
* Include token in download URL
* Validate token before serving file

Example:

```text
http://192.168.0.105:8080/files/sessionId/fileId?token=randomToken
```

---

# Development Steps

Follow these phases strictly.

## Phase 1: Project Setup

Create Flutter project.

Add:

* Clean Architecture folders
* BLoC setup
* Theme setup
* Routing setup
* Dependency injection setup
* App constants
* Reusable widgets

Do not implement file transfer yet.

Definition of done:

* App runs on Android and iOS
* Splash screen works
* Home screen opens
* Light/dark theme works
* Folder structure is clean

---

## Phase 2: Modern UI Implementation

Build the full UI with mock data first.

Implement:

* Animated scanner
* Floating nearby device icons
* Empty state
* Transfer progress UI
* QR screen UI
* Settings screen
* History screen

Use mock nearby devices.

Definition of done:

* App looks premium
* Animations are smooth
* Dark/light mode both look beautiful
* UI works without real networking

---

## Phase 3: File Picker

Implement file selection.

Features:

* Pick single file
* Pick multiple files
* Show selected file list
* Show file size
* Remove selected file
* Clear selected files

Definition of done:

* User can select files
* Selected files are shown correctly
* File metadata is created

---

## Phase 4: Sender Local Server

Implement local HTTP server.

Features:

* Start server on available port
* Create transfer session
* Serve metadata endpoint
* Serve selected files endpoint
* Stop server after transfer
* Handle errors

Definition of done:

* Another device/browser on same Wi-Fi can open metadata URL
* File can be downloaded from local URL
* Server only exposes selected files

---

## Phase 5: QR Code Transfer

Implement QR fallback.

Sender:

* Generate QR code with session data

Receiver:

* Scan QR code
* Parse session data
* Fetch metadata
* Download file

Definition of done:

* Device B can scan QR from Device A
* Device B can download selected file from Device A
* Progress percentage is shown

---

## Phase 6: Auto Device Discovery

Implement local Wi-Fi discovery.

Features:

* Broadcast current device availability
* Listen for nearby devices
* Show devices on animated scanner
* Remove stale devices
* Tap device to connect

Definition of done:

* Two phones on same Wi-Fi can see each other
* Nearby devices appear as animated bubbles
* Device disappears when app closes or becomes inactive

---

## Phase 7: Transfer Progress and Reliability

Implement real progress tracking.

Features:

* Percentage
* Bytes transferred
* Total size
* Transfer speed
* Estimated remaining time
* Cancel
* Retry
* Success state
* Failure state

Definition of done:

* Large file transfer shows accurate progress
* Cancel works
* Retry works
* Success and failure states are clear

---

## Phase 8: History and Settings

Implement:

* Transfer history
* Device name setting
* Theme persistence
* About page
* Privacy note

Definition of done:

* History is saved locally
* Theme selection persists
* Device name persists

---

## Phase 9: Platform Polish

Fix Android and iOS platform issues.

Android:

* Add required permissions
* Handle cleartext local HTTP if needed
* Handle storage/media permission

iOS:

* Add local network permission description
* Add Bonjour service config if using mDNS
* Handle file saving properly

Definition of done:

* App works on real Android device
* App works on real iPhone
* QR transfer works
* Discovery works if platform/router allows it

---

## Phase 10: Final Polish

Add final production polish:

* Loading states
* Empty states
* Error illustrations
* App icon
* Splash icon
* Smooth transitions
* Code cleanup
* Comments for complex networking parts
* README.md
* Setup guide

Definition of done:

* App feels complete
* No major runtime errors
* Clean Architecture is maintained
* BLoC is used properly
* No cloud backend is used

---

# README Requirements

Create a README.md with:

```text
App name
Overview
Features
How it works
Tech stack
Architecture
How to run
Android setup
iOS setup
Limitations
Privacy note
Screenshots placeholder
Future improvements
```

Mention clearly:

```text
FileDrop does not upload files to any server.
Files are transferred directly over the local Wi-Fi network.
```

---

# Limitations To Mention in App / README

Mention:

* Both devices must be on the same Wi-Fi network
* Some routers block device-to-device communication
* Auto discovery may not work on all networks
* QR fallback should be used if discovery fails
* Transfer speed depends on Wi-Fi quality
* App must remain open during transfer

---

# Code Quality Rules

Follow these rules:

* Use Clean Architecture
* Use BLoC for state management
* Keep UI separate from business logic
* Use repositories and use cases
* Do not put networking directly inside widgets
* Use meaningful file names
* Use reusable widgets
* Use error handling
* Use comments only where helpful
* Keep code readable and maintainable

---

# Final Output Expected From AI Coding Tool

Build the complete Flutter project step by step.

At each phase:

1. Explain what will be implemented
2. Create or update files
3. Keep code clean
4. Test the app flow logically
5. Mention any platform-specific setup needed
6. Do not skip architecture
7. Do not use any cloud backend
8. Do not use Firebase
9. Do not use external storage server
10. Keep Android and iOS support

Final app should be a modern, beautiful, animated local Wi-Fi file sharing app built with Flutter, Clean Architecture, and BLoC.
