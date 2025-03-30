import { createSale } from "../controllers/sale_controller.js";
const saleRouter = express.Router();
saleRouter.post("/create", verifyToken, createSale);
export default saleRouter;
