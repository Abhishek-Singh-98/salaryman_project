import { Link, useLocation } from "react-router-dom"

const navStyle = {
  position: "fixed",
  top: 0,
  left: 0,
  right: 0,
  height: "56px",
  background: "#202940",
  color: "#ffffff",
  display: "flex",
  alignItems: "center",
  justifyContent: "space-between",
  padding: "0 20px",
  zIndex: 1000,
  boxShadow: "0 2px 8px rgba(0, 0, 0, 0.2)",
}

const linksStyle = {
  display: "flex",
  alignItems: "center",
  gap: "16px",
}

const linkStyle = {
  color: "#e2e8f0",
  textDecoration: "none",
  fontWeight: 500,
}

const activeStyle = {
  color: "#ffffff",
  borderBottom: "2px solid #7c3aed",
  paddingBottom: "2px",
}

export default function Navbar({ loggedIn, onLogout }) {
  const location = useLocation()

  const renderLink = (to, label) => {
    const isActive = location.pathname === to
    return (
      <Link to={to} style={{ ...linkStyle, ...(isActive ? activeStyle : {}) }}>
        {label}
      </Link>
    )
  }

  return (
    <nav style={navStyle}>
      <div style={{ fontWeight: 1000, fontSize: "2rem" }}>Salary-Man</div>
      <div style={linksStyle}>
        {!loggedIn ? (
          <>
            {renderLink("/", "Login")}
            {renderLink("/signup", "Signup")}
          </>
        ) : (
          <>
            {renderLink("/dashboard", "Dashboard")}
            {renderLink("/employees", "Employees List")}
            {renderLink(`/employees/${localStorage.getItem("employeeId")}`, "My Profile")}
            {renderLink("/salary_insights", "Salary Insight")}
            <button
              type="button"
              onClick={onLogout}
              style={{
                background: "transparent",
                border: "1px solid #7c3aed",
                color: "#ffffff",
                borderRadius: "4px",
                padding: "6px 12px",
                cursor: "pointer",
              }}
            >
              Logout
            </button>
          </>
        )}
      </div>
    </nav>
  )
}
