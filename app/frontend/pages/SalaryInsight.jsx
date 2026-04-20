import { useEffect, useState } from "react";

export default function SalaryInsight() {
  const [insights, setInsights] = useState(null);
  const [role, setRole] = useState("");
  const [jobTitleId, setJobTitleId] = useState("");
  const [countryId, setCountryId] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [roles] = useState(["hr_manager", "employee"]);
  const [jobTitles, setJobTitles] = useState([]);
  const [countries, setCountries] = useState([]);
  const [myCompanyInsight, setMyCompanyInsight] = useState(null);

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

  useEffect(() => {
    fetch("/countries")
      .then(res => res.json())
      .then(data => {
        if (Array.isArray(data)) {
          setCountries(data);
        }
      })
      .catch(() => setCountries([]));
  }, []);

  const fetchInsights = (selectedRole = "", selectedJobTitle = "", selectedCountry = "", isMyCompany = false) => {
    setLoading(true);
    setError("");

    const params = new URLSearchParams();
    if (selectedRole) params.append("role", selectedRole);
    if (selectedJobTitle) params.append("job_title_id", selectedJobTitle);
    if (selectedCountry) params.append("country_id", selectedCountry);
    if (isMyCompany) params.append("my_company_insight", "true");

    fetch(`/salary_insights?${params.toString()}`)
      .then(res => res.json())
      .then(data => {
        setInsights(data.insights);
        setLoading(false);
      })
      .catch(err => {
        console.error("Error fetching insights:", err);
        setError("Failed to load salary insights");
        setLoading(false);
      });
  };

  useEffect(() => {
    fetchInsights();
  }, []);

  const handleRoleChange = (value) => {
    setRole(value);
    fetchInsights(value, jobTitleId, countryId, myCompanyInsight);
  };

  const handleJobTitleChange = (value) => {
    setJobTitleId(value);
    fetchInsights(role, value, countryId, myCompanyInsight);
  };

  const handleCountryChange = (value) => {
    setCountryId(value);
    fetchInsights(role, jobTitleId, value, myCompanyInsight);
  };

  const handleMyCompanyInsight = () => {
    const newStatus = !myCompanyInsight;
    setMyCompanyInsight(newStatus);
    setRole("");
    setJobTitleId("");
    setCountryId("");
    fetchInsights("", "", "", newStatus);
  };

  const handleResetFilters = () => {
    setRole("");
    setJobTitleId("");
    setCountryId("");
    setMyCompanyInsight(null);
    fetchInsights("", "", "", null);
  };

  const containerStyle = {
    padding: "24px",
    background: "#f9fafb",
    minHeight: "calc(100vh - 96px)",
  };

  const headerStyle = {
    marginBottom: "24px",
  };

  const titleStyle = {
    fontSize: "2rem",
    fontWeight: "bold",
    color: "#1f2937",
    marginBottom: "8px",
  };

  const subtitleStyle = {
    color: "#6b7280",
    fontSize: "0.95rem",
  };

  const filtersStyle = {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
    gap: "16px",
    marginBottom: "24px",
    background: "#ffffff",
    padding: "16px",
    borderRadius: "8px",
    boxShadow: "0 1px 3px rgba(0,0,0,0.1)",
  };

  const selectStyle = {
    padding: "10px",
    border: "1px solid #d1d5db",
    borderRadius: "6px",
    fontSize: "1rem",
  };

  const buttonStyle = {
    padding: "10px 16px",
    background: "#ef4444",
    color: "#ffffff",
    border: "none",
    borderRadius: "6px",
    cursor: "pointer",
    fontWeight: "500",
  };

  const insightsGridStyle = {
    display: "grid",
    gridTemplateColumns: "repeat(auto-fit, minmax(300px, 1fr))",
    gap: "20px",
    marginBottom: "24px",
  };

  const cardStyle = {
    background: "#ffffff",
    padding: "20px",
    borderRadius: "8px",
    boxShadow: "0 4px 6px rgba(0,0,0,0.1)",
  };

  const cardTitleStyle = {
    fontSize: "1.25rem",
    fontWeight: "600",
    color: "#1f2937",
    marginBottom: "16px",
    textTransform: "capitalize",
  };

  const metricsStyle = {
    display: "grid",
    gap: "12px",
  };

  const metricRowStyle = {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center",
    padding: "12px",
    background: "#f3f4f6",
    borderRadius: "6px",
  };

  const metricLabelStyle = {
    color: "#6b7280",
    fontWeight: "500",
  };

  const metricValueStyle = {
    color: "#1f2937",
    fontWeight: "bold",
    fontSize: "1.1rem",
  };

  const averageColorStyle = {
    ...metricValueStyle,
    color: "#3b82f6",
  };

  const minColorStyle = {
    ...metricValueStyle,
    color: "#10b981",
  };

  const maxColorStyle = {
    ...metricValueStyle,
    color: "#f59e0b",
  };

  if (loading) return <div style={containerStyle}><p>Loading salary insights...</p></div>;
  if (error) return <div style={containerStyle}><p style={{ color: "#dc2626" }}>{error}</p></div>;

  return (
    <div style={containerStyle}>
      <div style={headerStyle}>
        <h1 style={titleStyle}>Salary Insights</h1>
        <p style={subtitleStyle}>Analyze salary distribution based on role and job title</p>
      </div>

      {/* Filters */}
      <div style={filtersStyle}>
        <div>
          <label style={{ display: "block", marginBottom: "6px", fontWeight: "500", color: "#374151" }}>Role</label>
          <select style={selectStyle} value={role} onChange={(e) => handleRoleChange(e.target.value)}>
            <option value="">All Roles</option>
            {roles.map((r) => (
              <option key={r} value={r}>
                {r.replace(/_/g, " ").toUpperCase()}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label style={{ display: "block", marginBottom: "6px", fontWeight: "500", color: "#374151" }}>Job Title</label>
          <select style={selectStyle} value={jobTitleId} onChange={(e) => handleJobTitleChange(e.target.value)}>
            <option value="">All Job Titles</option>
            {jobTitles.map((jt) => (
              <option key={jt.id} value={jt.id}>
                {jt.title}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label style={{ display: "block", marginBottom: "6px", fontWeight: "500", color: "#374151" }}>Countries</label>
          <select style={selectStyle} value={countryId} onChange={(e) => handleCountryChange(e.target.value)}>
            <option value="">All Countries</option>
            {countries.map((country) => (
              <option key={country.id} value={country.id}>
                {country.name}
              </option>
            ))}
          </select>
        </div>

        <div style={{ display: "flex", alignItems: "flex-end", gap: "8px" }}>
          <button 
            style={{
              ...buttonStyle, 
              background: myCompanyInsight ? "#7c3aed" : "#ef4444",
              flex: 1
            }} 
            onClick={handleMyCompanyInsight}
          >
            {myCompanyInsight ? "✓ My Company" : "My Company Insights"}
          </button>
          <button style={buttonStyle} onClick={handleResetFilters}>
            Reset Filters
          </button>
        </div>
      </div>

      {/* Insights Cards */}
      {insights && Object.keys(insights).length > 0 ? (
        <div style={insightsGridStyle}>
          {Object.entries(insights).map(([key, data]) => (
            <div key={key} style={cardStyle}>
              <h3 style={cardTitleStyle}>{key === "overall" ? "Overall" : key.replace(/_/g, " ")}</h3>
              <div style={metricsStyle}>
                <div style={metricRowStyle}>
                  <span style={metricLabelStyle}>Average Salary</span>
                  <span style={averageColorStyle}>${data.average.toLocaleString(undefined, { maximumFractionDigits: 2 })}</span>
                </div>
                <div style={metricRowStyle}>
                  <span style={metricLabelStyle}>Minimum Salary</span>
                  <span style={minColorStyle}>${data.min.toLocaleString()}</span>
                </div>
                <div style={metricRowStyle}>
                  <span style={metricLabelStyle}>Maximum Salary</span>
                  <span style={maxColorStyle}>${data.max.toLocaleString()}</span>
                </div>
                <div style={metricRowStyle}>
                  <span style={metricLabelStyle}>Employee Count</span>
                  <span style={metricValueStyle}>{data.count}</span>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <p>No salary data available</p>
      )}
    </div>
  );
}
