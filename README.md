# auri_sign

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Gesture detection via Web Viewer

The mobile app now loads the web gesture detection page in a WebView so both apps use the same web model.

### Android (recommended for local development)

Use `localhost` in WebView with `adb reverse` to keep a secure context for camera APIs (`getUserMedia`).

1. Start web app:

```bash
cd ../AuriSign-Web/client
npm run dev:mobile
```

2. Reverse port to your connected Android device:

```bash
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" reverse tcp:5173 tcp:5173
```

3. Run Flutter app:

```bash
flutter run -d <device-id>
```

Default WebView URL is now `http://localhost:5173/gesture-recognition`.

### One-command launcher (Windows PowerShell)

From `auri_sign`:

```bash
powershell -ExecutionPolicy Bypass -File .\scripts\run_mobile_webview.ps1 -DeviceId <device-id>
```

What it does automatically:
- checks `adb`
- runs `adb reverse tcp:5173 tcp:5173`
- starts web client if not running
- runs Flutter with `WEB_VIEWER_URL=http://localhost:5173/gesture-recognition`

### No manual command each run (VS Code)

This repo now includes:
- `.vscode/tasks.json`
- `.vscode/launch.json`

How to use:
1. Open `auri_sign` in VS Code.
2. Go to **Run and Debug**.
3. Select **Flutter: Mobile WebView (Auto Setup)**.
4. Press **Start Debugging (F5)**.

VS Code will automatically:
- prepare `adb reverse`
- start web client if needed
- launch Flutter on your device

Note: You still need your phone connected with USB debugging enabled, because the web model runs from your local machine.

Important: If you run plain `flutter run` (without the setup task/script), the app may show "Unable to load web viewer" because `adb reverse` or the web client might not be ready yet.

Safe order every time:
1. Run setup script (`-NoFlutter`) or use the VS Code auto setup launch.
2. Start Flutter only after setup succeeds.

### Troubleshooting: "Unable to load web viewer"

Run these checks in order:

1. Confirm Android device is connected:

```bash
"%LOCALAPPDATA%\\Android\\Sdk\\platform-tools\\adb.exe" devices
```

2. Confirm reverse mapping exists:

```bash
"%LOCALAPPDATA%\\Android\\Sdk\\platform-tools\\adb.exe" reverse --list
```

You should see `tcp:5173 tcp:5173` for your device.

3. Confirm web route is up on host:

```bash
Invoke-WebRequest -Uri "http://localhost:5173/gesture-recognition" -UseBasicParsing | Select-Object -ExpandProperty StatusCode
```

Expected output: `200`

4. Relaunch with the one-command script:

```bash
powershell -ExecutionPolicy Bypass -File .\\scripts\\run_mobile_webview.ps1 -DeviceId <device-id>
```

- Default URL: `http://localhost:5173/gesture-recognition`
- Override full URL:

```bash
flutter run --dart-define=WEB_VIEWER_URL=http://<your-ip>:5173/gesture-recognition
```

- Or override host only (keeps `/gesture-recognition` path):

```bash
flutter run --dart-define=WEB_APP_HOST=<your-ip>
```
