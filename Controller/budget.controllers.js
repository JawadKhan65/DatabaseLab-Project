import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createBudget = async (req, res) => {
    try {
        const { email, user_id, department_id, allocated_amount } = req.body;

        if (!email || !user_id || !department_id || !allocated_amount) {
            return res.status(400).json({ success: false, message: 'All fields are required' });
        }
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }

        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('department_id', sql.Int, department_id)
            .input('allocated_amount', sql.Decimal(15, 2), allocated_amount)
            .input('user_id', sql.Int, user_id)

        const result = await poolRequest.execute('createBudget');

        res.json({ success: true, message: 'Budget created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const deleteBudget = async (req, res) => {
    try {
        const { email, department_id, user_id, budget_id } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('budget_id', sql.Int, budget_id).input('department_id', sql.Int, department_id).input('user_id', sql.Int, user_id)


        const result = await poolRequest.execute('deleteBudget');

        res.json({ success: true, message: 'Budget deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateBudget = async (req, res) => {
    try {
        const { budget_id, user_id, department_id, allocated_amount } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('budget_id', sql.Int, budget_id)
            .input('department_id', sql.Int, department_id)
            .input('allocated_amount', sql.Decimal(15, 2), allocated_amount)
            .input('user_id', sql.Int, user_id)

        const result = await poolRequest.execute('updateBudget');

        res.json({ success: true, message: 'Budget updated successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getBudgets = async (req, res) => {
    try {
        const { email, user_id } = req.body;
        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: 'Unauthorized' });
        }
        if (!user_id) {
            return res.status(400).json({ success: false, message: 'User ID is required' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
        const result = await poolRequest.execute('getBudgets');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createBudget, deleteBudget, updateBudget, getBudgets };