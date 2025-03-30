import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createBudget = async (req, res) => {
    try {
        const { department_id, allocated_amount } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('department_id', sql.Int, department_id)
                   .input('allocated_amount', sql.Decimal(15,2), allocated_amount);
        
        const result = await poolRequest.execute('createBudget');
        
        res.json({ success: true, message: 'Budget created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createBudget };