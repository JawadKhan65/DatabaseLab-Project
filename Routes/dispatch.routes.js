import { createDispatch, deleteDispatch, getDispatches, updateDispatch } from "../Controller/dispatch.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";

const router = express.Router()


router.post("/create", verifyToken, createDispatch)
router.get("/getDispatches", verifyToken, getDispatches)
router.put("/update", verifyToken, updateDispatch)
router.delete("/delete", verifyToken, deleteDispatch)

export default router;
