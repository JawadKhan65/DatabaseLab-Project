import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createExpense = async (req, res) => {
    try {
        const { email, user_id, category, amount, description, department_id } = req.body;
        const pool = await connectDB();

        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }
        const poolRequest = pool.request();
        poolRequest.input('category', sql.VarChar, category)
            .input('amount', sql.Decimal(15, 2), amount)
            .input('description', sql.Text, description || null)
            .input('department_id', sql.Int, department_id)
            .input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('createExpense');

        res.json({ success: true, message: 'Expense created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


const deleteExpense = async (req, res) => {
    try {
        const { email, user_id, expense_id, department_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('expense_id', sql.Int, expense_id)
            .input('department_id', sql.Int, department_id);

        const result = await poolRequest.execute('deleteExpense');
        res.json({ success: true, message: 'Expense deleted successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const updateExpense = async (req, res) => {
    try {
        const { email, user_id, expense_id, category, amount, description, department_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('expense_id', sql.Int, expense_id)
            .input('user_id', sql.Int, user_id)
            .input('category', sql.VarChar, category)
            .input('amount', sql.Decimal(15, 2), amount)
            .input('description', sql.Text, description || null)
            .input('department_id', sql.Int, department_id);

        const result = await poolRequest.execute('updateExpense');
        res.json({ success: true, message: 'Expense updated successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};

const getExpenses = async (req, res) => {
    try {
        const { email, user_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }
        const pool = await connectDB();
        const poolRequest = pool.request()
        poolRequest.input('user_id', sql.Int, user_id);

        const result = await poolRequest.execute('getExpenses');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
};



export { createExpense, deleteExpense, updateExpense, getExpenses };