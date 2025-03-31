import { createAccount, deleteAccount, getAccounts, updateAccount } from "../Controller/account.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router();



router.post("/create", createAccount)

router.get("/getAccounts", verifyToken, getAccounts)
router.put("/update", verifyToken, updateAccount)
router.delete("/delete", verifyToken, deleteAccount)


export default router;
