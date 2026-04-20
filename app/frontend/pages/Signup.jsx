import { useState } from "react";

export default function Signup() {
    const [email, setEmail] = useState("");
    const [joining_date, setJoiningDate] = useState("");
    const [password, setPassword] = useState("");
    const [passwordConfirmation, setPasswordConfirmation] = useState("");
    const [companyCode, setCompanyCode] = useState("");
    const [fullName, setFullName] = useState("");

    const handleSubmit = async (e) => {
        e.preventDefault();

        const token = document.querySelector('meta[name="csrf-token"]').content;
        const response = await fetch("/signup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-Token": token,
            },
            credentials: "same-origin",
            body: JSON.stringify({
                auth: {
                    email,
                    password,
                    password_confirmation: passwordConfirmation,
                    company_code: companyCode,
                    full_name: fullName
                }
            }),
        });

        const data = await response.json();

        if (response.ok) {
            localStorage.setItem("loggedIn", "true")
            localStorage.setItem("employeeId", data.id);
            console.log("Signup successful");
            window.location.href = "/dashboard";
        } else {
            console.error("Signup failed");
            alert(data.error || data.errors?.join(', '));
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
        maxWidth: "600px",
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

    const rowStyle = {
        display: "flex",
        gap: "30px",
    };

    const inputGroupStyle = {
        textAlign: "left",
        flex: 1,
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
                <h2 style={titleStyle}>Create Your Account</h2>
                <form onSubmit={handleSubmit} style={formStyle}>
                    <div style={rowStyle}>
                        <div style={inputGroupStyle}>
                            <label style={labelStyle}>Full Name:</label>
                            <input
                                type="text"
                                value={fullName}
                                onChange={(e) => setFullName(e.target.value)}
                                required
                                style={inputStyle}
                            />
                        </div>
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
                    </div>
                    <div style={inputGroupStyle}>
                        <label style={labelStyle}>Date Of Joining:</label>
                        <input
                            type="date"
                            value={joining_date}
                            onChange={(e) => setJoiningDate(e.target.value)}
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
                        <label style={labelStyle}>Confirm Password:</label>
                        <input
                            type="password"
                            value={passwordConfirmation}
                            onChange={(e) => setPasswordConfirmation(e.target.value)}
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
                    <button type="submit" style={buttonStyle}>Sign Up</button>
                </form>
            </div>
        </div>
    );
}