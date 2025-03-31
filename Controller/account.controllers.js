import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createAccount = async (req, res) => {
    try {
        const { account_name, balance, user_id } = req.body;
        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('account_name', sql.VarChar(255), account_name)
            .input('balance', sql.Decimal(15, 2), balance)
            .input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('createAccount');

        res.json({ success: true, message: 'Account created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const deleteAccount = async (req, res) => {
    try {
        const { email, user_id, account_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('account_id', sql.Int, account_id);

        const result = await poolRequest.execute('deleteAccount');
        res.json({ success: true, message: 'Account deleted successfully', data: result.recordset });

    }
    catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateAccount = async (req, res) => {

    try {
        const { email, user_id, account_id, account_name, balance } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('account_id', sql.Int, account_id)
            .input('user_id', sql.Int, user_id)
            .input('account_name', sql.VarChar(255), account_name)
            .input('balance', sql.Decimal(15, 2), balance);

        const result = await poolRequest.execute('updateAccount');
        res.json({ success: true, message: 'Account updated successfully', data: result.recordset });

    }
    catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}
const getAccounts = async (req, res) => {
    try {
        const { user_id } = req.body;
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('getAccounts');
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}

export { createAccount, deleteAccount, getAccounts, updateAccount };
