# Without Remote Client

![Flutter](https://img.shields.io/badge/Flutter-%5E3.9.2-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)

A gesture-driven remote control application built with Flutter. Without Remote Client
turns your phone into a wireless touchpad for your PC — navigate videos, browse files,
and control media playback with simple swipes and taps — and can also control the
phone's own media playback, all from a distraction-free, dimmed-screen interface
designed for use in the dark.

This app is the client half of the **Without Remote** system. It communicates with the
companion server running on your PC:

> **Server:** [Neuxtron/without-remote](https://github.com/Neuxtron/without-remote) —
> a Node.js Socket.IO server that translates socket events into OS-level key presses.

---

## Features

- **PC remote control over LAN** — connects to the companion server via Socket.IO
  (`http://<pc-ip>:3000`) and sends low-latency gesture events over WebSocket.
- **Two PC control modes**
  - *Video mode* — seek and play/pause control for media players.
  - *File mode* — arrow-key navigation, open, and go back for file browsing.
- **Phone media control** — volume adjustment and play/pause/next/previous through
  native Android media key events.
- **Distraction-free gesture pad** — full-screen black interface that sets screen
  brightness to zero while active and restores it on exit.
- **Configurable server address** — set the PC's IP in an in-app settings dialog;
  persisted across launches.
- **Slide-out mode switcher** — a `Slidable`-powered side menu for switching between
  PC Media and Phone Media.

---

## Gesture Reference

### PC — Video Mode

| Gesture        | Action        |
| -------------- | ------------- |
| Swipe Left     | Arrow Left    |
| Swipe Right    | Arrow Right   |
| Swipe Up       | Arrow Up      |
| Swipe Down     | Arrow Down    |
| Double Tap     | Space (play/pause) |

### PC — File Mode

| Gesture        | Action        |
| -------------- | ------------- |
| Swipe Left     | Arrow Left    |
| Swipe Right    | Arrow Right   |
| Swipe Up       | Arrow Up      |
| Swipe Down     | Arrow Down    |
| Double Tap     | Return (open) |
| Long Press     | Back          |

### Phone Media Mode

| Gesture        | Action            |
| -------------- | ----------------- |
| Swipe Up       | Volume Up         |
| Swipe Down     | Volume Down       |
| Swipe Left     | Previous Track    |
| Swipe Right    | Next Track        |
| Double Tap     | Play / Pause      |

---

## Architecture

```
┌─────────────┐   Socket.IO (WebSocket, port 3000)   ┌──────────────────────┐
│  This app   │ ───────────────────────────────────► │  without-remote      │
│  (Flutter)  │   vol_up, arrow_left, space, ...     │  (Node.js, on PC)    │
└─────────────┘                                      └──────────────────────┘
                                                              │
                                                              ▼
                                                     OS-level key presses
```

The client emits named events (e.g. `arrow_up`, `space`, `return`, `back`, `vol_up`,
`vol_down`) over a `volatile` WebSocket channel; the server maps each event to a
keyboard action on the host machine.

Phone media control is handled locally: volume is adjusted with
[`volume_controller`](https://pub.dev/packages/volume_controller), while playback
events are dispatched through a `MethodChannel` (`media_control`) implemented in
`android/app/src/main/kotlin/.../MainActivity.kt`, which injects media key events via
Android's `AudioManager`.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.9.2`
- The companion server running on your PC — see
  [Neuxtron/without-remote](https://github.com/Neuxtron/without-remote)
- Phone and PC on the same local network (for PC control)

### Installation

```bash
git clone https://github.com/Neuxtron/without-remote-client.git
cd without-remote-client
flutter pub get
flutter run
```

### Connecting to your PC

1. Start the `without-remote` server on your PC (it listens on port `3000`).
2. Find your PC's local IP address (e.g. `192.168.1.10`).
3. In the app, open **PC Media**, tap the **settings icon**, and enter the IP.
4. The app will reconnect automatically; a confirmation snackbar appears on success.

> **Note:** Phone media control relies on an Android `MethodChannel` and is currently
> supported on Android only.

---

## Project Structure

```
lib/
├── main.dart                     # App entry point & theme
├── core/
│   ├── layouts/main_layout.dart  # Slidable shell hosting both modes
│   ├── services/socket_service.dart  # Socket.IO connection & event emission
│   ├── themes/app_colors.dart
│   └── utils/app_constants.dart  # Socket event names & preference keys
├── features/
│   ├── pc_media/                 # PC remote: page, IP dialog, view model
│   ├── phone_media/              # Local media: page & MethodChannel service
│   └── remote_gestures/          # Reusable full-screen gesture pad + models
├── routes/
│   └── app_routes.dart
└── shared/
    └── widget/blank_app_bar.dart
```

---

## Tech Stack

| Package | Purpose |
| ------- | ------- |
| [`socket_io_client`](https://pub.dev/packages/socket_io_client) | WebSocket communication with the PC server |
| [`provider`](https://pub.dev/packages/provider) | State management |
| [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) | Slide-out navigation menu |
| [`screen_brightness`](https://pub.dev/packages/screen_brightness) | Dimming the gesture pad screen |
| [`volume_controller`](https://pub.dev/packages/volume_controller) | Local volume adjustment |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | Persisting the server IP |
| [`flutter_svg`](https://pub.dev/packages/flutter_svg) | SVG asset rendering |
