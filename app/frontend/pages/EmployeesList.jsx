import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function EmployeesList() {
  const navigate = useNavigate();
  const [employees, setEmployees] = useState([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchEmployees = (page = 1) => {
    fetch(`/employees?page=${page}`)
      .then(response => response.json())
      .then(data => {
        if (data && Array.isArray(data.employees)) {
          setEmployees(data.employees);
          setTotalPages(data.pagination.total_pages || 1);
        } else {
          alert(data.message || "Unexpected response format");
          console.warn("Employees response was not an array:", data);
          setEmployees([]);
          setTotalPages(1);
        }
      })
      .catch(error => console.error("Error fetching employees:", error));
  };

  useEffect(() => {
    fetchEmployees(currentPage);
  }, [currentPage]);

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
      fetchEmployees(currentPage);
    } else {
      alert("Failed to delete employee");
    }
  };

  const handlePrev = () => {
    if (currentPage > 1) setCurrentPage(p => p - 1);
  };

  const handleNext = () => {
    if (currentPage < totalPages) setCurrentPage(p => p + 1);
  };

  const isFirst = currentPage === 1;
  const isLast  = currentPage === totalPages;

  const employeeList = Array.isArray(employees) ? employees : [];

  const arrowStyle = (disabled) => ({
    width: "44px",
    height: "44px",
    fontSize: "28px",
    fontWeight: "900",
    lineHeight: "1",
    display: "flex",
    alignItems: "center",
    justifyContent: "center",
    border: `3px solid ${disabled ? "#d1d5db" : "#7c3aed"}`,
    borderRadius: "8px",
    background: "transparent",
    color: disabled ? "#d1d5db" : "#7c3aed",
    cursor: disabled ? "not-allowed" : "pointer",
  });

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
        <>
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
                      style={{ background: "#10b981", color: "#ffffff", border: "none", borderRadius: "4px", padding: "4px 8px", cursor: "pointer", marginRight: "4px" }}
                    >
                      Show
                    </button>
                    <button
                      onClick={() => navigate(`/employees/${employee.id}/edit`)}
                      style={{ background: "#f59e0b", color: "#ffffff", border: "none", borderRadius: "4px", padding: "4px 8px", cursor: "pointer", marginRight: "4px" }}
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(employee.id)}
                      style={{ background: "#ef4444", color: "#ffffff", border: "none", borderRadius: "4px", padding: "4px 8px", cursor: "pointer" }}
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {totalPages > 1 && (
            <div style={{ display: "flex", alignItems: "center", justifyContent: "center", gap: "20px", marginTop: "28px" }}>
              <button onClick={handlePrev} disabled={isFirst} style={arrowStyle(isFirst)}>
                &#8249;
              </button>

              <span style={{ fontSize: "15px", color: "#6b7280", minWidth: "120px", textAlign: "center" }}>
                Page <strong style={{ color: "#111827" }}>{currentPage}</strong> of <strong style={{ color: "#111827" }}>{totalPages}</strong>
              </span>

              <button onClick={handleNext} disabled={isLast} style={arrowStyle(isLast)}>
                &#8250;
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}