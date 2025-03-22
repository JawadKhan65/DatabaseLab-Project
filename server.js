import express from "express";
import sql from "mssql";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Initialize the Express app
const app = express();
app.use(express.json());

const sqlConfig = {
    server: process.env.SERVER_NAME, // Use the correct instance name
    database: process.env.DATABASE_NAME,
    user: process.env.DATABASE_USER, // Replace with your SQL Server username
    password: process.env.DATABASE_PASSWORD, // Replace with your SQL Server password
    driver: "ODBC Driver 18 for SQL Server",
    options: {
        encrypt: false,
        trustServerCertificate: true
    }
};


async function connectDB() {
    let pool = await sql.connect(sqlConfig);
    try {
        console.log("✅ Database connected successfully!");
        return pool;
    } catch (err) {
        console.error("❌ Database Connection Failed:", err);
        process.exit(1);
    }
}

// Define a route to handle the SQL query
const pool = await connectDB();
app.get("/test-db", async (req, res) => {
    try {
        const result = await pool.request().query("SELECT GETDATE() AS CurrentTime");
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

// Start the Express Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});