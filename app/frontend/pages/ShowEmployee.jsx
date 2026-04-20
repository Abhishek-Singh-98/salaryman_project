import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

export default function ShowEmployee() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [employee, setEmployee] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetch(`/employees/${id}`)
      .then(response => response.json())
      .then(data => {
        if (data.id) {
          setEmployee(data);
        } else {
          setError("Employee not found");
        }
        setLoading(false);
      })
      .catch(error => {
        console.error("Error fetching employee:", error);
        setError("Failed to load employee");
        setLoading(false);
      });
  }, [id]);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>{error}</div>;

  const containerStyle = {
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
    maxWidth: "600px",
    padding: "36px",
  };

  const fieldStyle = {
    marginBottom: "16px",
  };

  const labelStyle = {
    fontWeight: 600,
    color: "#333333",
  };

  const valueStyle = {
    marginTop: "4px",
    color: "#555555",
  };

  const buttonStyle = {
    background: "#7c3aed",
    color: "#ffffff",
    border: "none",
    borderRadius: "8px",
    padding: "10px 16px",
    cursor: "pointer",
    marginRight: "8px",
  };

  return (
    <div style={containerStyle}>
      <div style={cardStyle}>
        <h2>Employee Details</h2>
        <div style={fieldStyle}>
          <div style={labelStyle}>ID:</div>
          <div style={valueStyle}>{employee.id}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Full Name:</div>
          <div style={valueStyle}>{employee.full_name}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Employee Number:</div>
          <div style={valueStyle}>{employee.emp_number}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Email:</div>
          <div style={valueStyle}>{employee.profile?.email || "N/A"}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Phone Number:</div>
          <div style={valueStyle}>{employee.profile?.phone_number || "N/A"}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Date of Birth:</div>
          <div style={valueStyle}>{employee.profile?.date_of_birth || "N/A"}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Joining Date:</div>
          <div style={valueStyle}>{employee.profile?.joining_date || "N/A"}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Role:</div>
          <div style={valueStyle}>{employee.role}</div>
        </div>
        <div style={fieldStyle}>
          <div style={labelStyle}>Salary:</div>
          <div style={valueStyle}>${employee.salary?.toLocaleString()}</div>
        </div>
        <div style={{ marginTop: "24px" }}>
          <button
            onClick={() => navigate(`/employees/${id}/edit`)}
            style={buttonStyle}
          >
            Edit
          </button>
          <button
            onClick={() => navigate("/employees")}
            style={{ ...buttonStyle, background: "#e5e7eb", color: "#111827" }}
          >
            Back to List
          </button>
        </div>
      </div>
    </div>
  );
}