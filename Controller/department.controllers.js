import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createDepartment = async (req, res) => {
    try {
        const { user_id, department_name } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
                   .input('department_name', sql.VarChar, department_name);
        
        const result = await poolRequest.execute('createDepartment');
        
        res.json({ success: true, message: 'Department created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createDepartment };
