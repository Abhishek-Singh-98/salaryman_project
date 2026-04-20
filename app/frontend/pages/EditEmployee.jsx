import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

export default function EditEmployee() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [fullName, setFullName] = useState("");
  const [empNumber, setEmpNumber] = useState("");
  const [salary, setSalary] = useState("");
  const [email, setEmail] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [dateOfBirth, setDateOfBirth] = useState("");
  const [joiningDate, setJoiningDate] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [errorMessage, setErrorMessage] = useState("");
  const [loading, setLoading] = useState(true);
  const [jobTitleId, setJobTitleId] = useState("");
  const [jobTitles, setJobTitles] = useState([]);

  useEffect(() => {
    fetch(`/employees/${id}`)
      .then(response => response.json())
      .then(data => {
        if (data.id) {
          setFullName(data.full_name || "");
          setEmpNumber(data.emp_number || "");
          setSalary(data.salary || "");
          setEmail(data.profile?.email || "");
          setPhoneNumber(data.profile?.phone_number || "");
          setDateOfBirth(data.profile?.date_of_birth || "");
          setJoiningDate(data.profile?.joining_date || "");
          setJobTitleId(data.employee_job_title?.job_title_id || "");
        } else {
          setErrorMessage("Employee not found");
        }
        setLoading(false);
      })
      .catch(error => {
        console.error("Error fetching employee:", error);
        setErrorMessage("Failed to load employee");
        setLoading(false);
      });
  }, [id]);

  useEffect(() => {
    fetch("/job_titles")
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setJobTitles(data);
        }
      })
      .catch(() => setJobTitles([]));
  }, []);

  const handleJobTitleChange = (value) => {
    setJobTitleId(value);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setErrorMessage("");

    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const response = await fetch(`/employees/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { "X-CSRF-Token": token } : {}),
      },
      credentials: "same-origin",
      body: JSON.stringify({
        employee: {
          full_name: fullName,
          emp_number: empNumber,
          salary: salary ? parseInt(salary, 10) : null,
          ...(password && { password, password_confirmation: passwordConfirmation }),
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
      setErrorMessage(data.errors?.join(", ") || data.error || "Unable to update employee.");
    }
  };

  if (loading) return <div>Loading...</div>;
  if (errorMessage && !fullName) return <div>{errorMessage}</div>;

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

  return (
    <div style={formContainerStyle}>
      <div style={cardStyle}>
        <h2 style={{ marginBottom: "24px" }}>Edit Employee</h2>
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
              <label style={labelStyle}>Employee Number</label>
              <input
                type="text"
                value={empNumber}
                onChange={(e) => setEmpNumber(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>

          <div style={rowStyle}>
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
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Job Title</label>
              <select
                style={inputStyle}
                value={jobTitleId}
                onChange={(e) => handleJobTitleChange(e.target.value)}
              >
                <option value="">Select Job Title</option>
                {jobTitles.map((jt) => (
                  <option key={jt.id} value={jt.id}>
                    {jt.title}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div style={rowStyle}>
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
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Phone Number</label>
              <input
                type="tel"
                value={phoneNumber}
                onChange={(e) => setPhoneNumber(e.target.value)}
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
              <label style={labelStyle}>New Password (optional)</label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                style={inputStyle}
              />
            </div>
            <div style={inputGroupStyle}>
              <label style={labelStyle}>Confirm New Password</label>
              <input
                type="password"
                value={passwordConfirmation}
                onChange={(e) => setPasswordConfirmation(e.target.value)}
                required={password}
                style={inputStyle}
              />
            </div>
          </div>



          <div style={{ display: "flex", gap: "12px", marginTop: "24px" }}>
            <button type="submit" style={buttonStyle}>Update Employee</button>
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