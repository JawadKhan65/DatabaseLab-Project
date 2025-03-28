import { verifyToken } from "../utils/verification.js";
import { giveAccess, checkAccess } from "../Controller/access_grant.controllers.js";
import express from 'express'


const router = express.Router()

router.route('/giveAccess').post(verifyToken, giveAccess)
router.route('/checkAccess').post(verifyToken, checkAccess)



export default router