// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBMHKZ9qQ0y-wS899ZSjQbd1aL0bbLtRY4",
  authDomain: "sportlink-ad4ba.firebaseapp.com",
  projectId: "sportlink-ad4ba",
  storageBucket: "sportlink-ad4ba.firebasestorage.app",
  messagingSenderId: "378415900317",
  appId: "1:378415900317:web:36794ad050a174a2529674",
  measurementId: "G-2V08XEEHSC"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);