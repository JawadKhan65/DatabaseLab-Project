import { createInventory, updateInventory, getInventories, deleteInventory } from "../Controller/inventory.controllers.js";
import express from "express";
import { verifyToken } from "../utils/verification.js";



const router = express.Router()

router.route('/createInventory').post(createInventory)
router.route('/updateInventory').put(verifyToken, updateInventory)
router.route('/getInventories').get(getInventories)
router.route('/deleteInventory').delete(verifyToken, deleteInventory)


export default router