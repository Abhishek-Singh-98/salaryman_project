import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function EmployeesList() {
  const navigate = useNavigate();
  const [employees, setEmployees] = useState([]);

  useEffect(() => {
    fetch("/employees")
      .then(response => response.json())
      .then(data => {
        if (Array.isArray(data)) {
          setEmployees(data);
        } else {
          alert(data.message || "Unexpected response format");
          console.warn("Employees response was not an array:", data);
          setEmployees([]);
        }
      })
      .catch(error => console.error("Error fetching employees:", error));
  }, []);

  const handleDelete = async (id) => {
    if (!confirm("Are you sure you want to delete this employee?")) return;

    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    const response = await fetch(`/employees/${id}`, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        ...(token ? { "X-CSRF-Token": token } : {}),
      },
      credentials: "same-origin",
    });

    if (response.ok) {
      // Refresh the list
      fetch("/employees")
        .then(response => response.json())
        .then(data => {
          if (Array.isArray(data)) {
            setEmployees(data);
          } else {
            setEmployees([]);
          }
        })
        .catch(error => console.error("Error refreshing employees:", error));
    } else {
      alert("Failed to delete employee");
    }
  };

  const employeeList = Array.isArray(employees) ? employees : [];

  return (
    <div>
      <br /> <br />
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "16px" }}>
        <h1>Employees List</h1>
        <button
          type="button"
          onClick={() => navigate("/employees/new")}
          style={{
            background: "#7c3aed",
            color: "#ffffff",
            border: "none",
            borderRadius: "6px",
            padding: "10px 16px",
            cursor: "pointer",
          }}
        >
          Add New Employee
        </button>
      </div>
      {employeeList.length === 0 ? (
        <p>No employees available.</p>
      ) : (
        <table style={{ width: "100%", borderCollapse: "collapse", marginTop: "20px" }}>
          <thead>
            <tr>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>ID</th>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>Full Name</th>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>Email</th>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>Role</th>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>Salary</th>
              <th style={{ border: "1px solid #dddddd", padding: "8px" }}>Actions</th>
            </tr>
          </thead>
          <tbody>
            {employeeList.map(employee => (
              <tr key={employee.id}>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>{employee.id}</td>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>{employee.full_name}</td>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>{employee.profile?.email || ""}</td>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>{employee.role}</td>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>${employee.salary?.toLocaleString()}</td>
                <td style={{ border: "1px solid #dddddd", padding: "8px" }}>
                  <button
                    onClick={() => navigate(`/employees/${employee.id}`)}
                    style={{
                      background: "#10b981",
                      color: "#ffffff",
                      border: "none",
                      borderRadius: "4px",
                      padding: "4px 8px",
                      cursor: "pointer",
                      marginRight: "4px",
                    }}
                  >
                    Show
                  </button>
                  <button
                    onClick={() => navigate(`/employees/${employee.id}/edit`)}
                    style={{
                      background: "#f59e0b",
                      color: "#ffffff",
                      border: "none",
                      borderRadius: "4px",
                      padding: "4px 8px",
                      cursor: "pointer",
                      marginRight: "4px",
                    }}
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => handleDelete(employee.id)}
                    style={{
                      background: "#ef4444",
                      color: "#ffffff",
                      border: "none",
                      borderRadius: "4px",
                      padding: "4px 8px",
                      cursor: "pointer",
                    }}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}
