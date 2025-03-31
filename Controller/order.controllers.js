import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createOrder = async (req, res) => {
    try {
        const { supplier_id, total_amount } = req.body;
        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('supplier_id', sql.Int, supplier_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount);

        const result = await poolRequest.execute('createOrder');

        res.json({ success: true, message: 'Order created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const deleteOrder = async (req, res) => {
    try {
        const { order_id } = req.body;

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('order_id', sql.Int, order_id);

        const result = await poolRequest.execute('deleteOrder');

        res.json({ success: true, message: 'Order deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const updateOrder = async (req, res) => {
    try {
        const { order_id, supplier_id, total_amount } = req.body;

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('order_id', sql.Int, order_id)
            .input('supplier_id', sql.Int, supplier_id)
            .input('total_amount', sql.Decimal(15, 2), total_amount);

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
