console.log("Hello from Vite and React!")

import React from "react"
import ReactDOM from "react-dom/client"
import App from "../pages/App"

const el = document.getElementById("root")

if (el) {
  console.log("ROOT FOUND");
  ReactDOM.createRoot(el).render(<App />)
} else {
  console.error("Root element not found")
}