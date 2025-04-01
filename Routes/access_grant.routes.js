import { verifyToken } from "../utils/verification.js";
import { giveAccess, checkAccess, deleteAccess, updateAccess } from "../Controller/access_grant.controllers.js";
import express from 'express'


const router = express.Router()

router.route('/giveAccess').post(verifyToken, giveAccess)
router.route('/checkAccess').post(verifyToken, checkAccess)
router.route("/updateAccess").post(verifyToken, updateAccess)
router.route("/deleteAccess").post(verifyToken, deleteAccess)



export default router