import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';

export const verifyToken = (req, res, next) => {
    /**
     * This function will be used as a middleware to verify some action for example any CRUD operation inside the app despite authentication.
     * This function evaluates a callback function to check for an error and return particular result.
     * parameters includes auth-token took from header then return is success,and data.
     */
    const token = req.header('auth-token')
    console.log("verifying jwt token...")
    if (!token) {
        console.log("no token available...")
        return { success: false, data: 'Access Denied' }
    }
    try {
        const verified = jwt.verify(token, process.env.SECRET_TOKEN, (err, decoded) => {
            if (err) {
                return null
            }
            return decoded
        })
        console.log("token verified...")
        req.user = verified
        next()
        return { success: true }

    }
    catch (error) {
        console.log("error verifying token...", error)
        return { success: false }
    }
}


export const decodeToken = (token) => {
    try {
        /** 
         * This function will be used to use information from token stored at the users end.
         * Return the payload attached while generating the token.
         * parameters includes token.
        */
        console.log("decoding token...")
        const decoded = jwt.decode(token)
        console.log("token decoded...")
        return { success: true, data: decoded }
    }
    catch (error) {
        console.log("error decoding token...", error)
        return { success: false, data: error }
    }
}

export const generateToken = async (data) => {
    /**
     * This function will be used to generate token for the user.
     * Return the token generated.
     * parameters includes data:we call payload, to be stored in token.
     */
    try {
        console.log("generating token...")
        const token = await jwt.sign(data, process.env.SECRET_TOKEN)
        console.log("token generated...")
        return { success: true, data: token }
    }

    catch (error) {
        console.log("error generating token...", error)
        return { success: false, data: null }
    }
}


export const hashPassword = async (password) => {
    /**
     * This function will be used to hash the password.
     * Hashed Password is the safety measure to save users password breach by tokenizing using RSA256 algorithm.
     * It add a salt for the password to make it more secure, and then hash it.
     * Return the hashed password.
     * parameters includes password.
     */
    try {
        console.log("hashing password...")
        const salt = await bcrypt.genSalt(10)
        const hashedPassword = await bcrypt.hash(password, salt)
        console.log("password hashed...")
        return { success: true, data: hashedPassword }
    }
    catch (error) {
        console.log("error hashing password...", error)
        return { success: false, data: null }

    }

}



export const comparePassword = async (password, hashedPassword) => {
    /**
     * This function will be used to compare the password with the hashed password.
     * Return the result of comparison.
     * parameters includes password and hashedPassword.
     */
    try {
        console.log("comparing password...")
        const isMatch = await bcrypt.compare(password, hashedPassword)
        console.log("password compared...")
        return { success: true, data: isMatch }
    }
    catch (error) {
        console.log("error comparing password...", error)
        return { success: false, data: null }
    }
}


console.log(await comparePassword('12345678', '$2b$10$hwRIa7nisZntaZhG./GB5uGChSk/z2BCxWXngsvAemd80bF.A5Iyi'))

// console.log(await decodeToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJKYXdhZCIsImxhc3ROYW1lIjoia2hhbiIsImVtYWlsIjoiamF3YWRraGFuODkwQGdtYWlsLmNvbSIsInBob25lIjoiOTItMzM1LTM1MTIxMjMiLCJyb2xlIjoibWFuYWdlciIsImlhdCI6MTc0MjgzMTI0NX0.me0OM0z3Yy9O_axXyWtf6VlSR7jKi3YRq_ij1MMHb7Y'))
