import { createBudget } from "../controllers/budget_controller.js";
const budgetRouter = express.Router();
budgetRouter.post("/create", verifyToken, createBudget);
export default budgetRouter;
