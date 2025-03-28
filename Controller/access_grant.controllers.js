import { connectDB } from "../connectDB.js";
import sql from "mssql";


const giveAccess = async (req, res) => {
    try {
        const { email, user_id, inventory_id, permission_type } = req.body;
        if (req.user?.email !== email) {
            return res.status(401).json({ success: false, data: 'Access Denied' })
        }
        const pool = await connectDB()
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
            .input('permission_type', sql.VarChar, permission_type)

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
        poolRequest.input('user_id', sql.Int, user_id)
            .input('inventory_id', sql.Int, inventory_id)
        const result = await poolRequest.execute('checkAccess');
        res.json({ success: true, data: result.recordset });

    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

export { giveAccess, checkAccess }