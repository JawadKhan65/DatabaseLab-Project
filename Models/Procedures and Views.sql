
use Project
--Procedures for Users Table

create procedure createUser 
	@firstName VARCHAR(255),
	@lastName VARCHAR(255),
	@email VARCHAR(255),
	@phone VARCHAR(15),
	@password VARCHAR(255),
	@role VARCHAR(20)
as
begin
	IF NOT EXISTS (SELECT 1 FROM users WHERE email = @email)
	begin
    INSERT INTO users (firstName, lastName, email, phone, password_hash, role)
    VALUES (@firstName, @lastName, @email, @phone, @password, @role);
	select 1 as success ,'user created' as data 
	end
	else
	begin
	select 0 as success, 'Failed to create user' as message
	end
	

end



exec createUser @firstName='jk', @lastName='lk',@email='jk@email.com',@phone='+92-302-4310826',@password='123',@role='admin'




create procedure deleteUser 
	@email varchar(255)
as
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin
		delete from users
		where email=@email
		select 1 as success,'deletion succcessfull' as message
	end
	else
	begin
	select 0 as success, 'Failed to create user' as message
	end
end

exec deleteUser @email = 'jk@email.com'



create procedure updatePassword
	@email varchar(255),
	@password varchar(255)

as
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin

		update users
		set password_hash=@password
		where email=@email
		select 1 as success, 'updated password' as message
	end
	else
	begin
		select 0 as success,'couldnt update password' as message
	end
	
end

exec updatePassword @email='jk@email.com' , @password='456'

create procedure getUserId
	@email varchar(255)

as 
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin 
		select 1 as success, id from users
		where email=@email

	end
	else
	begin
	select 0 as success,'couldnt fettch userID' as message
	end

end


exec getUserId @email='jk@email.com'


select * from users


create procedure login
	@email varchar(255)

as 
begin
	if exists(
		select 1 from users
		where email=@email
	)
	begin

		select 1 as success,firstName,lastName,email,phone,role,password_hash from users
		where email=@email
	end
	else
	begin
		select 0 as  success, 'No such user' as message
	end
end


create procedure getUserDetails
	@email varchar(255)

as 
begin
	if exists(
	select 1 from users
	where email=@email
	)
	begin 
		select 1 as success, * from users
		where email=@email

	end
	else
	begin
	select 0 as success,'couldnt fettch userDetails' as message
	end

end


-- Procedures for Inventory Management

create procedure createInventory
	@user_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price decimal(10,2)
as
begin
 insert into inventory(user_id,product_name,category,quantity,price)
 values
 (@user_id,@product_name,@category,@quantity,@price)
end



create procedure getInventories
	@user_id int
	
as

begin
	if exists(
	select 1 from inventory I
	left join  inventory_permissions IP on I.id = IP.inventory_id
	where I.user_id=@user_id
	and (I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type='writePrimary') )
	
	)
	begin 
		select * from inventory
		
	end
	else
	begin 
		select 0 as success
	end
end






create procedure updateInventory
	@user_id int,
	@inventory_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price decimal(10,2)
as 
begin
	if exists(
		select 1 from inventory I
		left join inventory_permissions IP on IP.inventory_id = I.id
		where I.id = @inventory_id
		And ( I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type = 'writePrimary'))
	)
	begin
		update inventory
		set product_name=@product_name,category=@category,quantity=@quantity,price=@price,last_updated=GETDATE()
		where id=@inventory_id 
		--return something back for handling
		select 1 as 'success'
	end
	ELSE
    BEGIN
        SELECT 0 AS 'success'
    END
	
end





create procedure deleteInventory
	@user_id int,
	@inventory_id int
as 
begin
	if exists(
		select 1 from inventory I
		left join inventory_permissions IP on IP.inventory_id = I.id
		where I.id = @inventory_id
		And ( I.user_id = @user_id or (IP.user_id = @user_id and IP.permission_type = 'writePrimary'))
	)
	begin
		delete from inventory
		where id=@inventory_id 
		--return something back for handling
		select 1 as 'success'
	end
	ELSE
    BEGIN
        SELECT 0 AS 'success'
    END
	
end




--procedures for Access Managment
 
CREATE PROCEDURE grantAccess
    @inventory_id INT,
    @user_id_giver INT,
    @user_id_grant INT,
    @permission_type VARCHAR(50)
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inventory 
        WHERE id = @inventory_id AND user_id = @user_id_giver
    )
    AND EXISTS (
        SELECT 1 FROM users 
        WHERE id = @user_id_grant
    )
    BEGIN
        -- Check if permission already exists
        IF NOT EXISTS (
            SELECT 1 FROM inventory_permissions 
            WHERE user_id = @user_id_grant 
            AND inventory_id = @inventory_id
        )
        BEGIN
            INSERT INTO inventory_permissions(user_id, inventory_id, permission_type)
            VALUES (@user_id_grant, @inventory_id, @permission_type);
            SELECT 1 AS success, 'Access Granted' AS message;
        END
        ELSE
        BEGIN
            SELECT 0 AS success, 'User already has permissions for this inventory' AS message;
        END
    END
    ELSE
    BEGIN
        SELECT 0 AS success, 'Grant Access Denied - Either inventory doesn''t belong to giver or user doesn''t exist' AS message;
    END
