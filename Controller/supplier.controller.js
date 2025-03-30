import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createSupplier = async (req, res) => {
    try {
        const { name, email, phone, address } = req.body;
        const pool = await connectDB();
        
        const poolRequest = pool.request();
        poolRequest.input('name', sql.VarChar, name)
                   .input('email', sql.VarChar, email || null)
                   .input('phone', sql.VarChar, phone || null)
                   .input('address', sql.Text, address || null);
        
        const result = await poolRequest.execute('createSupplier');
        
        res.json({ success: true, message: 'Supplier created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createSupplier };