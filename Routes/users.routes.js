import { createUser, updatePassword, getUserDetails, getUserId, deleteUser, login } from '../Controller/users.controllers.js'
import express from "express";
import { verifyToken } from '../utils/verification.js';


const router = express.Router()

router.route('/createUser').post(createUser)
router.route('/updatePassword').put(verifyToken, updatePassword)
router.route('/getUserId').get(verifyToken, getUserId)
router.route('/getUser').get(verifyToken, getUserDetails)
router.route('/deleteUser').delete(verifyToken, deleteUser)
router.route('/login').post(login)

export default router
