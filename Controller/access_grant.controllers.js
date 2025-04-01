import { connectDB } from "../connectDB.js";
import sql from "mssql";


const giveAccess = async (req, res) => {
    try {
        const { email, user_id_giver, user_id_grant, inventory_id, permission_type } = req.body;
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id_giver', sql.Int, user_id_giver)
            .input('inventory_id', sql.Int, inventory_id)
            .input('permission_type', sql.VarChar, permission_type)
            .input("user_id_grant", sql.Int, user_id_grant)

        const result = await poolRequest.execute('grantAccess');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });

    }
}

const checkAccess = async (req, res) => {
    try {

        const { email, user_id, inventory_id } = req.body;
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id_grant', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
        const result = await poolRequest.execute('checkAccess');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const deleteAccess = async (req, res) => {
    try {
        const { email, user_id, inventory_id } = req.body;
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id_grant', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
        const result = await poolRequest.execute('deleteAccess');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateAccess = async (req, res) => {
    try {
        const { email, user_id, inventory_id, permission_type } = req.body;
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id_grant', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
            .input('permission_type', sql.VarChar, permission_type)
        const result = await poolRequest.execute('updateAccess');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

export { giveAccess, checkAccess, deleteAccess, updateAccess };