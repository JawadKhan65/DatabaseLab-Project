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


const deleteSupplier = async (req, res) => {
    try {
        const { email, user_id, supplier_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('supplier_id', sql.Int, supplier_id);

        const result = await poolRequest.execute('deleteSupplier');
        res.json({ success: true, message: 'Supplier deleted successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};


const updateSupplier = async (req, res) => {
    try {
        const { email, user_id, supplier_id, name, phone, address } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id)
            .input('user_id', sql.Int, user_id)
            .input('name', sql.VarChar, name)
            .input('phone', sql.VarChar, phone || null)
            .input('address', sql.Text, address || null);

        const result = await poolRequest.execute('updateSupplier');
        res.json({ success: true, message: 'Supplier updated successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const getSuppliers = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getSuppliers');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};
export { createSupplier, deleteSupplier, updateSupplier, getSuppliers };