Project Structure:

Controllers will contain function logics
Models Contains Schema
MiddleWare Contains Verification Functionalities
Routers Contains the routes attached with controller functions
use these routes in server.js

also you can use middleware and error handlers

app.use(/api/hello,require(file))

database schema:


Core Tables
1. Users
Purpose: Stores employee, manager, and admin accounts.

Fields:

ID (unique identifier), first name, last name, email (unique), phone (format: +[country code]-[area code]-[number]), password, role (admin, employee, manager), and creation date.

Relationships:

Linked to Access Management for permissions.

Linked to Dispatch to track who dispatched orders.

2. Access Management
Purpose: Defines user permissions.

Fields:

ID, user ID (linked to Users), role, and specific permissions (e.g., "read inventory," "write expenses").

Inventory & Suppliers
3. Inventory
Purpose: Tracks products in stock.

Fields:

ID, product name, category, quantity, price, last updated date.

Relationships:

Linked to Suppliers (via supplier_id).

4. Suppliers
Purpose: Stores supplier details.

Fields:

ID, name, email, phone, address.

5. OtherInventory
Purpose: Backup or secondary inventory storage (e.g., archived/discontinued items).

Fields: Same as Inventory, linked to Suppliers.

Orders & Sales
6. Customers
Purpose: Stores customer details.

Fields:

ID, name, email, phone, address.

7. Orders
Purpose: Tracks customer orders.

Fields:

ID, customer ID (linked to Customers), total amount, order date, status (e.g., "pending," "delivered").

8. Sales
Purpose: Records completed sales.

Fields:

ID, customer ID (optional), order ID (linked to Orders), total amount, sale date, payment type (cash or credit).

Relationships:

Uses Sale Details to list items sold.

9. Sale Details
Purpose: Breaks down items within a sale.

Fields:

ID, sale ID (linked to Sales), inventory ID (linked to Inventory), quantity, price.

Purchases
10. Purchases
Purpose: Tracks bulk purchases from suppliers.

Fields:

ID, supplier ID (linked to Suppliers), total amount, purchase date.

Relationships:

Uses Purchase Details to list items purchased.

11. Purchase Details
Purpose: Breaks down items within a purchase.

Fields:

ID, purchase ID (linked to Purchases), inventory ID (linked to Inventory), quantity, price.

Dispatch
12. Dispatch
Purpose: Manages order fulfillment.

Fields:

ID, order ID (linked to Orders), employee ID (linked to Users), dispatch date, status (pending, dispatched, delivered).

Finance & Budget
13. Departments
Purpose: Defines departments (e.g., "Sales," "Warehouse").

Fields:

ID, name (unique).

14. Budget
Purpose: Tracks departmental budgets.

Fields:

ID, department ID (linked to Departments), allocated amount, spent amount, creation date.

15. Expenses
Purpose: Records costs (e.g., utilities, shipping).

Fields:

ID, category, amount, description, date, department ID (linked to Departments).

16. Accounts
Purpose: Tracks company bank accounts.

Fields:

ID, account name, balance, last transaction date.

AI & Analytics
17. AI Insights
Purpose: Stores automated reports (e.g., "low stock alerts," "sales trends").

Fields:

ID, analysis type, result, generation date.

Key Improvements
Normalization:

Suppliers, departments, and customers are stored in dedicated tables to avoid duplication.

Granular Tracking:

Sales and purchases now use detail tables (sale_details, purchase_details) to track individual items.

Clear Relationships:

Orders link to customers, dispatch, and sales.

Expenses and budgets are tied to departments.

Consistency:

Phone numbers use a standardized international format.

Permissions are role-based and explicit.