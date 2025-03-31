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

const deleteDispatch = async (req, res) => {
    try {
        const { email, user_id, dispatch_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('dispatch_id', sql.Int, dispatch_id);

        const result = await poolRequest.execute('deleteDispatch');
        res.json({ success: true, message: 'Dispatch deleted successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateDispatch = async (req, res) => {
    try {
        const { email, user_id, dispatch_id, order_id, dispatched_by } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('dispatch_id', sql.Int, dispatch_id)
            .input('user_id', sql.Int, user_id)
            .input('order_id', sql.Int, order_id)
            .input('dispatched_by', sql.Int, dispatched_by || null);

        const result = await poolRequest.execute('updateDispatch');
        res.json({ success: true, message: 'Dispatch updated successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const getDispatches = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getDispatches');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createDispatch, deleteDispatch, updateDispatch, getDispatches };