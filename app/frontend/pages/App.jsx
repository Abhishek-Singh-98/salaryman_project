import React, { useEffect, useState } from 'react'
import { BrowserRouter, Routes, Route, useNavigate } from "react-router-dom";
import Navbar from "../components/Navbar";
import Login from "./Login";
import Signup from "./Signup";
import Dashboard from "./Dashboard";
import EmployeesList from "./EmployeesList";
import MyProfile from "./MyProfile";
import SalaryInsight from "./SalaryInsight";

function AppRoutes({ loggedIn, setLoggedIn }) {
  const navigate = useNavigate()

  const handleLogout = async () => {
    await fetch("/logout", {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
      credentials: "same-origin",
    })

    localStorage.removeItem("loggedIn")
    setLoggedIn(false)
    navigate("/")
  }

  return (
    <>
      <Navbar loggedIn={loggedIn} onLogout={handleLogout} />
      <div style={{ paddingTop: "72px", padding: "24px" }}>
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/employees" element={<EmployeesList />} />
          <Route path="/my_profile" element={<MyProfile />} />
          <Route path="/salary_insight" element={<SalaryInsight />} />
        </Routes>
      </div>
    </>
  )
}

export default function App() {
  const [loggedIn, setLoggedIn] = useState(false)

  useEffect(() => {
    setLoggedIn(localStorage.getItem("loggedIn") === "true")
  }, [])

  return (
    <BrowserRouter>
      <AppRoutes loggedIn={loggedIn} setLoggedIn={setLoggedIn} />
    </BrowserRouter>
  )
}
