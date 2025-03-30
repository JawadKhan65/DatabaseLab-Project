import { createPurchase } from "../controllers/purchase_controller.js";
const purchaseRouter = express.Router();
purchaseRouter.post("/create", verifyToken, createPurchase);
export default purchaseRouter;
