import { createExpense } from "../controllers/expense_controller.js";
const expenseRouter = express.Router();
expenseRouter.post("/create", verifyToken, createExpense);
export default expenseRouter;