END



create procedure checkAccess
	@user_id_grant int,
	@inventory_id int
as
begin
	select distinct inventory_id from inventory_permissions
	where user_id=@user_id_grant
end

create procedure deleteAccess
	@user_id_grant int,
	@inventory_id int
as
begin
	delete from inventory_permissions
	where user_id = @user_id_grant and inventory_id=@inventory_id

end

create procedure updateAccess
	@user_id_grant int,
	@inventory_id int,
	@permission_type

as 
begin
	update inventory_permissions
	set permission_type=@permission_type
	where user_id = @user_id_grant and inventory_id=@inventory_id

end





--- for other inventory

create procedure createOtherInventory
	@user_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price int

as 
begin
insert into OtherInventory(user_id,product_name,category,quantity,price)
 values
 (@user_id,@product_name,@category,@quantity,@price)
	
end




create procedure getOtherInventory
	@user_id int,
	@inventory_id int

as 
begin
	if exists(
		select 1 from OtherInventory O
		left join inventory_permissions IP on IP.inventory_id=O.id
		where O.id= @inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id and IP.permission_type='writeSecondary'))
	)
	begin
		select * from OtherInventory
		where id=@inventory_id
	end
	else
	begin
	select 0 as success
	end
end

create procedure updateOtherInventory
	@user_id int,
	@inventory_id int,
	@product_name varchar(255),
	@category varchar(255),
	@quantity int,
	@price int
as
begin
	if exists(
		select 1 from OtherInventory O
		left join inventory_permissions IP on IP.inventory_id = O.id
		where O.id=@inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id) and IP.permission_type = 'writeSecondary')
	)
	begin
	Update OtherInventory
	set product_name=@product_name, category=@category,quantity=@quantity,price=@price,last_updated=GETDATE()
	where id=@inventory_id
	end
	else
	begin
	select 0 as success
	end
end




create procedure deleteOtherInventory
	@user_id int,
	@inventory_id int
as
begin
	if exists(
		select 1 from OtherInventory O 
		left join inventory_permissions IP on IP.inventory_id = O.id
		where O.id=@inventory_id
		and (O.user_id=@user_id or (IP.user_id=@user_id and IP.permission_type='writeSecondary'))
	)
	begin
		select 1 as success
	end
	else
	begin
	select 0 as success
	end
end


---- department procedures

create procedure createDepartment
	@user_id int,
	@department_name varchar(255)
as
begin
	insert into departments(name,user_id)
	values
	(@department_name,@user_id)
end


create procedure getDepartments
	@user_id int,
	@department_id int
	

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	select  1 as success, * from departments
	where id =@department_id and user_id=@user_id

	
	end
	else
	begin
		select 0 as success , 'updation failed' as message
	end

end




create procedure updateDepartment
	@user_id int,
	@department_id int,
	@name varchar(255)

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	update departments
	set name=@name
	where id =@department_id and user_id=@user_id

	select 1 as success, 'updated successfully' as message
	end
	else
	begin
		select 0 as success , 'updation failed' as message
	end

end


create procedure deleteDepartment
	@user_id int,
	@department_id int

as
begin
	if exists(
		select 1 from departments
		where id=@department_id and user_id=@user_id
	)
	begin
	delete from  departments
	where id =@department_id and user_id=@user_id
	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end

end











CREATE PROCEDURE createSupplier
    @name VARCHAR(255),
	@user_id int,
    @email VARCHAR(255) = NULL,
    @phone VARCHAR(20) = NULL,
    @address TEXT = NULL
AS
BEGIN
    INSERT INTO suppliers (name,user_id, email, phone, address)
    VALUES (@name,@user_id, @email, @phone, @address);
END



create procedure updateSupplier
	@supplier_id int,
	@name VARCHAR(255),
	@user_id int,
    @email VARCHAR(255) = NULL,
    @phone VARCHAR(20) = NULL,
    @address TEXT = NULL
as 
begin
	if exists(
	select  1 from suppliers
	where id=@supplier_id and USER_ID=@user_id
	)
	begin
	update suppliers
	set name=@name,address=@address,email=@email,phone=@phone
	where id=@supplier_id and USER_ID=@user_id

	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end
end


create procedure deleteSupplier
	@supplier_id int,
	@user_id int
