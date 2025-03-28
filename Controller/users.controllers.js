import { connectDB } from "../connectDB.js";
import { hashPassword, generateToken, verifyToken, comparePassword } from "../utils/verification.js";
import sql from "mssql";



const createUser = async (req, res) => {
    try {
        let { firstName, lastName, email, phone, password, role } = req.body;
        const pool = await connectDB();
        password = (await hashPassword(password)).data;
        console.log(password);
        const poolRequest = pool.request();
        poolRequest
            .input('firstName', sql.VarChar, firstName)
            .input('lastName', sql.VarChar, lastName)
            .input('email', sql.VarChar, email)
            .input('phone', sql.VarChar, phone)
            .input('password', sql.VarChar, password)
            .input('role', sql.VarChar, role)

        const result = await poolRequest.execute('createUser');
        // auth token generation

        let authToken = await generateToken({ firstName: firstName, lastName: lastName, email: email, phone: phone, role: role });
        console.log(authToken);

        res.header('auth-token', authToken.data
        ).json({ success: true, data: result.recordset, authToken: authToken.data });


    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const updatePassword = async (req, res) => {
    try {
        const { email, password } = req.body;
        const pool = await connectDB();


        if (req.user.email !== email) {
            return res.status(403).json({ success: false, message: "Unauthorized Access" });
        }
        const poolRequest = pool.request();
        const password_hash = (await hashPassword(password)).data;
        poolRequest.input('email', sql.VarChar, email)
            .input('password', sql.VarChar, password_hash)
        const result = await poolRequest.execute('updatePassword');
        res.json({ success: true, data: result.recordset });

    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });

    }
}

const getUserId = async (req, res) => {
    try {
        const { email } = req.body
        const pool = await connectDB();


        const poolRequest = pool.request();
        poolRequest.input('email', sql.VarChar, email)
        const result = await poolRequest.execute('getUserId');
        res.json({ success: true, data: result.recordset });

    }
    catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const deleteUser = async (req, res) => {
    try {
        const { email } = req.body;
        const pool = await connectDB();


        const poolRequest = pool.request();

        poolRequest.input('email', sql.VarChar, email)
        const result = await poolRequest.execute('deleteUser');


        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const getUserDetails = async (req, res) => {
    try {
        const { email } = req.body;
        const pool = await connectDB();


        const poolRequest = pool.request();
        poolRequest.input('email', sql.VarChar, email)
        const result = await poolRequest.execute('getUserDetails');
        res.json({ success: true, data: result.recordset });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}

const login = async (req, res) => {
    try {
        const { email_, password } = req.body;
        const pool = await connectDB();
        const poolRequest = pool.request();
        poolRequest.input('email', sql.VarChar, email_)

        const result = await poolRequest.execute('login');
        if (result.recordset[0].success === 0) {
            return res.status(401).json({ success: false, data: 'Invalid Credentials' });
        }
        const passwordMatch = await comparePassword(password, result.recordset[0]?.password_hash);
        if (passwordMatch.success === false) {
            return res.status(401).json({ success: false, data: 'Invalid Credentials' });

        }
        if (passwordMatch.data === false) {
            return res.status(401).json({ success: false, data: 'Invalid Credentials' });
        }
        const { firstName, lastName, email, phone, role, password_hash } = result.recordset[0];
        let authToken = await generateToken({ firstName: firstName, lastName: lastName, email: email, phone: phone, role: role });
        console.log(authToken);
        res.header('auth-token', authToken.data).json({ success: true, data: result.recordset, authToken: authToken.data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
}








export { createUser, getUserId, getUserDetails, updatePassword, deleteUser, login }