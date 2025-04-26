# 📚 Booksy App - Flutter Developer Technical Task

## 🚀 Overview
**Booksy** is a Flutter application for browsing and exploring books using the Project Gutenberg library through the Gutendex API.  
The app focuses on delivering a smooth, friendly, and responsive user experience across both mobile and tablet devices.

---

## ✨ Features

- **Custom Splash Screen** with simple animation displaying the app name Booksy.
- **Modern and clean UI** for browsing books easily.
- **Enhanced UX**:
  - A **scroll-to-top button** appears when users scroll deep down the book list, allowing quick navigation back to the top.
- **Book List Screen**:
  - Displays book cover images, titles, authors, and summary.
  - Book summaries are initially collapsed with a **"See More/See Less"** toggle functionality.
- **Search Functionality**:
  - Allows users to search for books using keywords.
  - Fully supports pagination with infinite scrolling during search results.
- **Offline Caching (Bonus Feature)**:
  - Implemented using **Hive local database** to cache book data (both listing and search results).
  - If the device is offline, previously fetched books are displayed.
- **Responsive Design**:
  - Optimized for both mobile and tablet screen sizes.
- **Error Handling**:
  - Graceful handling of network issues and missing data.
- **Friendly Color Scheme**:
  - Primary Color: `#1d202b`
  - Secondary Color: `#f67a4b`

---

## 🛠️ Technical Stack

- **State Management**: Cubit (from flutter_bloc)
- **Architecture**: Clean Code Architecture
- **Networking**: Dio
- **Local Storage**: Hive
- **Animations**: Built-in Flutter animations for splash screen
- **Responsive Layout**: MediaQuery, LayoutBuilder

---

## 📅 Installation and Running the App

1. Clone the repository:
   ```bash
   git clone https://github.com/AhmedSaied22/booksy
   cd booksy
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters (if needed):
   ```bash
   flutter packages pub run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

> Make sure you have an emulator running or a device connected.

---

## 📷 Screenshots

### Splash Screen
![Splash Screen](assets/screenshots/splash.png)

### Book List Screen
![Book List](assets/screenshots/book_list.png)


---

## 📎 Links

- 📱 [Google Drive APK Link](https://drive.google.com/drive/u/0/folders/1TV2jtV6t_jgC4omtRGQLS7_guL7wrU5K)
- 💻 [GitHub Repository](https://github.com/AhmedSaied22/booksy)

---

## 👨‍💼 Developed by

**Ahmed Said**

- [LinkedIn](https://www.linkedin.com/in/ahmed-saieed)
- [GitHub](https://github.com/AhmedSaied22)

---

Thank you for reviewing my project! 😊