as 
begin
	if exists(
	select  1 from suppliers
	where id=@supplier_id  and user_id =@user_id
	)
	begin
	delete from suppliers
	where  id=@supplier_id  and user_id =@user_id

	select 1 as success, 'deleted successfully' as message
	end
	else
	begin
		select 0 as success , 'deletion failed' as message
	end
end




-- Procedure to Create Expense
CREATE PROCEDURE createExpense
    @category VARCHAR(255),
    @amount DECIMAL(15,2),
    @description TEXT = NULL,
    @department_id INT
AS
BEGIN
    INSERT INTO expenses (category, amount, description, department_id)
    VALUES (@category, @amount, @description, @department_id);
END

create procedure updateExpense
	@expense_id int,
	@user_id int,
	@category varchar(255),
	@amount varchar(255),
	@description varchar(255),
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		update expenses
		set category=@category, amount=@amount,description=@description
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		select 1 as success, 'Updation Succesfull' as message
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end



create procedure deleteExpense
	@expense_id int,
	@user_id int,
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		delete from expenses
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		select 1 as success, 'Updation Succesfull' as message
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end


create procedure getExpenses
	@expense_id int,
	@user_id int,
	@department_id int

as
begin
	if exists(
	select 1 from expenses
	where id=@expense_id and user_id=@user_id  and department_id=@department_id
	)
	begin
		select 1 as success, * from expenses
		where  id=@expense_id and user_id=@user_id  and department_id=@department_id
		
	end
	else
	begin
		select 0 as success , 'Updation Failed' as message


	end
end



-- Procedure to Create Budget
CREATE PROCEDURE createBudget
    @department_id INT,
    @allocated_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO budget (department_id, allocated_amount)
    VALUES (@department_id, @allocated_amount);
END


CREATE PROCEDURE updateBudget
	@budget_id int,
	@user_id int,
    @department_id INT,
    @allocated_amount DECIMAL(15,2)

AS
BEGIN
	if exists(
		select 1 from budget
		where id=@budget_id and user_id=@user_id and department_id=@department_id
	)
	begin
		update budgets
		set allocated_amount = @allocated_amount
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END



CREATE PROCEDURE deleteBudget
	@budget_id int,
	@user_id int,
    @department_id INT,
   

AS
BEGIN
	if exists(
		select 1 from budget
		where id=@budget_id and user_id=@user_id and department_id=@department_id
	)
	begin
		delete from budgets 
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END



CREATE PROCEDURE getBudgets
	
	@user_id int,
    @department_id INT,
  

AS
BEGIN
	if exists(
		select 1 from budget
		where user_id=@user_id and department_id=@department_id
	)
	begin
		select 1 as success,* from budgets
		where id=@budget_id and user_id=@user_id and department_id=@department_id

		select 1 as success, 'Updation Successfull' as message
	end
	else
	begin
	select 0 as success , 'Updation Failed' as message

	end

END



CREATE PROCEDURE createOrder
    @supplier_id INT,
	@user_id int,
    @total_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO orders (user_id,supplier_id, total_amount)
    VALUES (@user_id,@supplier_id, @total_amount);
END


create procedure deleteOrder
	@supplier_id int,
	@user_id int,
	@order_id int,
begin
	delete from orders 
	where user_id=@user_id and id=@order_id and supplier_id = @supplier_id
end

create procedure updateOrder
	@supplier_id int,
	@user_id int,
	@order_id int,
	@total_amount decimal(15,2)
as
begin
	update orders
	set total_amount=@total_amount
	where user_id=@user_id and id=@order_id and supplier_id = @supplier_id
end

create procedure getOrders
	@user_id int
as
begin
	select * from orders
	where user_id=@user_id
end



-- Procedure to Create Dispatch
CREATE PROCEDURE createDispatch
    @order_id INT,
    @dispatched_by INT = NULL
AS
BEGIN
    INSERT INTO dispatch (order_id, dispatched_by)
    VALUES (@order_id, @dispatched_by);
END






-- Procedure to Create Sale
CREATE PROCEDURE createSale
    @supplier_id INT = NULL,
    @order_id INT,
    @total_amount DECIMAL(15,2),
    @saleType VARCHAR(30)
AS
BEGIN
    INSERT INTO sales (supplier_id, order_id, total_amount, saleType)
    VALUES (@supplier_id, @order_id, @total_amount, @saleType);
END






-- Procedure to Create Purchase
CREATE PROCEDURE createPurchase
    @supplier_id INT,
    @total_amount DECIMAL(15,2)
AS
BEGIN
    INSERT INTO purchases (supplier_id, total_amount)
    VALUES (@supplier_id, @total_amount);
END





-- Procedure to Create Account
CREATE PROCEDURE createAccount
    @account_name VARCHAR(255),
    @balance DECIMAL(15,2),
    @user_id INT
AS
BEGIN
    INSERT INTO accounts (account_name, balance, userid)
    VALUES (@account_name, @balance, @user_id);
END