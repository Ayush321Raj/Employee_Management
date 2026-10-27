
const express = require("express");
const cors = require("cors");
const db = require("./db");

const app = express();

app.use(cors());
app.use(express.json());

// GET: View all employees
app.get("/employees", (req, res) => {
  db.query("SELECT * FROM employees", (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// POST: Add employee
app.post("/employees", (req, res) => {
  const { name, email, department, salary } = req.body;

  if (!name || !email || !department ||
      salary === undefined || salary === null ||
      salary === "" || !Number.isFinite(Number(salary)) ||
      Number(salary) < 0) {
    return res.status(400).json({ error: "Enter valid employee details" });
  }

  const sql = "INSERT INTO employees (name, email, department, salary) VALUES (?, ?, ?, ?)";

  db.query(sql, [name, email, department, salary], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.status(201).json({
      message: "Employee added successfully",
      id: result.insertId
    });
  });
});

// PUT: Edit employee
app.put("/employees/:id", (req, res) => {
  const { name, email, department, salary } = req.body;

  if (!name || !email || !department ||
      salary === undefined || salary === null ||
      salary === "" || !Number.isFinite(Number(salary)) ||
      Number(salary) < 0) {
    return res.status(400).json({ error: "Enter valid employee details" });
  }

  const sql = "UPDATE employees SET name=?, email=?, department=?, salary=? WHERE id=?";

  db.query(sql, [name, email, department, salary, req.params.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Employee not found" });
    }
    res.json({ message: "Employee updated successfully" });
  });
});

// DELETE: Remove employee
app.delete("/employees/:id", (req, res) => {
  db.query("DELETE FROM employees WHERE id=?", [req.params.id], (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Employee not found" });
    }
    res.json({ message: "Employee deleted successfully" });
  });
});

app.listen(5000, () => {
  console.log("Server running at http://localhost:5000");
});
