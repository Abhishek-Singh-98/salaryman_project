import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

export default function NewEmployee() {
  const navigate = useNavigate();
  const [fullName, setFullName] = useState("");
  const [salary, setSalary] = useState("");
  const [email, setEmail] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [joiningDate, setJoiningDate] = useState("");
  const [jobTitleId, setJobTitleId] = useState("");
  const [jobTitles, setJobTitles] = useState([]);
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    fetch("/job_titles")
      .then(res => res.json())
      .then(data => {
        console.log("Fetched job titles:", data);
        if (Array.isArray(data)) {
          setJobTitles(data);
        }
      })
      .catch(() => setJobTitles([]));
  }, []);

  const handleJobTitleIdChange = (value) => {
    setJobTitleId(value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage("");

    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const response = await fetch("/employees", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { "X-CSRF-Token": token } : {}),
      },
      credentials: "same-origin",
      body: JSON.stringify({
        employee: {
          full_name: fullName,
          salary: salary ? parseInt(salary, 10) : null,
          password,
          password_confirmation: passwordConfirmation,
          profile_attributes: {
            email,
            phone_number: phoneNumber,
            date_of_birth: dateOfBirth,
            joining_date: joiningDate,
          },
          job_title_id: jobTitleId || null,
        },
      }),
    });

    const data = await response.json();

    if (response.ok) {
      navigate("/employees");
    } else {
      setErrorMessage(data.errors?.join(", ") || data.error || "Unable to create employee.");
    }
  };

  const formContainerStyle = {
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    minHeight: "calc(100vh - 96px)",
    padding: "20px",
    background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
  };

  const cardStyle = {
    background: "#ffffff",
    borderRadius: "12px",
    boxShadow: "0 10px 30px rgba(0, 0, 0, 0.12)",
    width: "100%",
    maxWidth: "720px",
    padding: "36px",
  };

  const rowStyle = {
    display: "grid",
    gridTemplateColumns: "1fr 1fr",
    gap: "20px",
  };

  const inputGroupStyle = {
    display: "flex",
    flexDirection: "column",
    marginBottom: "16px",
  };

  const inputStyle = {
    padding: "12px",
    border: "1px solid #dddddd",
    borderRadius: "8px",
    fontSize: "1rem",
  };

  const labelStyle = {
    marginBottom: "6px",
    fontWeight: 600,
    color: "#333333",
  };

  const buttonStyle = {
    background: "#7c3aed",
    color: "#ffffff",
    border: "none",
    borderRadius: "8px",
    padding: "14px 20px",
    cursor: "pointer",
    fontWeight: 600,
  };

  const selectStyle = {
    padding: "10px",
    border: "1px solid #d1d5db",
    borderRadius: "6px",
    fontSize: "1rem",
  };

  return (
    <div style={formContainerStyle}>
      <div style={cardStyle}>
        <h2 style={{ marginBottom: "24px" }}>Add New Employee</h2>
        {errorMessage && (
          <div style={{ marginBottom: "20px", color: "#b91c1c" }}>{errorMessage}</div>
        )}
        <form onSubmit={handleSubmit}>
          <div style={rowStyle}>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Full Name</label>
              <input
                type="text"
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Salary</label>
              <input
                type="number"
                min="0"
                value={salary}
                onChange={(e) => setSalary(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>

          <div style={rowStyle}>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Job Title</label>
              <select 
                style={inputStyle} 
                value={jobTitleId} 
                onChange={(e) => handleJobTitleIdChange(e.target.value)}
              >
                <option value="">Select Job Title</option>
                {jobTitles.map((jt) => (
                  <option key={jt.id} value={jt.id}>
                    {jt.title}
                  </option>
                ))}
              </select>
            </div>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>

          <div style={rowStyle}>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Phone Number</label>
              <input
                type="tel"
                value={phoneNumber}
                onChange={(e) => setPhoneNumber(e.target.value)}
                style={inputStyle}
              />
            </div>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Joining Date</label>
              <input
                type="date"
                value={joiningDate}
                onChange={(e) => setJoiningDate(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>

          <div style={rowStyle}>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Date of Birth</label>
              <input
                type="date"
                value={dateOfBirth}
                onChange={(e) => setDateOfBirth(e.target.value)}
                style={inputStyle}
              />
            </div>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Password</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>

          <div style={inputGroupStyle}>
            <label style={labelStyle}>Confirm Password</label>
            <input
              type="password"
              value={passwordConfirmation}
              onChange={(e) => setPasswordConfirmation(e.target.value)}
              required
              style={inputStyle}
            />
          </div>

          <div style={{ display: "flex", gap: "12px", marginTop: "24px" }}>
            <button type="submit" style={buttonStyle}>Create Employee</button>
            <button
              type="button"
              onClick={() => navigate("/employees")}
              style={{ ...buttonStyle, background: "#e5e7eb", color: "#111827" }}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
