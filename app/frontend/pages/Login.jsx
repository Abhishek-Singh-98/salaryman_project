import { useState } from "react";

export default function Login() {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const [companyCode, setCompanyCode] = useState("");

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const token = document.querySelector('meta[name="csrf-token"]')?.content;
            const response = await fetch("/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    ...(token ? { "X-CSRF-Token": token } : {}),
                },
                credentials: "same-origin",
                body: JSON.stringify({
                    auth: {
                        email,
                        password,
                        company_code: companyCode
                    }
                }),
            });

            const data = await response.json();

            if (response.ok) {
                localStorage.setItem("loggedIn", "true")
                console.log("Login successful");
                window.location.href = "/dashboard";
            } else {
                console.error("Login failed");
                alert(data.error);
            }
        } catch (error) {
            console.error("Error during login:", error);
            alert("An error occurred during login. Please try again later.");
        }
    };

    const containerStyle = {
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        minHeight: "calc(100vh - 96px)",
        background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
        padding: "20px",
    };

    const cardStyle = {
        background: "#ffffff",
        borderRadius: "12px",
        boxShadow: "0 10px 30px rgba(0, 0, 0, 0.3)",
        padding: "40px",
        width: "100%",
        maxWidth: "500px",
        textAlign: "center",
    };

    const titleStyle = {
        color: "#333333",
        fontSize: "2rem",
        fontWeight: "bold",
        marginBottom: "30px",
    };

    const formStyle = {
        display: "flex",
        flexDirection: "column",
        gap: "20px",
    };

    const inputGroupStyle = {
        textAlign: "left",
    };

    const labelStyle = {
        display: "block",
        color: "#555555",
        fontWeight: "500",
        marginBottom: "5px",
    };

    const inputStyle = {
        width: "100%",
        padding: "12px",
        border: "1px solid #dddddd",
        borderRadius: "6px",
        fontSize: "1rem",
        boxSizing: "border-box",
        transition: "border-color 0.3s",
    };

    const buttonStyle = {
        background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
        color: "#ffffff",
        border: "none",
        borderRadius: "6px",
        padding: "12px",
        fontSize: "1rem",
        fontWeight: "bold",
        cursor: "pointer",
        transition: "transform 0.2s",
        marginTop: "10px",
    };

    return (
        <div style={containerStyle}>
            <div style={cardStyle}>
                <h2 style={titleStyle}>Welcome Back</h2>
                <form onSubmit={handleSubmit} style={formStyle}>
                    <div style={inputGroupStyle}>
                        <label style={labelStyle}>Email:</label>
                        <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            style={inputStyle}
                        />
                    </div>
                    <div style={inputGroupStyle}>
                        <label style={labelStyle}>Password:</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                            style={inputStyle}
                        />
                    </div>
                    <div style={inputGroupStyle}>
                        <label style={labelStyle}>Company Code:</label>
                        <input
                            type="text"
                            value={companyCode}
                            onChange={(e) => setCompanyCode(e.target.value)}
                            required
                            style={inputStyle}
                        />
                    </div>
                    <button type="submit" style={buttonStyle}>Login</button>
                </form>
            </div>
        </div>
    );
}
