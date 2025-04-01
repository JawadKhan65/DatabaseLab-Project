import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createOrder = async (req, res) => {
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

        const result = await poolRequest.execute('createOrder');

        res.json({ success: true, message: 'Order created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const deleteOrder = async (req, res) => {
    try {
        const { email, order_id, supplier_id, user_id } = req.body;
        if (req.user.email !== email) {
            res.status(403).json({ success: false, message: 'Unauthorized' });
            return;
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('order_id', sql.Int, order_id)
            .input('supplier_id', sql.Int, supplier_id)
            .input('user_id', sql.Int, user_id)

        const result = await poolRequest.execute('deleteOrder');

        res.json({ success: true, message: 'Order deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const updateOrder = async (req, res) => {
    try {
        const { email, user_id, order_id, supplier_id, total_amount, status } = req.body;
        if (req.user.email !== email) {
            res.status(403).json({ success: false, message: 'Unauthorized' });
            return;
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('order_id', sql.Int, order_id)
            .input('supplier_id', sql.Int, supplier_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount)
            .input('user_id', sql.Int, user_id)
            .input('status', sql.Int, status)

        const result = await poolRequest.execute('updateOrder');

        res.json({ success: true, message: 'Order updated successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getOrders = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getOrders');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};



export { createOrder, deleteOrder, updateOrder, getOrders };
