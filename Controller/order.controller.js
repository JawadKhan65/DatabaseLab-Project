import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createOrder = async (req, res) => {
    try {
        const { supplier_id, total_amount } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id)
                   .input('total_amount', sql.Decimal(15,2), total_amount);
        
        const result = await poolRequest.execute('createOrder');
        
        res.json({ success: true, message: 'Order created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createOrder };
