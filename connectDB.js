import dotenv from 'dotenv'
import sql from 'mssql'



dotenv.config();



async function connectDB() {
    const sqlConfig = {
        server: process.env.SERVER_NAME, // Use the correct instance name
        database: process.env.DATABASE_NAME,
        user: process.env.DATABASE_USER, // Replace with your SQL Server username
        password: process.env.DATABASE_PASSWORD, // Replace with your SQL Server password
        // driver: "ODBC Driver 18 for SQL Server",
        options: {
            encrypt: false,
            trustServerCertificate: true
        }
    };
    let pool = await sql.connect(sqlConfig);
    try {
        console.log(" Database connected successfully!");
        return pool;
    } catch (err) {
        console.error(" Database Connection Failed:", err);
        process.exit(1);
    }
}



export { connectDB }

