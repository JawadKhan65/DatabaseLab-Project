import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createSale = async (req, res) => {
    try {
        const { email, user_id, supplier_id, order_id, total_amount, saleType } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }

        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id || null)
            .input('order_id', sql.Int, order_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount)
            .input('saleType', sql.VarChar(30), saleType)
            .input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('createSale');

        res.json({ success: true, message: 'Sale created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const deleteSale = async (req, res) => {
    try {
        const { email, sale_id, user_id } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('sale_id', sql.Int, sale_id)
            .input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('deleteSale');

        res.json({ success: true, message: 'Sale deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateSale = async (req, res) => {
    try {
        const { email, user_id, sale_id, supplier_id, order_id, total_amount } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('sale_id', sql.Int, sale_id)
            .input('supplier_id', sql.Int, supplier_id || null)
            .input('order_id', sql.Int, order_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount)
            .input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('updateSale');

        res.json({ success: true, message: 'Sale updated successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const getSales = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getSales');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


export { createSale, deleteSale, updateSale, getSales };
