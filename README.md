## **Solarium**

Solarium is an iOS app that lets you explore Mars and space using open data from NASA. The app features two main screens: a 3D model of Mars with real-time weather data, and a gallery of astronomical objects with descriptions.

**Note:** All data is loaded directly from NASA's public API. The app does not use a database — everything is displayed on the fly.

---

## **Ссылки**

[API Nasa](https://api.nasa.gov)

---

## **Tech Stack**
- **Language:** Swift  
- **Framework:** SwiftUI  
- **3D Graphics:** SceneKit
- **Networking:** URLSession  
- **Platform:** iOS (minimum version — 16)
- **Devices:** any, starting from iPhone 8

---

## **Features**

### 1. MarsWeather Screen

- 3D model of Mars (SceneKit) — rotatable and zoomable.
- Real-time weather data on Mars from NASA's public API.
- Loading indicator while fetching data.
<img width="573" height="480" alt="MarsWeather screen" src="https://github.com/user-attachments/assets/d0c1eaf9-6114-4ae0-9184-cd4819ed460d" />

### 2. AstronomyPicture Screen
- Fetches a list of astronomical objects (images + titles).
- Tap on a title to open a detailed view with the full image and description.
- All data is decoded from JSON received via URLSession.
<img width="573" height="480" alt="AstronomyPicture list" src="https://github.com/user-attachments/assets/965f8a97-b0d4-4763-8cca-26cdd0bdee5a" />
<img width="573" height="480" alt="AstronomyPicture list" src="https://github.com/user-attachments/assets/0cf8bd2e-d64c-4b6c-8261-0d0fd8652810" />

### 3. Data Loading
- Loading screen is shown while data is being fetched.
- Handles poor network conditions with error handling.
<img width="573" height="480" alt="AstronomyPicture list" src="https://github.com/user-attachments/assets/7086e583-156b-4e41-874f-74b89d761684" />

### 4. Adaptive Interface
- Supports all devices from iPhone 8 and newer.
- Minimum iOS version — 16.
- Simple navigation between two screens.

### 5. Clean Architecture
- No database — only live data from the API.
- SwiftUI code with clear separation of logic and presentation.
