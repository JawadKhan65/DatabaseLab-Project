import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createPurchase = async (req, res) => {
    try {
        const { email, user_id, supplier_id, total_amount } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount)
            .input('user_id', sql.Int, user_id)


        const result = await poolRequest.execute('createPurchase');

        res.json({ success: true, message: 'Purchase created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const deletePurchase = async (req, res) => {
    try {
        const { email, user_id, purchase_id } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('purchase_id', sql.Int, purchase_id)
            .input('user_id', sql.Int, user_id)

        const result = await poolRequest.execute('deletePurchase');

        res.json({ success: true, message: 'Purchase deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const updatePurchase = async (req, res) => {
    try {
        const { email, user_id, purchase_id, supplier_id, total_amount } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('purchase_id', sql.Int, purchase_id)
            .input('supplier_id', sql.Int, supplier_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount)
            .input('user_id', sql.Int, user_id)

        const result = await poolRequest.execute('updatePurchase');

        res.json({ success: true, message: 'Purchase updated successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getPurchases = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getPurchases');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


export { createPurchase, deletePurchase, updatePurchase, getPurchases };