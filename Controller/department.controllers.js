import { connectDB } from "../connectDB.js";
import sql from "mssql";

const createDepartment = async (req, res) => {
    try {
        const { user_id, department_name } = req.body;
        const pool = await connectDB();

        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('department_name', sql.VarChar, department_name);

        const result = await poolRequest.execute('createDepartment');

        res.json({ success: true, message: 'Department created successfully', data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

const deleteDepartment = async (req, res) => {
    try {
        const { email, user_id, department_id } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('user_id', sql.Int, user_id)
            .input('department_id', sql.Int, department_id);

        const result = await poolRequest.execute('deleteDepartment');
        res.json({ success: true, message: 'Department deleted successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}

const updateDepartment = async (req, res) => {
    try {
        const { email, user_id, department_id, department_name } = req.body;
        if (!req.user || req.user.email !== email) {
            return res.status(401).json({ success: false, message: 'Access Denied' });
        }

        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('department_id', sql.Int, department_id)
            .input('user_id', sql.Int, user_id)
            .input('department_name', sql.VarChar, department_name);

        const result = await poolRequest.execute('updateDepartment');
        res.json({ success: true, message: 'Department updated successfully', data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}

const getDepartments = async (req, res) => {
    try {
        const pool = await connectDB();
        const poolRequest = pool.request();

        const result = await poolRequest.execute('getDepartments');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}

const getDepartmentById = async (req, res) => {
    try {
        const { department_id } = req.body;
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('department_id', sql.Int, department_id);

        const result = await poolRequest.execute('getDepartmentById');

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, error: error.message });
    }
}


export { createDepartment, deleteDepartment, updateDepartment, getDepartments, getDepartmentById };
