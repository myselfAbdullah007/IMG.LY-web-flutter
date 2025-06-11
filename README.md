# Flutter Web App with img.ly Integration

This project demonstrates how to integrate the img.ly CreativeEditor SDK into a Flutter web app using an iframe and JavaScript interop.

## Overview

- The app uses a Flutter web project with an iframe to load the img.ly editor.
- Communication between Flutter and the editor is done via `postMessage`.
- The editor is loaded from a local HTML file (`assets/editor.html`).

## Files to Change and How to Do It All

### 1. **Project Structure**
- **`lib/main.dart`:** Contains the Flutter app code. No changes needed unless you want to modify the UI or behavior.
- **`assets/editor.html`:** Contains the img.ly editor integration. This is where you add your license key and configure the editor.

### 2. **Adding the License Key**
- Open `assets/editor.html`.
- Locate the `defaultConfig` object in the script section:
  ```js
  const defaultConfig = {
    license: '', // Add your img.ly license here
    ui: {
      elements: {
        navigation: {
          show: true,
          position: 'bottom'
        }
      }
    }
  };
  ```
- Replace the empty string with your license key:
  ```js
  license: 'your-license-key-here',
  ```
- Save the file.

### 3. **Building and Running Locally**
- **Install dependencies:**
  ```bash
  flutter pub get
  ```
- **Run the app locally:**
  ```bash
  flutter run -d chrome
  ```



### 4. **Troubleshooting**
- **Editor Not Loading:** Check the browser console for errors. Ensure the img.ly SDK is loaded and the license is valid.
- **CORS Issues:** Run the app using `flutter run -d chrome` to avoid CORS issues.

---

For more details, refer to the [img.ly documentation](https://img.ly/docs/cesdk/getting-started/web/).
