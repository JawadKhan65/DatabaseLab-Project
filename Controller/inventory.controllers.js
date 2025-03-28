import { connectDB } from "../connectDB.js";
import sql from "mssql";


const pool = await connectDB();


const createInventory = async (req, res) => {
    const { user_id, product_name, quantity, price, category } = req.body;
    try {

        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('product_name', sql.VarChar, product_name)
            .input('quantity', sql.Int, quantity)
            .input('price', sql.Decimal, price)
            .input('category', sql.VarChar, category)
        const result = await poolRequest.execute('createInventory');
        res.status(200).json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });

    }
}


const getInventories = async (req, res) => {
    const { user_id } = req.body;
    try {

        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
        const result = await poolRequest.execute('getInventories');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateInventory = async (req, res) => {
    const { email, user_id, inventory_id, product_name, quantity, price, category } = req.body;
    try {
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest
            .input('inventory_id', sql.Int, inventory_id)
            .input('user_id', sql.Int, user_id)
            .input('product_name', sql.VarChar, product_name)
            .input('quantity', sql.Int, quantity)
            .input('price', sql.Decimal, price)
            .input('category', sql.VarChar, category)
        const result = await poolRequest.execute('updateInventory')
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message })

    }
}


const deleteInventory = async (req, res) => {
    try {
        const { email, user_id, inventory_id } = req.body
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }

        const pool = await connectDB()
        const poolRequest = pool.request()
        poolRequest.input('user_id', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
        const result = await poolRequest.execute('deleteInventory')
        res.json({ success: true, data: result.recordset })

    } catch (error) {
        res.status(500).json({ success: false, error: error.message })

    }
}



export { createInventory, getInventories, updateInventory, deleteInventory }