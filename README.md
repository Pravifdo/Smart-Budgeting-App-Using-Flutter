# Smart Finance App

A comprehensive full-stack application designed to help users manage their personal finances. Users can track their income and expenses, view their financial overview on a dashboard, and manage their profile with persistent data storage.

## 🚀 Features

- **User Authentication**: Secure Login and Registration using JWT.
- **Dashboard**: A clean overview of total balance, total income, and total expenses.
- **Expense Tracking**: Add and categorize expenses.
- **Income Tracking**: Add and track different sources of income.
- **Transaction History**: View a list of all recent financial activities.
- **Profile Management**: 
  - View account details (Email, Occupation, Location).
  - Upload and save profile images to the database (Base64 encoding).
  - Logout functionality to clear sessions.
- **Responsive UI**: Built with Flutter for a smooth, premium experience on mobile and web.

## 🛠️ Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter (Dart)
- **State Management**: StatefulWidget
- **API Communication**: `http` package
- **Image Handling**: `image_picker` with base64 conversion
- **Design**: Modern, clean Material Design

### Backend (Node.js & Express)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB (Mongoose ODM)
- **Authentication**: JSON Web Tokens (JWT)
- **Security**: Password hashing with bcrypt
- **CORS**: Enabled for cross-origin requests

## 📂 Project Structure

```text
fanashita_app/
├── backend/                # Node.js Express server
│   ├── config/             # Database connection
│   ├── controllers/        # Business logic for routes
│   ├── middleware/         # Auth & error middleware
│   ├── models/             # Mongoose schemas (User, Expense, Income)
│   ├── routes/             # API endpoints
│   └── server.js           # Entry point
└── frontend/               # Flutter application
    ├── lib/
    │   ├── models/         # Data models
    │   ├── screens/        # UI Screens (Dashboard, Profile, Login, etc.)
    │   ├── services/       # API interaction layer
    │   └── main.dart       # App entry point
    └── pubspec.yaml        # Dependencies
```

## ⚙️ Getting Started

### Prerequisites
- Node.js & npm installed
- Flutter SDK installed
- MongoDB connection string

### Backend Setup
1. Navigate to the `backend` folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file and add your `MONGO_URI` and `JWT_SECRET`.
4. Start the server:
   ```bash
   npm run dev
   ```

### Frontend Setup
1. Navigate to the `frontend` folder:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

# 📸 Application Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/3fd87913-43be-4373-be7e-2e9c3242d20d" width="300"/>
  <img src="https://github.com/user-attachments/assets/8c330d3e-aaae-4db4-9f77-abda4c6efd53" width="300"/>
  <img src="https://github.com/user-attachments/assets/d7c0295f-c6c8-4701-99b4-d23ba2b2f983" width="300"/>
</p>




## 📄 License
This project is for educational purposes.
