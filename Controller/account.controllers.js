import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createAccount = async (req, res) => {
    try {
        const { account_name, balance, user_id } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('account_name', sql.VarChar(255), account_name)
                   .input('balance', sql.Decimal(15,2), balance)
                   .input('user_id', sql.Int, user_id);
        
        const result = await poolRequest.execute('createAccount');
        
        res.json({ success: true, message: 'Account created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createAccount };
