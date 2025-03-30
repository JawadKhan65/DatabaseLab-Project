import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createDispatch = async (req, res) => {
    try {
        const { order_id, dispatched_by } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('order_id', sql.Int, order_id)
                   .input('dispatched_by', sql.Int, dispatched_by || null);
        
        const result = await poolRequest.execute('createDispatch');
        
        res.json({ success: true, message: 'Dispatch created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createDispatch };