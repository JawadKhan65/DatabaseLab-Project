import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createExpense = async (req, res) => {
    try {
        const { category, amount, description, department_id } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('category', sql.VarChar, category)
                   .input('amount', sql.Decimal(15,2), amount)
                   .input('description', sql.Text, description || null)
                   .input('department_id', sql.Int, department_id);
        
        const result = await poolRequest.execute('createExpense');
        
        res.json({ success: true, message: 'Expense created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createExpense };