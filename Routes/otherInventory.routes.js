import { createOtherInventory, getOtherInventories, updateOtherInventory, deleteOtherInventory } from "../Controller/otherInventry.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router();
router.post("/createInventory", verifyToken, createOtherInventory);
router.get("/getInventories", verifyToken, getOtherInventories);
router.put("/updateInventory", verifyToken, updateOtherInventory);
router.delete("/deleteInventory", verifyToken, deleteOtherInventory);
export default router;
