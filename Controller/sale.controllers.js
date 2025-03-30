import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createSale = async (req, res) => {
    try {
        const { supplier_id, order_id, total_amount, saleType } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id || null)
                   .input('order_id', sql.Int, order_id)
                   .input('total_amount', sql.Decimal(15,2), total_amount)
                   .input('saleType', sql.VarChar(30), saleType);
        
        const result = await poolRequest.execute('createSale');
        
        res.json({ success: true, message: 'Sale created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createSale };
