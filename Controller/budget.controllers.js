import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createBudget = async (req, res) => {
    try {
        const { department_id, allocated_amount } = req.body;
        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('department_id', sql.Int, department_id)
            .input('allocated_amount', sql.Decimal(15, 2), allocated_amount);

        const result = await poolRequest.execute('createBudget');

        res.json({ success: true, message: 'Budget created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const deleteBudget = async (req, res) => {
    try {
        const { budget_id } = req.body;

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('budget_id', sql.Int, budget_id);

        const result = await poolRequest.execute('deleteBudget');

        res.json({ success: true, message: 'Budget deleted successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateBudget = async (req, res) => {
    try {
        const { budget_id, department_id, allocated_amount } = req.body;

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('budget_id', sql.Int, budget_id)
            .input('department_id', sql.Int, department_id)
            .input('allocated_amount', sql.Decimal(15, 2), allocated_amount);

        const result = await poolRequest.execute('updateBudget');

        res.json({ success: true, message: 'Budget updated successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const getBudgets = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getBudgets');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

export { createBudget, deleteBudget, updateBudget, getBudgets };