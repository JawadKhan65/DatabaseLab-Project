


import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createOtherInventory = async (req, res) => {
    const { user_id, product_name, quantity, price, category } = req.body;
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('product_name', sql.VarChar(255), product_name)
            .input('quantity', sql.Int, quantity)
            .input('price', sql.Int, price)  // Changed from Decimal to Int (based on your SQL)
            .input('category', sql.VarChar(255), category);

        const result = await poolRequest.execute('createOtherInventory');
        res.status(200).json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const getOtherInventories = async (req, res) => {
    const { user_id } = req.body;
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('getOtherInventories');
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateOtherInventory = async (req, res) => {
    const { email, user_id, inventory_id, product_name, quantity, price, category } = req.body;
    try {
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }
        
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('inventory_id', sql.Int, inventory_id)
            .input('user_id', sql.Int, user_id)
            .input('product_name', sql.VarChar(255), product_name)
            .input('quantity', sql.Int, quantity)
            .input('price', sql.Int, price)
            .input('category', sql.VarChar(255), category);
        
        const result = await poolRequest.execute('updateOtherInventory');
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const deleteOtherInventory = async (req, res) => {
    try {
        const { email, user_id, inventory_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id);

        const result = await poolRequest.execute('deleteOtherInventory');
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createOtherInventory, getOtherInventories, updateOtherInventory, deleteOtherInventory };

