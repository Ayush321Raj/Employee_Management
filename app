
import { useEffect, useState } from "react";
import "./App.css";

const API = "http://localhost:5000/employees";

const emptyForm = {
  name: "",
  email: "",
  department: "",
  salary: ""
};

function App() {
  const [employees, setEmployees] = useState([]);
  const [form, setForm] = useState(emptyForm);
  const [editId, setEditId] = useState(null);
  const [message, setMessage] = useState("");

  async function loadEmployees() {
    try {
      const response = await fetch(API);
      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Could not load employees");
      setEmployees(data);
    } catch (error) {
      setMessage(error.message);
    }
  }

  useEffect(() => {
    loadEmployees();
  }, []);

  function handleChange(event) {
    setForm({ ...form, [event.target.name]: event.target.value });
  }

  async function handleSubmit(event) {
    event.preventDefault();

    try {
      const response = await fetch(
        editId ? `${API}/${editId}` : API,
        {
          method: editId ? "PUT" : "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(form)
        }
      );

      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Request failed");

      setMessage(data.message);
      setForm(emptyForm);
      setEditId(null);
      await loadEmployees();
    } catch (error) {
      setMessage(error.message);
    }
  }

  function editEmployee(employee) {
    setEditId(employee.id);
    setForm({
      name: employee.name,
      email: employee.email,
      department: employee.department,
      salary: String(employee.salary)
    });
    setMessage("");
  }

  async function deleteEmployee(id) {
    if (!window.confirm("Are you sure you want to delete this employee?")) {
      return;
    }

    try {
      const response = await fetch(`${API}/${id}`, {
        method: "DELETE"
      });

      const data = await response.json();
      if (!response.ok) throw new Error(data.error || "Delete failed");

      setMessage(data.message);
      if (editId === id) {
        setEditId(null);
        setForm(emptyForm);
      }
      await loadEmployees();
    } catch (error) {
      setMessage(error.message);
    }
  }

  function cancelEdit() {
    setEditId(null);
    setForm(emptyForm);
    setMessage("");
  }

  return (
    <div className="container">
      <h1>Employee Management System</h1>
      <p className="subtitle">Manage employee records easily</p>

      <form onSubmit={handleSubmit} className="employee-form">
        <h2>{editId ? "Edit Employee" : "Add Employee"}</h2>

        <input
          name="name"
          placeholder="Employee Name"
          value={form.name}
          onChange={handleChange}
          required
        />

        <input
          name="email"
          type="email"
          placeholder="Email Address"
          value={form.email}
          onChange={handleChange}
          required
        />

        <input
          name="department"
          placeholder="Department"
          value={form.department}
          onChange={handleChange}
          required
        />

        <input
          name="salary"
          type="number"
          min="0"
          step="0.01"
          placeholder="Salary"
          value={form.salary}
          onChange={handleChange}
          required
        />

        <button type="submit">
          {editId ? "Update Employee" : "Add Employee"}
        </button>

        {editId && (
          <button type="button" className="cancel" onClick={cancelEdit}>
            Cancel
          </button>
        )}
      </form>

      {message && <p className="message">{message}</p>}

      <h2>Employee List ({employees.length})</h2>

      <div className="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Email</th>
              <th>Department</th>
              <th>Salary</th>
              <th>Actions</th>
            </tr>
          </thead>

          <tbody>
            {employees.map((employee) => (
              <tr key={employee.id}>
                <td>{employee.id}</td>
                <td>{employee.name}</td>
                <td>{employee.email}</td>
                <td>{employee.department}</td>
                <td>₹{Number(employee.salary).toLocaleString("en-IN")}</td>
                <td>
                  <button onClick={() => editEmployee(employee)}>
                    Edit
                  </button>
                  {" "}
                  <button
                    className="delete"
                    onClick={() => deleteEmployee(employee.id)}
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))}

            {employees.length === 0 && (
              <tr>
                <td colSpan="6">No employees found</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default App;
